# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Collections", type: :request do
  let(:collection) { collections(:collection1) }

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
      user = users(:read_only)
      sign_in user
      get collections_path
      expect(response).to have_http_status(302)
      expect(response).to redirect_to collection_path(user.collections.first.id)
    end
  end
  describe "GET /collections/:id" do
    it "shouldn't be publicly accessible!" do
      get collection_path(collection)
      expect(response).to have_http_status(302)
    end
    it "should be accessible when logged in as admin" do
      user = users(:admin)
      sign_in user
      get collection_path(collection)
      expect(response).to have_http_status(200)
    end
    it "should not be accessible when logged in as an anonymous user" do
      user = users(:user_with_no_rights)
      sign_in user
      get collection_path(collection)
      expect(response).to have_http_status(302)
      expect(response).to redirect_to root_path
    end
    it "should allow accesss to the single collection the user has access to" do
      user = users(:read_only)
      sign_in user
      collection = collections(:collection1)
      get collection_path(collection)
      expect(response).to have_http_status(200)
    end
    it "should redirect to the root when accessing anohter collection" do
      user = users(:read_only)
      sign_in user
      collection = collections(:collection3)
      get collection_path(collection)
      expect(response).to have_http_status(302)
      expect(response).to redirect_to root_path
    end
  end
  describe "DELETE /collections/:colletion_id" do
    [:admin, :advisor].each do |user_key|
      it "allows access for #{user_key}" do
        user = users(user_key)
        collection = collections(:collection1).collections.create(name: "removable_sub")

        sign_in user
        expect(user.accessible_collections).to include(collection)

        expect { delete collection_path(collection) }.to change(Collection, :count).by(-1)
      end
    end

    [:facility_manager, :appraiser, :compliance].each do |user_key|
      it "denies access for #{user_key}" do
        user = users(user_key)
        collection = collections(:collection1).collections.create(name: "removable_sub")

        sign_in user
        expect(user.accessible_collections).to include(collection)

        expect { delete collection_path(collection) }.not_to change(Collection, :count)
      end
    end
  end
  describe "GET /collections/:id/edit" do
    it "shouldn't be publicly accessible!" do
      collection = collections(:collection1)
      get edit_collection_path(collection)
      expect(response).to have_http_status(302)
    end
    it "should be accessible when logged in as admin" do
      user = users(:admin)
      sign_in user
      collection = collections(:collection1)
      get edit_collection_path(collection)
      expect(response).to have_http_status(200)
    end
    it "should not be accessible when logged in as an anonymous user" do
      user = users(:user_with_no_rights)
      sign_in user
      collection = collections(:collection1)
      get edit_collection_path(collection)
      expect(response).to have_http_status(302)
      expect(response).to redirect_to root_path
    end
    it "should allow accesss to the single collection the user has access to" do
      user = users(:read_only)
      sign_in user
      collection = collections(:collection3)
      get edit_collection_path(collection)
      expect(response).to have_http_status(302)
      expect(response).to redirect_to root_path
    end
    it "should redirect to the root when accessing anohter collection" do
      user = users(:read_only)
      sign_in user
      collection = collections(:collection1)
      get edit_collection_path(collection)
      expect(response).to have_http_status(302)
      expect(response).to redirect_to root_path
    end
  end

  describe "GET /collections/new" do
    it "shouldn't be publicly accessible!" do
      get new_collection_path
      expect(response).to have_http_status(302)
    end
    it "should be accessible when logged in as admin" do
      user = users(:admin)
      sign_in user
      get new_collection_path
      expect(response).to have_http_status(200)
    end
    it "should not be accessible when logged in as an anonymous user" do
      user = users(:user_with_no_rights)
      sign_in user
      get new_collection_path
      expect(response).to have_http_status(302)
      expect(response).to redirect_to root_path
    end
    it "should allow accesss to the single collection the user has access to" do
      user = users(:read_only)
      sign_in user
      get new_collection_path
      expect(response).to have_http_status(302)
      expect(response).to redirect_to root_path
    end
  end

  describe "GET /collections/manage" do
    it "shouldn't be publicly accessible!" do
      get collection_manage_path(collection)
      expect(response).to have_http_status(302)
    end

    context "with read_only" do
      let(:user) { users(:read_only) }
      before do
        sign_in(user)
      end

      it "shoud not be accessible" do
        get collection_manage_path(collection)
        expect(response).to redirect_to root_path
      end
    end

    context "with admin" do
      let(:user) { users(:admin) }
      before do
        sign_in(user)
      end

      it "should be accessible" do
        get collection_manage_path(collection)
        expect(response).to be_successful
      end
    end
  end

  describe "GET /collections/manage/surface_tool" do
    it "shouldn't be publicly accessible!" do
      get collection_manage_surface_tool_path(collection)
      expect(response).to have_http_status(302)
    end

    context "with admin" do
      let(:user) { users(:admin) }
      before do
        sign_in(user)
      end

      it "should be accessible" do
        get collection_manage_surface_tool_path(collection)
        expect(response).to be_successful
      end

      it "should show summary" do
        get collection_manage_surface_tool_path(collection)
        collection.works
        expected_surface = collection.works_including_child_works.map { |a| a.wall_surface }.compact.sum
        expect(response.body).to match(">#{expected_surface.to_s.tr(".", ",")}</td>")
      end
    end

    context "with read_only" do
      let(:user) { users(:read_only) }

      before do
        sign_in(user)
      end

      it "shoud not be accessible" do
        get collection_manage_surface_tool_path(collection)
        expect(response).to redirect_to root_path
      end
    end
  end
end
