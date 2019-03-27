# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "Attachments", type: :request do
  describe "GET /attachments" do
    it "redirects by default" do
      get new_collection_attachment_path(collections(:collection1))
      expect(response).to have_http_status(302)
    end
    it "redirects by default when not qkunst" do
      sign_in users(:read_only_user)
      get new_collection_attachment_path(collections(:collection1))
      expect(response).to have_http_status(302)
    end
    it "redirects by default when not qkunst (fm)" do
      sign_in users(:facility_manager)
      get new_collection_attachment_path(collections(:collection1))
      expect(response).to have_http_status(302)
    end
    it "redirects by default when qkunst without access" do
      sign_in users(:qkunst)
      get new_collection_attachment_path(collections(:collection1))
      expect(response).to have_http_status(302)
    end
    it "success when qkunst with acces" do
      sign_in users(:qkunst_with_collection)
      get new_collection_attachment_path(collections(:collection1))
      expect(response).to have_http_status(200)
    end
    it "success when admin" do
      sign_in users(:admin)
      get new_collection_attachment_path(collections(:collection1))
      expect(response).to have_http_status(200)
    end
  end
end
