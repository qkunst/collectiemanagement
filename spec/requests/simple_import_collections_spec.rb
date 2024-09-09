require "rails_helper"

RSpec.describe "SimpleImportCollections", type: :request do
  describe "GET /new" do
    it "returns http success" do
      get "/simple_import_collections/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get "/simple_import_collections/create"
      expect(response).to have_http_status(:success)
    end
  end
end
