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
    describe "GET api/v1/works/" do
      it "returns ok" do
        sign_in users(:facility_manager)

        get api_v1_collection_works_path(collections(:collection_with_works), format: :json)
        expect(response).to be_ok
        response.body
      end

      it "returns meta" do
        total = 3
        limit = 2

        sign_in users(:facility_manager)

        get api_v1_collection_works_path(collections(:collection_with_works), format: :json, limit: limit, from: 1)

        expect(JSON.parse(response.body)["meta"]["total_count"]).to eq total
        expect(JSON.parse(response.body)["meta"]["count"]).to eq limit

        get api_v1_collection_works_path(collections(:collection_with_works), format: :json, limit: limit, from: total)

        expect(JSON.parse(response.body)["meta"]["total_count"]).to eq total
        expect(JSON.parse(response.body)["meta"]["count"]).to eq 0
      end

      it "returns all desired fields" do

      end
    end
  end

end
