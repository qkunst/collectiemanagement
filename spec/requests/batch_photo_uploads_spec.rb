# frozen_string_literal: true

require "rails_helper"

RSpec.describe "BatchPhotoUploads", type: :request do
  describe "GET /batch_photo_uploads" do
    it "redirects when no user is logged in" do
      c = Collection.create(name: "test")
      get collection_batch_photo_uploads_path(c)
      expect(response).to have_http_status(302)
    end
  end

  describe "POST /batch_photo_uploads" do
    it "redirects when no user is logged in" do
      c = Collection.create(name: "test")
      expect {
        post collection_batch_photo_uploads_path(c)
      }.not_to change(BatchPhotoUpload, :count)
      expect(response).to have_http_status(302)
    end

    xit "creates thumbs when upload is started" do
      sign_in users(:admin)
      c = Collection.create(name: "test")
      file = fixture_file_upload("image.jpg", "image/jpeg", :binary)

      expect {
        post collection_batch_photo_uploads_path(c, params: {batch_photo_upload: {images: [file]}}), headers: {"content-type": "application/x-www-form-urlencoded"}
      }.to change(BatchPhotoUpload, :count).by(1)
    end
  end
end
