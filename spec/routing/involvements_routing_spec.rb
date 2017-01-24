require "rails_helper"

RSpec.describe InvolvementsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/involvements").to route_to("involvements#index")
    end

    it "routes to #new" do
      expect(:get => "/involvements/new").to route_to("involvements#new")
    end

    it "routes to #show" do
      expect(:get => "/involvements/1").to route_to("involvements#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/involvements/1/edit").to route_to("involvements#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/involvements").to route_to("involvements#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/involvements/1").to route_to("involvements#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/involvements/1").to route_to("involvements#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/involvements/1").to route_to("involvements#destroy", :id => "1")
    end

  end
end
