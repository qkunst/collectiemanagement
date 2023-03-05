# frozen_string_literal: true

require "rails_helper"

RSpec.describe Api::V1::TimeSpansController, type: :request do
  # include Devise::Test::ControllerHelpers

  describe "POST api/v1/work/:work_id/time_spans" do
    it "returns a 404, even as an admin, no writing" do
      sign_in users(:admin)

      expect {
        post api_v1_time_spans_path(params: {}, format: :json)
      }.to raise_error(ActionController::RoutingError)
    end
  end

  describe "GET api/v1/work/:work_id/time_spans" do
    it "returns all as an admin" do
      sign_in users(:admin)

      get api_v1_time_spans_path(format: :json)

      json_response = JSON.parse(response.body)
      expect(json_response["data"].count).to eql(TimeSpan.count)
      expect(response).to be_successful
    end

    it "returns all as an admin" do
      get api_v1_time_spans_path(format: :json)

      json_response = JSON.parse(response.body)
      expect(json_response["message"]).to eq("Not authorized")
      expect(response).to be_unauthorized
    end

    it "allows for filtering on external contact url" do
      sign_in users(:admin)

      get api_v1_time_spans_path(params: {contact_url: "http://uitleen/contact/2"}, format: :json)

      json_response = JSON.parse(response.body)
      expect(json_response["data"].count).to eql(1)
    end

    describe "subject_type" do
      it "allows for filtering on subject typed" do
        sign_in users(:admin)
        get api_v1_time_spans_path(params: {subject_type: "WorkSet"}, format: :json)
        json_response = JSON.parse(response.body)
        expect(json_response["data"].count).to eql(1)
        expect(json_response["data"][0]["subject_type"]).to eq("WorkSet")
      end
    end
  end
end
