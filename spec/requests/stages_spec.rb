require 'rails_helper'

RSpec.describe "Stages", type: :request do
  describe "GET /stages" do
    it "rejects" do
      get stages_path
      expect(response).to have_http_status(302)
    end
  end
end
