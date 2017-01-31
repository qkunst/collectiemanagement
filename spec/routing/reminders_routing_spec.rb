require "rails_helper"

RSpec.describe RemindersController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/reminders").to route_to("reminders#index")
    end

    it "routes to #new" do
      expect(:get => "/reminders/new").to route_to("reminders#new")
    end

    it "routes to #show" do
      expect(:get => "/reminders/1").to route_to("reminders#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/reminders/1/edit").to route_to("reminders#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/reminders").to route_to("reminders#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/reminders/1").to route_to("reminders#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/reminders/1").to route_to("reminders#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/reminders/1").to route_to("reminders#destroy", :id => "1")
    end

  end
end
