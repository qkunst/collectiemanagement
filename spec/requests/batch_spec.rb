# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "WorkBatchs", type: :request do
  describe "GET /collections/:id/batch/" do
    it "shouldn't be publicly accessible!" do
      collection = collections(:collection1)
      get collection_batch_path(collection)
      expect(response).to have_http_status(302)
    end
    it "should be accessible when logged in as admin" do
      user = users(:admin)
      collection = collections(:collection1)
      sign_in user
      get collection_batch_path(collection)
      expect(response).to have_http_status(200)
    end
    it "admin should be able to access index page" do
      user = users(:admin)
      sign_in user
      collection = collections(:collection1)
      get collection_batch_path(collection)
      expect(response).to have_http_status(200)
    end
    it "should not be accessible when logged in as an anonymous user" do
      user = users(:user_with_no_rights)
      sign_in user
      collection = collections(:collection1)
      get collection_batch_path(collection)
      expect(response).to have_http_status(302)
      expect(response).to redirect_to root_path
    end
    it "should not allow accesss to the batch editor for non qkunst user has access to" do
      user = users(:read_only_user)
      sign_in user
      collection = collections(:collection3)
      get collection_batch_path(collection)
      expect(response).to have_http_status(302)
    end

    it "should redirect to the root when accessing anohter collection" do
      user = users(:read_only_user)
      sign_in user
      collection = collections(:collection1)
      get collection_batch_path(collection)
      expect(response).to have_http_status(302)
      expect(response).to redirect_to root_path
    end
  end
  describe "PATCH /collection/:collection_id/batch" do
    describe "tag_list" do
      it "should REPLACE" do
        sign_in users(:admin)
        collection = collections(:collection1)
        works = [works(:work1), works(:work2)]
        works.collect{|a| a.tag_list = ["existing_tag"]; a.save}
        patch collection_batch_path(collection), params: {work_ids_comma_separated: works.map(&:id).join(","), work: {collection_id: collection.id, tag_list:["eerste nieuwe tag", "first new tag"], update_tag_list_strategy: "REPLACE"}}
        expect(response).to have_http_status(302)
        works.collect{|a| a.reload}
        expect(works.first.tag_list).to match_array(["eerste nieuwe tag", "first new tag"])
      end
      it "should APPEND" do
        sign_in users(:admin)
        collection = collections(:collection1)
        works = [works(:work1), works(:work2)]
        works.collect{|a| a.tag_list = ["existing_tag"]; a.save}
        patch collection_batch_path(collection), params: {work_ids_comma_separated: works.map(&:id).join(","), work: {collection_id: collection.id, tag_list:["eerste nieuwe tag", "first new tag"], update_tag_list_strategy: "APPEND"}}
        expect(response).to have_http_status(302)
        works.collect{|a| a.reload}
        expect(works.first.tag_list).to match_array(["existing_tag", "eerste nieuwe tag", "first new tag"])
      end
      it "should REMOVE" do
        sign_in users(:admin)
        collection = collections(:collection1)
        works = [works(:work1), works(:work2)]
        works.collect{|a| a.tag_list = ["existing_tag", "tag to delete"]; a.save}
        patch collection_batch_path(collection), params: {work_ids_comma_separated: works.map(&:id).join(","), work: {collection_id: collection.id, tag_list:["tag to delete", "eerste nieuwe tag", "first new tag"], update_tag_list_strategy: "REMOVE"}}
        expect(response).to have_http_status(302)
        works.collect{|a| a.reload}
        expect(works.first.tag_list).to match_array(["existing_tag"])
      end
    end
  end
end
