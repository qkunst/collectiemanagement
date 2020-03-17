# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Reminders", type: :request do
  describe "GET /reminders" do
    it "redirects" do
      get reminders_path
      expect(response).to have_http_status(302)
    end
  end
end
