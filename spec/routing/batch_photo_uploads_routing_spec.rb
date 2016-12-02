require "rails_helper"

RSpec.describe BatchPhotoUploadsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/batch_photo_uploads").to route_to("batch_photo_uploads#index")
    end

    it "routes to #new" do
      expect(:get => "/batch_photo_uploads/new").to route_to("batch_photo_uploads#new")
    end

    it "routes to #show" do
      expect(:get => "/batch_photo_uploads/1").to route_to("batch_photo_uploads#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/batch_photo_uploads/1/edit").to route_to("batch_photo_uploads#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/batch_photo_uploads").to route_to("batch_photo_uploads#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/batch_photo_uploads/1").to route_to("batch_photo_uploads#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/batch_photo_uploads/1").to route_to("batch_photo_uploads#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/batch_photo_uploads/1").to route_to("batch_photo_uploads#destroy", :id => "1")
    end

  end
end
