require 'rails_helper'

RSpec.describe "Collections", type: :request do
  describe "GET /collections" do
    it "shouldn't be publicly accessible!" do
      c = collections(:collection1)
      get api_v1_collection_works_path(1)
      expect(response).to have_http_status(401)
      get api_v1_collection_works_path(11232)
      expect(response).to have_http_status(401)
      get api_v1_collection_works_path(c.id)
      expect(response).to have_http_status(401)
    end
  end
end

# http://localhost:3000/api/v1/collections/1/works/