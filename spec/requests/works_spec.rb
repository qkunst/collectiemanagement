require 'rails_helper'

RSpec.describe "Works", type: :request do
  describe "GET /collections/:id/works" do
    it "shouldn't be publicly accessible!" do
      collection = collections(:collection1)
      get collection_works_path(collection)
      expect(response).to have_http_status(302)
    end
    it "should be accessible when logged in as admin" do
      user = users(:admin)
      sign_in user
      collection = collections(:collection1)
      get collection_works_path(collection)
      expect(response).to have_http_status(200)
    end
    it "should not be accessible when logged in as an anonymous user" do
      user = users(:user_with_no_rights)
      sign_in user
      collection = collections(:collection1)
      get collection_works_path(collection)
      expect(response).to have_http_status(302)
      expect(response).to redirect_to root_path
    end
    it "should allow accesss to the single collection the user has access to" do
      user = users(:read_only_user)
      sign_in user
      collection = collections(:collection3)
      get collection_works_path(collection)
      expect(response).to have_http_status(200)
    end
    it "should redirect to the root when accessing anohter collection" do
      user = users(:read_only_user)
      sign_in user
      collection = collections(:collection1)
      get collection_works_path(collection)
      expect(response).to have_http_status(302)
      expect(response).to redirect_to root_path
    end
  end
end