# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "Clusters", type: :request do
  describe "GET /clusters" do
    it "not accessible by default" do
      get collection_clusters_path(collections(:collection1))
      expect(response).to have_http_status(302)
    end
    it "accessible by admin" do
      sign_in users(:admin)
      get collection_clusters_path(collections(:collection1))
      expect(response).to have_http_status(200)
    end
    it "is not accessible by a random registrerd user" do
      sign_in users(:user3)
      get collection_clusters_path(collections(:collection1))
      expect(response).to have_http_status(302)
    end
    it "is not accessible by a facility manager with access to the collection" do
      sign_in users(:facility_manager)
      get collection_clusters_path(collections(:collection1))
      expect(response).to have_http_status(302)
    end
  end
end
