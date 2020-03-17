# frozen_string_literal: true

require "rails_helper"

RSpec.describe OfflineController, type: :controller do
  describe "GET #work_form" do
    it "returns http success" do
      get :work_form
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #offline" do
    it "returns http success" do
      get :offline
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #collection" do
    it "returns http success" do
      get :collection
      expect(response).to have_http_status(:success)
    end
  end
end
