# frozen_string_literal: true

require "rails_helper"

RSpec.describe LibraryItemsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/collections/1/library_items").to route_to("library_items#index", collection_id: "1")
    end

    it "routes to #new" do
      expect(get: "/collections/1/library_items/new").to route_to("library_items#new", collection_id: "1")
    end

    it "routes to #show" do
      expect(get: "/collections/1/library_items/1").to route_to("library_items#show", id: "1", collection_id: "1")
    end

    it "routes to #edit" do
      expect(get: "/collections/1/library_items/1/edit").to route_to("library_items#edit", id: "1", collection_id: "1")
    end


    it "routes to #create" do
      expect(post: "/collections/1/library_items").to route_to("library_items#create", collection_id: "1")
    end

    it "routes to #update via PUT" do
      expect(put: "/collections/1/library_items/1").to route_to("library_items#update", id: "1", collection_id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/collections/1/library_items/1").to route_to("library_items#update", id: "1", collection_id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/collections/1/library_items/1").to route_to("library_items#destroy", id: "1", collection_id: "1")
    end
  end
end
