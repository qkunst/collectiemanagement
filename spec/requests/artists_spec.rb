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

  describe "GET /artists/:id/edit" do
    it "should be accessible for an admin" do
      sign_in users(:admin)
      get edit_artist_path(artists(:artist1))
      expect(response).to have_http_status(200)
      expect(response.body).not_to match("Collectiespecifieke")
    end

    context "/collection/:collection_id" do
      it "should be accessible for an appraiser" do
        sign_in users(:appraiser)
        get edit_collection_artist_path(collections(:collection1), artists(:artist1))
        expect(response).to have_http_status(200)
        expect(response.body).to match("Collectiespecifieke")
      end
    end
  end
  describe "GET /artists/new" do
    it "should be accessible for an admin" do
      sign_in users(:admin)
      get new_artist_path
      expect(response).to have_http_status(200)
    end
  end
  describe "POST /artists/clean" do
    it "shouldn't be publicly accessible!" do
      before_count = Artist.count
      post artists_clean_path
      expect(response).to have_http_status(302)
      expect(before_count - Artist.count).to eq 0
    end
    it "should be accessible when logged in as admin" do
      before_count = Artist.count
      user = users(:admin)
      sign_in user
      post artists_clean_path
      expect(response).to have_http_status(302)
      expect(before_count - Artist.count).to eq 4
    end
    it "should not be accessible when logged in as qkunst" do
      before_count = Artist.count
      user = users(:qkunst)
      sign_in user
      post artists_clean_path
      expect(response).to have_http_status(302)
      expect(before_count - Artist.count).to eq 0
    end
  end

  context "Collection" do
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
    describe "GET collection/:collection_id/artists/:id" do
      it "shouldn't be publicly accessible" do
        get collection_artist_path(collections(:collection1), artists(:artist1))
        expect(response).to have_http_status(302)
      end
      it "should be accessible by QKunst having access to collection" do
        sign_in users(:qkunst)
        get collection_artist_path(collections(:collection1), artists(:artist1))
        expect(response).to have_http_status(302)
        sign_in users(:qkunst_with_collection)
        get collection_artist_path(collections(:collection1), artists(:artist1))
        expect(response).to have_http_status(200)
      end
      it "should not give access to artists not visible in collection" do
        sign_in users(:qkunst_with_collection)
        expect { get collection_artist_path(collections(:collection1), artists(:artist2_dup2)) }.to raise_error(ActiveRecord::RecordNotFound)
      end
      it "should not expose attachments outside original collection" do
        sign_in users(:appraiser)
        get collection_artist_path(collections(:collection3), artists(:artist1))
        expect(response.body).to match("unpredictableattachmentname")
        get collection_artist_path(collections(:collection1), artists(:artist1))
        expect(response.body).not_to match("unpredictableattachmentname")
        sign_in users(:non_qkunst_advisor)
        get collection_artist_path(collections(:not_qkunst_managed_collection), artists(:artist1))
        expect(response.body).not_to match("unpredictableattachmentname")
      end
    end
  end
end
