require 'rails_helper'

RSpec.describe Work, type: :model do
  describe  "class methods" do
    describe ".aggregations" do
      it "should allow to be initialized" do
        works = [works(:work1),works(:work2)]
        # expect()
        aggregations = Work.aggregations [:title, :themes, :subset, :grade_within_collection]
        expect(aggregations.count).to eq 4
        expect(aggregations[:title][:work1][:count]).to eq 1
        expect(aggregations[:themes][themes(:wind)][:count]).to eq 2
        expect(aggregations[:grade_within_collection][:a][:count]).to eq 2

      end
    end
    describe ".artist_name_rendered" do
      it "should summarize the artists nicely" do
        expect(works(:work1).artist_name_rendered).to eq("artist_1, firstname (1900-2000)")
      end
      it "should respect include_years option" do
        expect(works(:work1).artist_name_rendered(include_years: false)).to eq("artist_1, firstname")
      end
    end
    describe ".fast_aggregations" do
      it "should allow to be initialized" do
        works = [works(:work1),works(:work2)]
        # expect()
        aggregations = Work.fast_aggregations [:title, :themes, :subset, :grade_within_collection]
        expect(aggregations.count).to eq 4
        expect(aggregations[:title][:work1][:count]).to eq 999999
        expect(aggregations[:themes][themes(:wind)][:count]).to eq 999999
        expect(aggregations[:grade_within_collection][:a][:count]).to eq 999999
        expect(aggregations[:grade_within_collection][:h]).to eq nil

      end
    end
  end
end
