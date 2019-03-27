# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "CustomReportTemplates", type: :request do
  describe "GET /custom_report_templates" do
    it "redirects; cause forbidden by default" do
      get custom_report_templates_path
      expect(response).to have_http_status(302)
    end
  end
end
