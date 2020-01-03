# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WorksController, type: :controller do
  include Devise::Test::ControllerHelpers

  describe "GET /works" do
    it "should be able to get an index" do
      sign_in users(:admin)

      c = collections(:collection1)
      get :index, params: {collection_id: c.id}
      expect(response).to be_successful
    end
    it "should be able to get an index als xlsx" do
      sign_in users(:admin)

      c = collections(:collection1)
      get :index, params: {collection_id: c.id, format: :xlsx}
      expect(response).to be_successful
    end
  end

  describe "PATCH/PUT #works" do
    it "shouldn't change anything by default" do
      work = works(:work1)
      # work1:
      #   title: Work1
      #   grade_within_collection: A
      #   themes:
      #     - :earth
      #     - :wind
      #   subset: :contemporary
      #   collection: :collection_with_works
      #   artists:
      #     - :artist1
      put :update, params: {collection_id: work.collection.to_param, id: work.to_param, work: {title: "Werk1"}}
      work.reload
      expect(work.title).to eq("Work1")
    end
    it "shouldn't be change title when role == facility" do
      work = works(:work1)
      sign_in users(:facility_manager)
      put :update, params: {collection_id: work.collection.to_param, id: work.to_param, work: {title: "Werk1"}}
      work.reload
      expect(work.title).to eq("Work1")
    end
    it "shouldn't be change location when role == facility" do
      work = works(:work1)
      sign_in users(:facility_manager)
      expect(work.location).to eq("Adres")
      put :update, params: {collection_id: work.collection.to_param, id: work.to_param, work: {location: "werk", location_detail: "Mijn kantoor"}}
      work.reload
      expect(work.location).to eq("werk")
      expect(work.location_detail).to eq("Mijn kantoor")
    end
    it "qkunst admin should be able to edit all fields" do
      work = works(:work1)
      sign_in users(:admin)
      expect(work.location).to eq("Adres")
      valid_data = {
        location: "werk", internal_comments: "Interne beslommering", title: "Titel"
      }
      put :update, params: {collection_id: work.collection.to_param, id: work.to_param, work: valid_data }
      work.reload
      valid_data.each do |k,v|
        expect(work.send(k)).to eq(v)
      end
    end
  end
end
