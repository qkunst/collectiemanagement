# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MessagesController, type: :controller do
  include Devise::Test::ControllerHelpers

  describe "SHOW #messages" do
    it "should not show the message to no-user" do
      m = messages(:conversation_starter)
      get :show, params: {id: m.id}
      expect(response).to redirect_to(new_user_session_path)
      expect(m.actioned_upon_by_qkunst_admin_at).to eq(nil)
      expect(m.replies.first.actioned_upon_by_qkunst_admin_at).to eq(nil)
    end
    it "should show the message to the author" do
      m = messages(:conversation_starter)
      sign_in users(:facility_manager)
      get :show, params: {id: m.id}
      expect(response).to have_http_status(:success)
      expect(m.actioned_upon_by_qkunst_admin_at).to eq(nil)
      expect(m.replies.first.actioned_upon_by_qkunst_admin_at).to eq(nil)
    end
    it "should not show just a normal qkunst user" do
      m = messages(:conversation_starter)
      sign_in users(:qkunst)
      get :show, params: {id: m.id}
      expect(response).to redirect_to(root_path)
      expect(m.actioned_upon_by_qkunst_admin_at).to eq(nil)
      expect(m.replies.first.actioned_upon_by_qkunst_admin_at).to eq(nil)
    end
    it "should  show to a admin qkunst user (and mark message as read)" do
      m = messages(:conversation_starter)
      expect(m.actioned_upon_by_qkunst_admin_at).to eq(nil)
      sign_in users(:admin)
      get :show, params: {id: m.id}
      expect(response).to have_http_status(:success)
      m.reload
      expect(m.actioned_upon_by_qkunst_admin_at).not_to eq(nil)
      expect(m.replies.first.actioned_upon_by_qkunst_admin_at).not_to eq(nil)
    end
  end

  describe "PUT #update" do
    it "should allow an advisor to edit a message belonging to a collection he/she manages" do
      m = messages(:conversation_starter)
      sign_in users(:advisor)
      get :show, params: {id: m.id}
      expect(response).to have_http_status(:success)
      get :update, params: {id: m.id, message: {message: "kaas"}}
      expect(response).to have_http_status(:redirect)
      m.reload
      expect(m.message).to eq("kaas")
    end
    it "should not allow an advisor to edit a message not belonging to a collection he/she manages" do
      m = messages(:conversation_starter_collection3)
      sign_in users(:advisor)
      get :show, params: {id: m.id}
      expect(response).to have_http_status(:success)
      get :update, params: {id: m.id, message: {message: "kaas"}}
      expect(response).to have_http_status(:redirect)
      m.reload
      expect(m.message).to eq(nil) #unchanged
    end
  end
end

