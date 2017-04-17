require "rails_helper"

RSpec.describe FrameTypesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/frame_types").to route_to("frame_types#index")
    end

    it "routes to #new" do
      expect(:get => "/frame_types/new").to route_to("frame_types#new")
    end

    it "routes to #show" do
      expect(:get => "/frame_types/1").to route_to("frame_types#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/frame_types/1/edit").to route_to("frame_types#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/frame_types").to route_to("frame_types#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/frame_types/1").to route_to("frame_types#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/frame_types/1").to route_to("frame_types#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/frame_types/1").to route_to("frame_types#destroy", :id => "1")
    end

  end
end
