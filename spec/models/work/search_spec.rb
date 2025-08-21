# frozen_string_literal: true

require_relative "../../rails_helper"

RSpec.describe Work::Search, type: :model do
  describe "instance methods" do
    describe "#as_indexed_json" do
      it "returns an empty hash when nothing is set" do
        expect(Work.new.as_indexed_json.keys).to include("themes")
      end
      it "returns an empty hash when nothing is set" do
        expect(Work.new.as_indexed_json.keys).to include("themes")
      end

      it "doesn't include availability_status if not active for collection" do
        expect(Work.new.as_indexed_json.keys).not_to include("availability_status")
      end

      it "does include availability status when active" do
        expect(works(:collection_with_availability_sold).as_indexed_json.keys).to include("availability_status")
        expect(works(:collection_with_availability_available_work).as_indexed_json.keys).to include("availability_status")
      end
    end
  end

  describe "class methods" do
    describe ".build_search_and_filter_query" do
      it "returns a hash" do
        expect(Work.build_search_and_filter_query).to be_a(Hash)
      end

      it "filters for ids" do
        expect(Work.build_search_and_filter_query("", {id: [1, 2, 3, 4]})[:query][:bool][:must][0]).to eq({terms: {id: [1, 2, 3, 4]}})
      end

      it "filters for tags" do
        expect(Work.build_search_and_filter_query("", {"tag_list" => ["winter"], "_and" => ["tag_list"]})[:query][:bool][:must][0]).to eq(bool: {minimum_should_match: 1, should: [{term: {"tag_list" => "winter"}}]})
        expect(Work.build_search_and_filter_query("", {"tag_list" => ["winter", "zomer"], "_and" => ["tag_list"]})[:query][:bool][:must][0]).to eq(bool: {minimum_should_match: 2, should: [{term: {"tag_list" => "winter"}}, {term: {"tag_list" => "zomer"}}]})
        expect(Work.build_search_and_filter_query("", {"tag_list" => [nil], "_and" => ["tag_list"]})[:query]).to eq(bool: {must: [{bool: {minimum_should_match: 1, should: [{bool: {must_not: {exists: {field: "tag_list"}}}}]}}]})
      end

      it "filters for location_raw" do
        expect(Work.build_search_and_filter_query("", {"location_raw" => ["Depot 1", "Depot 2"]})[:query]).to eq(bool: {must: [{bool: {should: [{term: {"location_raw" => "Depot 1"}}, {term: {"location_raw" => "Depot 2"}}]}}]})
      end

      it "filters for cluster" do
        expect(Work.build_search_and_filter_query("", {"cluster_id" => [nil, 1]})[:query]).to eq(bool: {must: [{bool: {should: [{bool: {must_not: {exists: {field: "cluster_id"}}}}, {term: {"cluster_id" => 1}}]}}]})
      end

      it "_invert above filters" do
        expect(Work.build_search_and_filter_query("", {"cluster_id" => [nil, 1], "_invert" => ["cluster_id"]})[:query]).to eq(bool: {must: [{bool: {must_not: [{bool: {must_not: {exists: {field: "cluster_id"}}}}, {term: {"cluster_id" => 1}}]}}]})
        expect(Work.build_search_and_filter_query("", {"location_raw" => ["Depot 1", "Depot 2"], "_invert" => "location_raw"})[:query]).to eq(bool: {must: [{bool: {must_not: [{term: {"location_raw" => "Depot 1"}}, {term: {"location_raw" => "Depot 2"}}]}}]})
      end

      it "handles complex case" do
        expect(Work.build_search_and_filter_query("", {"tag_list" => ["winter", "zomer"], "cluster_id" => [nil, 1], "location_raw" => ["Depot 1", "Depot 2"], "_and" => ["tag_list"], "_invert" => ["cluster_id", "tag_list"]})[:query]).to eq(bool: {
          must: [
            {bool: {minimum_should_match: 2, must_not: [{term: {"tag_list" => "winter"}}, {term: {"tag_list" => "zomer"}}]}},
            {bool: {must_not: [{bool: {must_not: {exists: {field: "cluster_id"}}}}, {term: {"cluster_id" => 1}}]}},
            {bool: {should: [{term: {"location_raw" => "Depot 1"}}, {term: {"location_raw" => "Depot 2"}}]}}
          ]
        })
      end
    end
  end
end
