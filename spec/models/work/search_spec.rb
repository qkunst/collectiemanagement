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
    end
  end
end
