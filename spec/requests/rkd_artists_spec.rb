# frozen_string_literal: true

require "rails_helper"

RSpec.describe "RKD::Artists", type: :request do
  describe "GET /rkd_artists" do
    it "shouldn't be publicly accessible" do
      get rkd_artists_path
      expect(response).to have_http_status(302)
    end
    it "should be accessible by QKunst" do
      sign_in users(:qkunst)
      get rkd_artists_path
      expect(response).to have_http_status(200)
      sign_in users(:appraiser)
      get rkd_artists_path
      expect(response).to have_http_status(200)
    end
    it "should not be accessible by facility_manager" do
      sign_in users(:facility_manager)
      get rkd_artists_path
      expect(response).to have_http_status(302)
    end
    it "should be accessible by admin" do
      sign_in users(:admin)
      get rkd_artists_path
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /rkd_artists/123" do
    before do
      allow(RKD::Artist).to receive(:find).and_return(RKD::Artist.new(name: "Aafjes", id: 12))
    end
    it "shouldn't be publicly accessible" do
      get rkd_artist_path(12)
      expect(response).to have_http_status(302)
    end
    it "should be accessible by QKunst" do
      sign_in users(:qkunst)
      get rkd_artist_path(12)
      expect(response).to have_http_status(200)
      sign_in users(:appraiser)
      get rkd_artist_path(12)
      expect(response).to have_http_status(200)
    end
    it "should not be accessible by facility_manager" do
      sign_in users(:facility_manager)
      get rkd_artist_path(12)
      expect(response).to have_http_status(302)
    end
    it "should be accessible by admin" do
      sign_in users(:admin)
      get rkd_artist_path(12)
      expect(response).to have_http_status(200)
      expect(response.body).to match("Aafjes")
    end
  end
end
