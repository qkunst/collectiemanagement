# frozen_string_literal: true

require "rails_helper"

RSpec.describe CollectionsController, type: :controller do
  include Devise::Test::ControllerHelpers

  let(:valid_attributes) {
    {name: "Provincie"}
  }

  let(:invalid_attributes) {
    {a: 2}
  }
  let(:valid_session) { {} }

  # around :each do |example|
  #   Rails.application.config.consider_all_requests_local = false
  #   example.run
  #   Rails.application.config.consider_all_requests_local = true
  # end
  describe "DELETE #destroy" do
    describe "without login" do
      it "doesn't destroy the requested Collection without login" do
        collection = Collection.create! valid_attributes
        expect {
          delete :destroy, params: {id: collection.to_param}, session: valid_session
        }.to change(Collection, :count).by(0)
      end
      it "redirects to the sign up path when not logged in" do
        collection = Collection.create! valid_attributes
        delete :destroy, params: {id: collection.to_param}, session: valid_session
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe "as regular user" do
      it "redirects to the root path when not allowed" do
        collection = Collection.create! valid_attributes
        user = users(:user1)
        sign_in user

        delete :destroy, params: {id: collection.to_param}, session: valid_session
        expect(response).to redirect_to(root_url)
      end
    end

    describe "as admin" do
      it "can destroy the requested Collection" do
        collection = Collection.create! valid_attributes
        user = users(:admin)
        sign_in user
        expect {
          delete :destroy, params: {id: collection.to_param}, session: valid_session
        }.to change(Collection, :count).by(-1)
      end

      it "doesn't destroy the requested Collection with admin login if it has works" do
        collection = Collection.create! valid_attributes
        collection.works.create(title: "a")
        user = users(:admin)
        sign_in user
        expect {
          delete :destroy, params: {id: collection.to_param}, session: valid_session
        }.to change(Collection, :count).by(-1)
      end

      it "does destroy the requested Collection with admin login if it has works and a parent collection" do
        collection = Collection.create! valid_attributes
        subcollection = collection.collections.create! valid_attributes
        subcollection.works.create(title: "a")
        user = users(:admin)
        sign_in user
        expect {
          delete :destroy, params: {id: collection.to_param}, session: valid_session
        }.to change(Collection, :count).by(-1)
        expect {
          delete :destroy, params: {id: subcollection.to_param}, session: valid_session
        }.to change(Collection, :count).by(-1)
      end
    end
    describe "as advisor" do
      it "doesn't destroy a newly generated Collection with advisor login" do
        collection = Collection.create! valid_attributes
        user = users(:advisor)
        sign_in user
        expect {
          delete :destroy, params: {id: collection.to_param}, session: valid_session
        }.to change(Collection, :count).by(0)
      end
      it "can destroy a collection the advisor has access to" do
        collection = users(:advisor).collections.first
        user = users(:advisor)
        sign_in user
        expect {
          delete :destroy, params: {id: collection.to_param}, session: valid_session
        }.to change(Collection, :count).by(-1)
      end

      it "cannot destroy the a collection the advisor has no access to" do
        collection = collections(:collection3)
        user = users(:advisor)
        sign_in user
        expect {
          delete :destroy, params: {id: collection.to_param}, session: valid_session
        }.to change(Collection, :count).by(0)
      end
    end
  end
end
