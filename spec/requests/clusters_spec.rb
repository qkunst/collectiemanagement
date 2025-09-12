# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Clusters", type: :request do
  include Rack::Test::Methods

  let(:collection) { collections(:collection1) }

  describe "GET /collections/:collection_id/clusters" do
    it "not accessible by default" do
      get collection_clusters_path(collection)
      expect(last_response.redirect?).to be_truthy
    end
    it "accessible by admin" do
      sign_in users(:admin)
      get collection_clusters_path(collection)
      expect(last_response.ok?).to be_truthy
    end
    it "accessible by advisor" do
      sign_in users(:advisor)
      get collection_clusters_path(collection)
      expect(last_response.ok?).to be_truthy
    end
    it "shows create button for advisor" do
      sign_in users(:advisor)
      get collection_clusters_path(collection)
      expect(last_response.body).to match("Nieuw cluster maken")
    end
    it "is not accessible by a random registrerd user" do
      sign_in users(:user3)
      get collection_clusters_path(collection)
      expect(last_response.redirect?).to be_truthy
    end
    it "is not accessible by a facility manager with access to the collection" do
      sign_in users(:facility_manager)
      get collection_clusters_path(collection)
      expect(last_response.redirect?).to be_truthy
    end
  end

  describe "GET /collections/:collection_id/clusters/new" do
    let(:get_new) { get new_collection_cluster_path(collection) }

    it "not accessible by default" do
      get_new
      expect(last_response.redirect?).to be_truthy
    end
    it "accessible by admin" do
      sign_in users(:admin)
      get_new
      expect(last_response.ok?).to be_truthy
    end
    it "accessible by advisor" do
      sign_in users(:advisor)
      get_new
      expect(last_response.ok?).to be_truthy
    end
    it "is not accessible by a random registrerd user" do
      sign_in users(:user3)
      get_new
      expect(last_response.redirect?).to be_truthy
    end
    it "is not accessible by a facility manager with access to the collection" do
      sign_in users(:facility_manager)
      get_new
      expect(last_response.redirect?).to be_truthy
    end
  end

  describe "POST /collections/:collection_id/clusters" do
    let(:perform_post) { post(collection_clusters_path(collection), {cluster: {name: "Nieuw cluster"}}) }
    it "anonymous cannot create cluster" do
      expect {
        perform_post
      }.to change(Cluster, :count).by(0)
      expect(last_response.redirect?).to be_truthy
    end
    it "admin can create cluster" do
      sign_in users(:admin)
      expect {
        perform_post
      }.to change(Cluster, :count).by(1)
      expect(last_response.redirect?).to be_truthy
    end
    it "advisor can create cluster" do
      sign_in users(:advisor)
      expect {
        perform_post
      }.to change(Cluster, :count).by(1)
      expect(last_response.redirect?).to be_truthy
    end
  end
end
