require "rails_helper"

RSpec.describe ContactsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/collections/1/contacts").to route_to("contacts#index", collection_id: "1")
    end

    it "routes to #new" do
      expect(get: "/collections/1/contacts/new").to route_to("contacts#new", collection_id: "1")
    end

    it "routes to #show" do
      expect(get: "/collections/1/contacts/1").to route_to("contacts#show", id: "1", collection_id: "1")
    end

    it "routes to #edit" do
      expect(get: "/collections/1/contacts/1/edit").to route_to("contacts#edit", id: "1", collection_id: "1")
    end


    it "routes to #create" do
      expect(post: "/collections/1/contacts").to route_to("contacts#create", collection_id: "1")
    end

    it "routes to #update via PUT" do
      expect(put: "/collections/1/contacts/1").to route_to("contacts#update", id: "1", collection_id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/collections/1/contacts/1").to route_to("contacts#update", id: "1", collection_id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/collections/1/contacts/1").to route_to("contacts#destroy", id: "1", collection_id: "1")
    end
  end
end
