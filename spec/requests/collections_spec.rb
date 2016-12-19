require 'rails_helper'

RSpec.describe "Collections", type: :request do
  describe "GET /collections" do
    it "shouldn't be publicly accessible!" do
      get collections_path
      expect(response).to have_http_status(302)
    end
    it "should be accessible when logged in as admin" do
      user = users(:admin)
      sign_in user
      get collections_path
      expect(response).to have_http_status(200)
    end
    it "should not be accessible when logged in as an anonymous user" do
      user = users(:user_with_no_rights)
      sign_in user
      get collections_path
      expect(response).to have_http_status(302)
      expect(response).to redirect_to root_path
    end
    it "should redirect to the single collection the user has access to" do
      user = users(:read_only_user)
      sign_in user
      get collections_path
      expect(response).to have_http_status(302)
      expect(response).to redirect_to collection_path(user.collections.first.id)
    end
  end
end
