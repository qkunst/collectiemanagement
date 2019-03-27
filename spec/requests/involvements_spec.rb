# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "Involvements", type: :request do
  describe "GET /involvements" do
    it "works! (now write some real specs)" do
      get involvements_path
      expect(response).to have_http_status(302)
    end
  end
end
