require 'rails_helper'

RSpec.describe "Artists", type: :request do
  describe "POST /artists/clean" do
    it "shouldn't be publicly accessible!" do
      before_count = Artist.count
      post artists_clean_path
      expect(response).to have_http_status(302)
      expect(response.inspect.to_s).not_to match "De kunstenaarsdatabase is opgeschoond"
      expect(before_count - Artist.count).to eq 0
    end
    it "should be accessible when logged in as admin" do
      before_count = Artist.count
      user = users(:admin)
      sign_in user
      post artists_clean_path
      expect(response).to have_http_status(302)
      expect(response.inspect.to_s).to match "De kunstenaarsdatabase is opgeschoond"
      expect(before_count - Artist.count).to eq 3
    end
    it "should not be accessible when logged in as qkunst" do
      before_count = Artist.count
      user = users(:qkunst)
      sign_in user
      post artists_clean_path
      expect(response).to have_http_status(302)
      expect(response.inspect.to_s).not_to match "De kunstenaarsdatabase is opgeschoond"
      expect(before_count - Artist.count).to eq 0

    end
  end
end
