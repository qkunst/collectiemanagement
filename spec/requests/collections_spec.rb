require 'rails_helper'

RSpec.describe "Collections", type: :request do
  describe "GET /collections" do
    it "shouldn't be publicly accessible!" do
      get collections_path
      expect(response).to have_http_status(302)
    end
  end
end
