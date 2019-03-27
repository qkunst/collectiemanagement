# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "BatchPhotoUploads", type: :request do
  describe "GET /batch_photo_uploads" do
    it "redirects! (now write some real specs)" do
      c = Collection.create(name: "test")
      get collection_batch_photo_uploads_path(c)
      expect(response).to have_http_status(302)
    end
  end
end
