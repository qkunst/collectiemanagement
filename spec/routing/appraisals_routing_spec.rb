# frozen_string_literal: true

require "rails_helper"

RSpec.describe AppraisalsController, type: :routing do
  describe "routing" do
    it "routes to #new" do
      expect(get: "/collections/1/works/2/appraisals/new").to route_to("appraisals#new", "collection_id" => "1", "work_id" => "2")
    end

    it "routes to #edit" do
      expect(get: "/collections/1/works/2/appraisals/1/edit").to route_to("appraisals#edit", "collection_id" => "1", "work_id" => "2", :id => "1")
    end

    it "routes to #create" do
      expect(post: "/collections/1/works/2/appraisals").to route_to("appraisals#create", "collection_id" => "1", "work_id" => "2")
    end

    it "routes to #update via PUT" do
      expect(put: "/collections/1/works/2/appraisals/1").to route_to("appraisals#update", "collection_id" => "1", "work_id" => "2", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/collections/1/works/2/appraisals/1").to route_to("appraisals#update", "collection_id" => "1", "work_id" => "2", :id => "1")
    end

    it "routes to #destroy" do
      expect(delete: "/collections/1/works/2/appraisals/1").to route_to("appraisals#destroy", "collection_id" => "1", "work_id" => "2", :id => "1")
    end
  end
end
