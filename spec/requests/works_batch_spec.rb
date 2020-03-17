# frozen_string_literal: true

require "rails_helper"

RSpec.describe "WorkBatchs", type: :request do
  describe "GET /collections/:id/works/batch/edit" do
    it "shouldn't be publicly accessible!" do
      collection = collections(:collection1)
      get collection_works_batch_edit_path(collection, params: {property: :location})
      expect(response).to have_http_status(302)
      expect(response).to redirect_to new_user_session_path
    end
    it "should be accessible when logged in as admin" do
      user = users(:admin)
      collection = collections(:collection1)
      sign_in user
      get collection_works_batch_edit_path(collection, params: {property: :location})
      expect(response).to have_http_status(302)
      expect(response).to redirect_to collection_batch_path(expose_fields: [:location], work_ids_comma_separated: "")
    end
    it "should not be accessible when logged in as an anonymous user" do
      user = users(:user_with_no_rights)
      sign_in user
      collection = collections(:collection1)
      get collection_works_batch_edit_path(collection, params: {property: :location})
      expect(response).to have_http_status(302)
      expect(response).to redirect_to root_path
    end
    it "should not allow accesss to the batch editor for non qkunst user has access to" do
      user = users(:read_only_user)
      sign_in user
      collection = collections(:collection3)
      get collection_works_batch_edit_path(collection, params: {property: :location})
      expect(response).to have_http_status(302)
      expect(response).to redirect_to root_path
    end

    it "should redirect to the root when accessing anohter collection" do
      user = users(:read_only_user)
      sign_in user
      collection = collections(:collection1)
      get collection_works_batch_edit_path(collection, params: {property: :location})
      expect(response).to have_http_status(302)
      expect(response).to redirect_to collection_batch_path(expose_fields: [:location], work_ids_comma_separated: "")
      # not really a concern of this spec, but the above expectation may confuse you, the end user will return to root :)
      get collection_batch_path(expose_fields: [:location], work_ids_comma_separated: "")
      expect(response).to have_http_status(302)
      expect(response).to redirect_to root_path
    end
  end
end
