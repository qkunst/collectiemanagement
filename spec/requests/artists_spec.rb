# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Artists", type: :request do
  describe "GET /artists" do
    it "shouldn't be publicly accessible" do
      get artists_path
      expect(response).to have_http_status(302)
    end
    it "shouldn't be accessible by QKunst" do
      sign_in users(:qkunst)
      get artists_path
      expect(response).to have_http_status(302)
      sign_in users(:appraiser)
      get artists_path
      expect(response).to have_http_status(302)
    end
    it "should be accessible by admin" do
      sign_in users(:admin)
      get artists_path
      expect(response).to have_http_status(200)
    end
  end
  describe "GET collection/id/artists" do
    it "shouldn't be publicly accessible" do
      get collection_artists_path(collections(:collection1))
      expect(response).to have_http_status(302)
    end
    it "should be accessible by QKunst having access to collection" do
      sign_in users(:qkunst)
      get collection_artists_path(collections(:collection1))
      expect(response).to have_http_status(302)
      sign_in users(:qkunst_with_collection)
      get collection_artists_path(collections(:collection1))
      expect(response).to have_http_status(200)
    end
  end

  describe "POST /artists/clean" do
    it "shouldn't be publicly accessible!" do
      before_count = Artist.count
      post artists_clean_path
      expect(response).to have_http_status(302)
      expect(response.inspect.to_s).not_to match "De vervaardigersdatabase is opgeschoond"
      expect(before_count - Artist.count).to eq 0
    end
    it "should be accessible when logged in as admin" do
      before_count = Artist.count
      user = users(:admin)
      sign_in user
      post artists_clean_path
      expect(response).to have_http_status(302)
      expect(response.inspect.to_s).to match "De vervaardigersdatabase is opgeschoond"
      expect(before_count - Artist.count).to eq 4
    end
    it "should not be accessible when logged in as qkunst" do
      before_count = Artist.count
      user = users(:qkunst)
      sign_in user
      post artists_clean_path
      expect(response).to have_http_status(302)
      expect(response.inspect.to_s).not_to match "De vervaardigersdatabase is opgeschoond"
      expect(before_count - Artist.count).to eq 0
    end
  end
end
