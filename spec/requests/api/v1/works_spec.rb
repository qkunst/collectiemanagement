# frozen_string_literal: true

require "rails_helper"

RSpec.describe Api::V1::WorksController, type: :request do
  context "anonymously" do
    describe "GET api/v1/works/" do
      it "returns unauthorized" do
        get api_v1_collection_works_path(collections(:collection_with_works))
        expect(response).to be_unauthorized
      end
    end
  end

  context "advisor" do
    before do
      sign_in users(:advisor)
    end

    describe "GET api/v1/works/:id" do
      let(:time_span) { time_spans(:time_span3) }
      let(:work) { time_span.subject }
      let(:collection) { work.collection }

      it "includes time_spans" do
        get api_v1_collection_work_path(collection, work, format: :json)
        expect(response).to be_ok
        response_data = JSON.parse(response.body)["data"]
        expect(response_data["time_spans"].map { |a| a["uuid"] }).to include(time_span.uuid)
      end
    end
  end

  context "facility_manager" do
    before do
      sign_in users(:facility_manager)
    end
    describe "GET api/v1/works/" do
      let(:total) { 3 }

      it "returns ok" do
        get api_v1_collection_works_path(collections(:collection_with_works), format: :json)
        expect(response).to be_ok
      end

      it "doesn't return works outside own collections" do
        expect {
          get api_v1_collection_works_path(collections(:collection3), format: :json)
        }.to raise_error ActiveRecord::RecordNotFound
      end

      it "returns meta" do
        limit = 2

        get api_v1_collection_works_path(collections(:collection_with_works), format: :json, limit: limit, from: 1)

        expect(JSON.parse(response.body)["meta"]["total_count"]).to eq total
        expect(JSON.parse(response.body)["meta"]["count"]).to eq limit

        get api_v1_collection_works_path(collections(:collection_with_works), format: :json, limit: limit, from: total)

        expect(JSON.parse(response.body)["meta"]["total_count"]).to eq total
        expect(JSON.parse(response.body)["meta"]["count"]).to eq 0
      end

      it "modifies total_count when filter is present" do
        get api_v1_collection_works_path(collections(:collection_with_works), format: :json)
        expect(JSON.parse(response.body)["meta"]["total_count"]).to eq total

        collections(:collection_with_works).works.update_all(significantly_updated_at: Time.now)
        collections(:collection_with_works).works.first.update_columns(significantly_updated_at: 1.year.ago)

        get api_v1_collection_works_path(collections(:collection_with_works), format: :json, significantly_updated_since: 1.week.ago)
        expect(JSON.parse(response.body)["meta"]["total_count"]).to eq(total - 1)
      end

      it "allows for sorting on id" do
        get api_v1_collection_works_path(collections(:collection_with_works), format: :json, sort: :id)
        ids = JSON.parse(response.body)["data"].map { |d| d["id"] }

        get api_v1_collection_works_path(collections(:collection_with_works), format: :json, sort: :"-id")
        ids_desc = JSON.parse(response.body)["data"].map { |d| d["id"] }

        expect(ids).to eq(ids_desc.reverse)
      end

      it "returns all desired fields" do
        get api_v1_collection_works_path(collections(:collection_with_works), format: :json)

        json_data_response = JSON.parse(response.body)["data"]

        keys = json_data_response.flat_map { |a| a.keys }.uniq

        %w[title_rendered artist_name_rendered object_categories
          object_creation_year
          height_with_fallback
          width_with_fallback
          depth_with_fallback
          diameter_with_fallback
          for_purchase for_rent selling_price highlight public_description created_at import_collection_id object_format_code themes availability_status].each do |key|
          expect(keys).to include key
        end

        expect(json_data_response.find { |w| w["stock_number"] == "Q001" }["artists"][0]["description_in_collection_context"]).to match "Private note about artist_1, firstname (1900 - 2000) in Collection with works child (sub of Collection 1 » colection with works)"
        expect(json_data_response.find { |w| w["stock_number"] == "Q002" }["artists"][0]["description_in_collection_context"]).to be_nil
      end

      it "plucks" do
        get api_v1_collection_works_path(collections(:collection_with_works), format: :json, pluck: [:id])

        expect(JSON.parse(response.body)["data"].sort).to eq(collections(:collection_with_works).works_including_child_works.pluck(:id).sort)

        get api_v1_collection_works_path(collections(:collection_with_works), format: :json, pluck: [:id, :stock_number])

        expect(JSON.parse(response.body)["data"].sort).to eq(collections(:collection_with_works).works_including_child_works.pluck(:id, :stock_number).sort)

        # includes :artist_name_for_sorting; used in uitleen
        get api_v1_collection_works_path(collections(:collection_with_works), format: :json, pluck: [:id, :artist_name_for_sorting])

        expect(JSON.parse(response.body)["data"].sort).to eq(collections(:collection_with_works).works_including_child_works.pluck(:id, :artist_name_for_sorting).sort)

        # includes :artist_name_for_sorting; used in uitleen
        get api_v1_collection_works_path(collections(:collection_with_works), format: :json, pluck: [:artist_name_for_sorting, :id])

        expect(JSON.parse(response.body)["data"].sort).to eq(collections(:collection_with_works).works_including_child_works.pluck(:artist_name_for_sorting, :id).sort)
      end
    end
  end

  context "admin" do
    before do
      sign_in users(:admin)
    end
    it "allows for filtering on currently rent", requires_elasticsearch: true do
      get api_v1_collection_works_path(collections(:collection_with_works), format: :json, pluck: [:id], filter: {availability_status: [:lent]})

      expect(JSON.parse(response.body)["data"].sort).to eq([])

      get api_v1_collection_works_path(collections(:collection_with_availability), format: :json, pluck: [:id])
      expect(JSON.parse(response.body)["data"].sort).to eq(collections(:collection_with_availability).works_including_child_works.pluck(:id).sort)

      if Rails.env.test?
        get api_v1_collection_works_path(collections(:collection_with_availability), format: :json, pluck: [:id], filter: {availability_status: [:lent]})
        expect(JSON.parse(response.body)["data"].sort).to eq([works(:collection_with_availability_rent_work).id])
      end
    end

    it "returns a work set with work set type" do
      get api_v1_collection_works_path(collections(:collection3), format: :json)
      work_with_work_sets = JSON.parse(response.body)["data"].find { |a| a["work_sets"] != [] }
      expect(work_with_work_sets["work_sets"].first["work_set_type"]["name"]).not_to be_nil
    end
  end
end
