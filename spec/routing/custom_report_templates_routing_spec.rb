require "rails_helper"

RSpec.describe CustomReportTemplatesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/custom_report_templates").to route_to("custom_report_templates#index")
    end

    it "routes to #new" do
      expect(:get => "/custom_report_templates/new").to route_to("custom_report_templates#new")
    end

    it "routes to #show" do
      expect(:get => "/custom_report_templates/1").to route_to("custom_report_templates#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/custom_report_templates/1/edit").to route_to("custom_report_templates#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/custom_report_templates").to route_to("custom_report_templates#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/custom_report_templates/1").to route_to("custom_report_templates#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/custom_report_templates/1").to route_to("custom_report_templates#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/custom_report_templates/1").to route_to("custom_report_templates#destroy", :id => "1")
    end

  end
end
