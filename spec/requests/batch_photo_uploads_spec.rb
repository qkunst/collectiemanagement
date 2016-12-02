require 'rails_helper'

RSpec.describe "BatchPhotoUploads", type: :request do
  describe "GET /batch_photo_uploads" do
    it "works! (now write some real specs)" do
      get batch_photo_uploads_path
      expect(response).to have_http_status(200)
    end
  end
end
