# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "CustomReports", type: :request do
  describe "GET /custom_reports" do
    it "redirects! (now write some real specs)" do
      get collection_custom_reports_path(collections(:collection1))
      expect(response).to have_http_status(302)
    end
  end
end
