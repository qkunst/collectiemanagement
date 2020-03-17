# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Messages", type: :request do
  describe "GET /messages" do
    it "shouldn't be publicly accessible!" do
      get messages_path
      expect(response).to have_http_status(302)
    end
  end
end
