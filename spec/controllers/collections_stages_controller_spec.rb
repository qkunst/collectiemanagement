require 'rails_helper'

RSpec.describe CollectionsStagesController, type: :controller do
  include Devise::Test::ControllerHelpers

  describe "GET #update" do
    it "returns http success" do
      patch :update, params: {collection_id: collections(:collection1), id: 1}
      expect(response).to have_http_status(302)
    end
  end

end
