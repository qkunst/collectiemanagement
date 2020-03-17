# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Collections", type: :request do
  describe "GET /collections" do
    it "shouldn't be publicly accessible!" do
      c = collections(:collection1)
      get api_v1_collection_works_path(1)
      expect(response).to have_http_status(401)
      get api_v1_collection_works_path(11232)
      expect(response).to have_http_status(401)
      get api_v1_collection_works_path(c.id)
      expect(response).to have_http_status(401)
    end

    it "an allowed user should be able to get an index" do
      # do 'dumb' requst to get external ip
      get api_v1_collection_works_path(1)
      external_ip = JSON.parse(response.body)["your_remote_ip"]

      # actual attempt
      c = collections(:collection1)
      api_user = users(:user_with_api_key)
      url = api_v1_collection_works_url(c.id, format: :json)
      data = "#{external_ip}#{url}"

      # for this test, we need a relative url
      url = api_v1_collection_works_path(c.id, format: :json)

      digest = OpenSSL::Digest.new("sha512")
      hmac_token = OpenSSL::HMAC.hexdigest(digest, api_user.api_key, data)

      c.users << api_user
      get url, headers: {"X-user-id" => api_user.id, "X-hmac-token" => hmac_token}
      response_data = JSON.parse(response.body)
      expect(response).to have_http_status(200)
    end
    it "an allowed user should be able to get a single work through the api" do
      # do 'dumb' requst to get external ip
      get api_v1_collection_works_path(1)
      external_ip = JSON.parse(response.body)["your_remote_ip"]

      # actual attempt
      c = collections(:collection_with_works)
      w = c.works.first
      api_user = users(:user_with_api_key)
      url = api_v1_collection_work_url(c.id, w.id, format: :json)
      data = "#{external_ip}#{url}"

      # for this test, we need a relative url
      url = api_v1_collection_work_path(c.id, w.id, format: :json)

      digest = OpenSSL::Digest.new("sha512")
      hmac_token = OpenSSL::HMAC.hexdigest(digest, api_user.api_key, data)

      c.users << api_user
      get url, headers: {"X-user-id" => api_user.id, "X-hmac-token" => hmac_token}
      response_data = JSON.parse(response.body)

      expect(response).to have_http_status(200)
    end
    it "even an allowed user shouldn't be able to mess with the url" do
      # do 'dumb' requst to get external ip
      get api_v1_collection_works_path(1)
      external_ip = JSON.parse(response.body)["your_remote_ip"]

      # actual attempt
      c = collections(:collection1)
      api_user = users(:user_with_api_key)
      url = api_v1_collection_works_url(c.id, format: :json)
      data = "#{external_ip}#{url}"

      # for this test, we need a relative url
      url = api_v1_collection_works_path(c.id, format: :json)

      digest = OpenSSL::Digest.new("sha512")
      hmac_token = OpenSSL::HMAC.hexdigest(digest, api_user.api_key, data)

      c.users << api_user
      get "#{url}?meaningless", headers: {"X-user-id" => api_user.id, "X-hmac-token" => hmac_token}
      response_data = JSON.parse(response.body)
      expect(response).to have_http_status(401)
    end

    it "not allowed user should be not be able to get an index" do
      # do 'dumb' requst to get external ip
      get api_v1_collection_works_path(1)
      external_ip = JSON.parse(response.body)["your_remote_ip"]

      # actual attempt
      c = collections(:collection1)
      api_user = users(:user_with_api_key)
      url = api_v1_collection_works_url(c.id, format: :json)
      data = "#{external_ip}#{url}"

      # for this test, we need a relative url
      url = api_v1_collection_works_path(c.id, format: :json)

      digest = OpenSSL::Digest.new("sha512")
      hmac_token = OpenSSL::HMAC.hexdigest(digest, api_user.api_key, data)
      expect {
        get url, headers: {"X-user-id" => api_user.id, "X-hmac-token" => hmac_token}
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end

# http://localhost:3000/api/v1/collections/1/works/
