# frozen_string_literal: true

require "rails_helper"

RSpec.describe AttachmentsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/collections/1/attachments").to route_to("attachments#index", collection_id: "1")
    end

    it "routes to #new" do
      expect(:get => "/collections/1/attachments/new").to route_to("attachments#new", collection_id: "1")
    end

    it "routes to #show" do
      expect(:get => "/collections/1/attachments/1").to route_to("attachments#show", collection_id: "1", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/collections/1/attachments/1/edit").to route_to("attachments#edit", collection_id: "1", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/collections/1/attachments").to route_to("attachments#create", collection_id: "1")
    end

    it "routes to #update via PUT" do
      expect(:put => "/collections/1/attachments/1").to route_to("attachments#update", collection_id: "1", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/collections/1/attachments/1").to route_to("attachments#update", collection_id: "1", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/collections/1/attachments/1").to route_to("attachments#destroy", collection_id: "1", :id => "1")
    end

  end
end
