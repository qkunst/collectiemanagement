# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ClustersController, type: :controller do
  include Devise::Test::ControllerHelpers

  # This should return the minimal set of attributes required to create a valid
  # Cluster. As you add validations to Cluster, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    { name: "a", collection: collections(:collection3)}
  }

  let(:invalid_attributes) {
    { name: nil }
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # ClustersController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET #index" do
    it "returns a success response when signed in as admin" do
      sign_in users(:admin)
      cluster = Cluster.create! valid_attributes
      get :index, params: {collection_id: collections(:collection3).id}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "GET #show" do
    it "returns a success response when signed in as admin" do
      sign_in users(:admin)
      cluster = Cluster.create! valid_attributes
      get :show, params: {id: cluster.to_param, collection_id: collections(:collection3).id }, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "GET #new" do
    it "returns a success response" do
      sign_in users(:admin)
      get :new, params: {collection_id: collections(:collection3).id}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "GET #edit" do
    it "returns a success response" do
      sign_in users(:admin)
      cluster = Cluster.create! valid_attributes
      get :edit, params: {id: cluster.to_param, collection_id: collections(:collection3).id}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Cluster" do
        sign_in users(:admin)
        expect {
          post :create, params: {cluster: valid_attributes, collection_id: collections(:collection3).id}, session: valid_session
        }.to change(Cluster, :count).by(1)
      end

      it "redirects to the created cluster" do
        sign_in users(:admin)
        post :create, params: {cluster: valid_attributes, collection_id: collections(:collection3).id}, session: valid_session
        expect(response).to redirect_to(collection_clusters_url(collections(:collection3)))
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'new' template)" do
        sign_in users(:admin)
        post :create, params: {cluster: invalid_attributes, collection_id: collections(:collection3).id}, session: valid_session
        expect(response).to be_successful
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        { name: "b", collection: collections(:collection3)}
      }

      it "updates the requested cluster" do
        sign_in users(:admin)
        cluster = Cluster.create! valid_attributes
        put :update, params: {id: cluster.to_param, collection_id: collections(:collection3).id, cluster: new_attributes}, session: valid_session
        cluster.reload
        expect(cluster.name).to eq "b"
      end

      it "redirects to the cluster" do
        sign_in users(:admin)
        cluster = Cluster.create! valid_attributes
        put :update, params: {id: cluster.to_param, collection_id: collections(:collection3).id, cluster: valid_attributes}, session: valid_session
        expect(response).to redirect_to(collection_clusters_url(collections(:collection3)))
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'edit' template)" do
        sign_in users(:admin)
        cluster = Cluster.create! valid_attributes
        put :update, params: {id: cluster.to_param, collection_id: collections(:collection3).id, cluster: invalid_attributes}, session: valid_session
        expect(response).to be_successful
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested cluster" do
      sign_in users(:admin)
      cluster = Cluster.create! valid_attributes
      expect {
        delete :destroy, params: {id: cluster.to_param, collection_id: collections(:collection3).id}, session: valid_session
      }.to change(Cluster, :count).by(-1)
    end

    it "redirects to the clusters list" do
      sign_in users(:admin)
      cluster = Cluster.create! valid_attributes
      delete :destroy, params: {id: cluster.to_param, collection_id: collections(:collection3).id}, session: valid_session
      expect(response).to redirect_to(collection_clusters_url(collections(:collection3)))
    end
  end

end
