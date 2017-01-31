require "rails_helper"

RSpec.describe StagesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/stages").to route_to("stages#index")
    end

    it "routes to #new" do
      expect(:get => "/stages/new").to route_to("stages#new")
    end

    it "routes to #show" do
      expect(:get => "/stages/1").to route_to("stages#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/stages/1/edit").to route_to("stages#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/stages").to route_to("stages#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/stages/1").to route_to("stages#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/stages/1").to route_to("stages#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/stages/1").to route_to("stages#destroy", :id => "1")
    end

  end
end
