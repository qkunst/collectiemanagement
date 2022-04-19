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

  context "facility_manager" do
    before do
      sign_in users(:facility_manager)
    end
    describe "GET api/v1/works/" do
      let(:total) { 3 }

      it "returns ok" do

        get api_v1_collection_works_path(collections(:collection_with_works), format: :json)
        expect(response).to be_ok
        response.body
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
        expect(JSON.parse(response.body)["meta"]["total_count"]).to eq (total - 1)
      end

      it "returns all desired fields" do
        get api_v1_collection_works_path(collections(:collection_with_works), format: :json)

        keys = JSON.parse(response.body)["data"].flat_map{|a| a.keys}.uniq


        %w[title_rendered artist_name_rendered object_categories
        object_creation_year
        height_with_fallback
        width_with_fallback
        depth_with_fallback
        diameter_with_fallback
        for_purchase for_rent selling_price highlight public_description created_at import_collection_id object_format_code themes availability_status
      ].each do |key|
          expect(keys).to include key
        end
      end

      it "plucks" do
        get api_v1_collection_works_path(collections(:collection_with_works), format: :json, pluck: [:id])

        expect(JSON.parse(response.body)["data"].sort).to eq(collections(:collection_with_works).works_including_child_works.pluck(:id).sort)

        get api_v1_collection_works_path(collections(:collection_with_works), format: :json, pluck: [:id, :stock_number])

        expect(JSON.parse(response.body)["data"].sort).to eq(collections(:collection_with_works).works_including_child_works.pluck(:id, :stock_number).sort)
      end
    end
  end

end
