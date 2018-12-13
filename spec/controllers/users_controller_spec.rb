require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  include Devise::Test::ControllerHelpers

  describe "GET /users" do
    it "is inaccessible by default" do
      get :index
      expect(response).to have_http_status(:redirect)
    end

    it "is inaccessible by default even for most users" do
      sign_in users(:user1)
      get :index
      expect(response).to have_http_status(:redirect)
      sign_in users(:qkunst)
      get :index
      expect(response).to have_http_status(:redirect)
      sign_in users(:appraiser)
      get :index
      expect(response).to have_http_status(:redirect)
    end

    it "is accessible for admins and advisors" do
      sign_in users(:advisor)
      get :index
      expect(response).to have_http_status(:success)
      sign_in users(:admin)
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "PUT /users/:id" do
    it "allows for a advisor to change a collection membership he/she is part of" do
      sign_in users(:advisor)
      user_to_change = users(:user1)
      expect(users(:advisor).collections).not_to include(collections(:collection3))
      put :update, params: {id: user_to_change.id, user: {collection_ids: [collections(:collection1).id, collections(:collection3).id]}}, session: {}
      expect(response).to have_http_status(:redirect)
      expect(user_to_change.collections).to include(collections(:collection1))
      expect(user_to_change.collections).not_to include(collections(:collection3))
    end
    it "allows for an admin to change collection membership he/she is part of" do
      sign_in users(:admin)
      user_to_change = users(:user1)
      expect(users(:admin).collections).not_to include(collections(:collection3))
      put :update, params: {id: user_to_change.id, user: {collection_ids: [collections(:collection1).id, collections(:collection3).id]}}, session: {}
      expect(response).to have_http_status(:redirect)
      expect(user_to_change.collections).to include(collections(:collection1))
      expect(user_to_change.collections).to include(collections(:collection3))
    end
  end

end
