require "rails_helper"

RSpec.describe CustomReportsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/collections/2/custom_reports").to route_to("custom_reports#index", collection_id: "2")
    end

    it "routes to #new" do
      expect(:get => "/collections/2/custom_reports/new").to route_to("custom_reports#new", collection_id: "2")
    end

    it "routes to #show" do
      expect(:get => "/collections/2/custom_reports/1").to route_to("custom_reports#show", collection_id: "2", id:  "1")
    end

    it "routes to #edit" do
      expect(:get => "/collections/2/custom_reports/1/edit").to route_to("custom_reports#edit", collection_id: "2", id:  "1")
    end

    it "routes to #create" do
      expect(:post => "/collections/2/custom_reports").to route_to("custom_reports#create", collection_id: "2")
    end

    it "routes to #update via PUT" do
      expect(:put => "/collections/2/custom_reports/1").to route_to("custom_reports#update", collection_id: "2", id:  "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/collections/2/custom_reports/1").to route_to("custom_reports#update", collection_id: "2", id:  "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/collections/2/custom_reports/1").to route_to("custom_reports#destroy", collection_id: "2", id:  "1")
    end

  end
end
