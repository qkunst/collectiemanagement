# frozen_string_literal: true

require "rails_helper"

RSpec.describe Api::V1::WorkEventsController, type: :request do
  # include Devise::Test::ControllerHelpers

  let(:start_rental_attributes) {
    {contact_uri: "http://customers/123", event_type: "rental_outgoing", status: "active"}
  }

  describe "POST api/v1/work/:work_id/work_events" do
    let(:work) { works(:work5) }
    let(:start_rental_attributes_post_call) {
      post api_v1_collection_work_work_events_path(work.collection, work, params: {work_event: start_rental_attributes}, format: :json)
    }
    it "unauthorized when not signed in" do
      expect {
        start_rental_attributes_post_call
      }.to change(TimeSpan, :count).by(0)

      expect(response).to be_unauthorized
    end

    it "starts a rental when signed in" do
      sign_in users(:admin)

      expect {
        start_rental_attributes_post_call
      }.to change(TimeSpan, :count).by(1)

      expect(response).to be_successful

      work.reload
      expect(work.availability_status).to eql(:lent)
    end

    it "starts a reservation when signed in" do
      sign_in users(:admin)

      expect {
        post api_v1_collection_work_work_events_path(work.collection, work, params: {work_event: start_rental_attributes.merge(status: :reservation)}, format: :json)
      }.to change(TimeSpan, :count).by(1)

      expect(response).to be_successful

      work.reload
      expect(work.availability_status).to eql(:reserved)
    end

    it "cannot start a rental twice when signed in" do
      sign_in users(:admin)

      expect {
        start_rental_attributes_post_call
      }.to change(TimeSpan, :count).by(1)

      expect(response).to be_successful

      expect {
        post api_v1_collection_work_work_events_path(work.collection, work, params: {work_event: start_rental_attributes}, format: :json)
      }.to change(TimeSpan, :count).by(0)

      expect(response).not_to be_successful

      expect(work.availability_status).to eql(:lent)
    end

    it "can start a reservation after a rental when signed in" do
      sign_in users(:admin)

      expect {
        start_rental_attributes_post_call
      }.to change(TimeSpan, :count).by(1)

      expect(response).to be_successful

      expect {
        post api_v1_collection_work_work_events_path(work.collection, work, params: {work_event: start_rental_attributes.merge(status: :reservation)}, format: :json)
      }.to change(TimeSpan, :count).by(1)

      expect(response).to be_successful

      expect(work.availability_status).to eql(:lent)
    end

    it "ends a rental when signed in" do
      sign_in users(:admin)

      contact = contacts(:contact1)

      expect(work.availability_status).to eql(:available)

      time_span = TimeSpan.create(starts_at: 1.year.ago, contact: contact, subject: work, status: :active, classification: :rental_outgoing, collection: work.collection)

      work_id = work.id
      work = Work.find(work_id)
      expect(work.availability_status).to eql(:lent)

      expect {
        post api_v1_collection_work_work_events_path(work.collection, work, params: {work_event: {contact_uri: contact.url, event_type: "rental_outgoing", status: "finished", time_span_uuid: time_span.uuid}}, format: :json)
      }.to change(TimeSpan, :count).by(0)

      expect(response).to be_successful

      work_id = work.id
      work = Work.find(work_id)

      expect(work.availability_status).to eql(:available)
    end
  end
end
