# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Messages", type: :request do
  describe "GET /messages" do
    it "shouldn't be publicly accessible!" do
      get messages_path
      expect(response).to have_http_status(302)
    end
    it "should be accessible when logged in as admin" do
      user = users(:admin)
      sign_in user
      get messages_path
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /messages/:id" do
    context "advisor" do
      let(:user) { users(:advisor) }

      before do
        sign_in user
      end

      it "should be able to download the download message" do
        collection = collections(:collection1)
        message = CollectionDownloadWorker.new.perform(collection.id, user.id)
        get message_path(message)
        expect(response).to have_http_status(200)
      end
    end

  end
end
