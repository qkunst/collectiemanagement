# frozen_string_literal: true

require "rails_helper"

RSpec.describe Api::V1::TimeSpansController, type: :request do
  # include Devise::Test::ControllerHelpers

  describe "POST api/v1/work/:work_id/time_spans" do
    it "returns a 404, even as an admin, no writing" do
      sign_in users(:admin)

      post api_v1_time_spans_path(params: {}, format: :json)
      expect(response).to be_not_found
    end
  end

  describe "GET api/v1/work/:work_id/time_spans" do
    it "returns unauthorized when not logged in" do
      get api_v1_time_spans_path(format: :json)

      json_response = JSON.parse(response.body)
      expect(json_response["message"]).to eq("Not authorized")
      expect(response).to be_unauthorized
    end

    context "admin" do
      before do
        sign_in users(:admin)
      end

      it "returns all as an admin" do
        get api_v1_time_spans_path(format: :json)

        json_response = JSON.parse(response.body)
        expect(json_response["data"].count).to eql(TimeSpan.count)
        expect(response).to be_successful
      end

      it "allows for filtering on external contact url" do
        get api_v1_time_spans_path(params: {contact_url: "http://uitleen/contact/2"}, format: :json)

        json_response = JSON.parse(response.body)
        expect(json_response["data"].count).to eql(1)
      end

      describe "subject_type" do
        it "allows for filtering on subject typed" do
          get api_v1_time_spans_path(params: {subject_type: "WorkSet"}, format: :json)
          json_response = JSON.parse(response.body)
          expect(json_response["data"].count).to eql(1)
          expect(json_response["data"][0]["subject_type"]).to eq("WorkSet")
        end
      end

      describe "ends_at_lt" do
        it "allows for filtering on end date" do
          get api_v1_time_spans_path(params: {ends_at_lt: "2021-02-01"}, format: :json)
          json_response = JSON.parse(response.body)
          expect(json_response["data"].count).to eql(TimeSpan.where("ends_at < ?", Date.new(2021, 2, 1)).count)
        end

        it "returns more when filtering on future end date" do
          get api_v1_time_spans_path(params: {ends_at_lt: "2605-01-01"}, format: :json)
          json_response = JSON.parse(response.body)
          expect(json_response["data"].count).to eql(TimeSpan.where("ends_at < ?", Date.new(2605, 1, 1)).count)
        end
      end

      describe "period" do
        it "allows for filtering on end date" do
          get api_v1_time_spans_path(params: {period: {end: "2021-02-01"}}, format: :json)
          json_response = JSON.parse(response.body)
          expect(json_response["data"].count).to eql(TimeSpan.period(...Date.new(2021, 2, 1)).count)
        end

        it "allows for filtering on begin and end date" do
          get api_v1_time_spans_path(params: {period: {begin: "2009-01-01", end: "2021-02-01"}}, format: :json)
          json_response = JSON.parse(response.body)
          expect(json_response["data"].count).to eql(TimeSpan.period(Date.new(2009, 1, 1)...Date.new(2021, 2, 1)).count)
        end

        it "allows for filtering on begin" do
          get api_v1_time_spans_path(params: {period: {begin: "2009-01-01"}}, format: :json)
          json_response = JSON.parse(response.body)
          expect(json_response["data"].count).to eql(TimeSpan.period(Date.new(2009, 1, 1)...).count)
        end
      end
    end

    context "advisor" do
      before do
        sign_in users(:advisor)
      end

      it "allows for filtering on external contact url" do
        get api_v1_time_spans_path(params: {contact_url: "http://uitleen/contact/2"}, format: :json)
        json_response = JSON.parse(response.body)
        expect(json_response["data"].count).to eql(1)
      end
    end
  end
end
