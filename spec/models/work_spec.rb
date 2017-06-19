require 'rails_helper'

RSpec.describe Work, type: :model do
  describe "instance methods" do
    describe "frame_type" do
      it "should be able to set a FrameType" do
        w = works(:work1)
        w.frame_type = FrameType.create(name: "test")
        w.save
        expect(w.frame_type.name).to eq("test")
      end
    end
    describe "#height" do
      it "should accept integer" do
        w = works(:work1)
        w.height = 1
        w.save
        w.reload
        expect(w.height).to eq 1.0
      end
      it "should accept string" do
        w = works(:work1)
        w.height = "12"
        w.save
        w.reload
        expect(w.height).to eq 12.0
      end
      it "should accept us-localized string" do
        w = works(:work1)
        w.height = "12.1"
        w.save
        w.reload
        expect(w.height).to eq 12.1
      end
      it "should accept nl-localized string" do
        w = works(:work1)
        w.height = "12,1"
        w.save
        w.reload
        expect(w.height).to eq 12.1
      end
      it "should accept long nl-localized string" do
        w = works(:work1)
        w.height = "12.012,1"
        w.save
        w.reload
        expect(w.height).to eq 12012.1
      end
    end
    describe ".purchased_on=" do
      it "should accept a date" do
        w = works(:work1)
        date =  Date.new(1978, 12, 22)
        w.purchased_on = date
        w.save
        w.reload
        expect(w.purchased_on).to eq(date)
        expect(w.purchase_year).to eq(1978)
      end
      it "should not fail on an empty string" do
        w = works(:work1)
        w.purchased_on = ""
        w.save
        w.reload
        expect(w.purchased_on).to eq(nil)
        expect(w.purchase_year).to eq(nil)
      end
      it "should accept a string" do
        w = works(:work1)
        date =  Date.new(1978, 12, 22)
        date_string = date.to_s
        w.purchased_on = date_string
        w.save
        w.reload
        expect(w.purchased_on).to eq(date)
        expect(w.purchase_year).to eq(1978)
      end
      it "should accept a nil" do
        w = works(:work1)
        w.purchased_on = nil
        w.save
        w.reload
        expect(w.purchased_on).to be_nil
      end
      it "should accept a number" do
        w = works(:work1)
        date =  2012
        w.purchased_on = date
        w.save
        w.reload
        expect(w.purchased_on).to eq(nil)
        expect(w.purchase_year).to eq(2012)
      end
      it "should accept a number in a string" do
        w = works(:work1)
        date =  "2012"
        w.purchased_on = date
        w.save
        w.reload
        expect(w.purchased_on).to eq(nil)
        expect(w.purchase_year).to eq(2012)
      end
    end
    describe ".damage_types" do
      it "should be an empty by default" do
        w = works(:work1)
        expect(w.damage_types).to eq([])
      end
      it "should should touch work on add (and should only return once)" do
        w = works(:work1)
        original_updated_at = w.updated_at
        w.damage_types << damage_types(:a)
        w.damage_types << damage_types(:a)
        expect(w.damage_types).to eq([damage_types(:a)])
        expect(w.updated_at - original_updated_at).to be > 0.001
      end
    end
    describe "#cluster_name" do
      it "should set cluster to nil when name is nil or empty" do
        w = works(:work1)
        expect(w.cluster).to eq(clusters(:cluster1))
        w.cluster_name= ""
        expect(w.cluster).to eq(nil)
        w = works(:work1)
        w.reload
        expect(w.cluster).to eq(clusters(:cluster1))
        w.cluster_name= nil
        expect(w.cluster).to eq(nil)
        w.save
        w.reload
        w = works(:work1)
        expect(w.cluster).to eq(nil)
      end
      it "should reset cluster when set to a different name" do
        w = works(:work1)
        expect(w.cluster).to eq(clusters(:cluster1))
        w.cluster_name= "cluster2"
        expect(w.cluster).to eq(clusters(:cluster2))
        w.save
        w.reload
        expect(w.cluster).to eq(clusters(:cluster2))
      end
      it "should create cluster when set to a different name" do
        w = works(:work1)
        expect(w.cluster).to eq(clusters(:cluster1))
        w.cluster_name= "cluster new"
        expect(w.cluster.class).to eq(Cluster)
        w.save
        w.reload
        expect(w.cluster_name).to eq("cluster new")
      end
    end
    describe ".purchased_on_with_fallback" do
      it "should return nil when not set" do
        w = works(:work1)
        expect(w.purchased_on_with_fallback).to eq(nil)
      end
      it "should return date both year and date are present" do
        w = works(:work1)
        w.purchased_on = Date.new(1978, 12, 22)
        w.purchase_year = 1978
        expect(w.purchased_on_with_fallback).to eq(Date.new(1978, 12, 22))
      end
      it "should return year if only year is present" do
        w = works(:work1)
        w.purchase_year = 1978
        expect(w.purchased_on_with_fallback).to eq(1978)
      end
    end
  end
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
        works(:work1).save
        expect(works(:work1).artist_name_rendered).to eq("artist_1, firstname (1900 - 2000)")
      end
      it "should respect include_years option" do
        works(:work1).save
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
    describe ".whd_to_s" do
      it "should render nil if all are nil" do
        expect(Work.new.whd_to_s).to eq("")
      end
      it "should render w x h x d if set" do
        expect(Work.new.whd_to_s(1, 2, 3)).to eq("1 x 2 x 3 (bxhxd)")
      end
      it "should round w x h x d" do
        expect(Work.new.whd_to_s(1.002345, 2.2323543, 3.777777)).to eq("1,0023 x 2,2324 x 3,7778 (bxhxd)")
      end
      it "should add diameter if set" do
        expect(Work.new.whd_to_s(1, 2, 3, 4)).to eq("1 x 2 x 3 (bxhxd); ⌀ 4")
      end
      it "should add diameter if set" do
        expect(Work.new.whd_to_s(1, nil, 3, 4)).to eq("1 x 3 (bxd); ⌀ 4")
      end
    end
    describe ".frame_size" do
      it "should use whd_to_s" do
        expect(Work.new(frame_width: 1, frame_height: nil, frame_depth: 3, frame_diameter: 4).frame_size).to eq("1 x 3 (bxd); ⌀ 4")
      end
    end
    describe ".to_workbook" do
      it "should be callable and return a workbook" do
        expect(Work.to_workbook.class).to eq(Workbook::Book)
      end
      it "should be work even with complex fieldset" do
        collection = collections(:collection4)

        expect(Work.to_workbook(collection.fields_to_expose(:default)).class).to eq(Workbook::Book)
      end
      it "should work with tags" do
        collection = collections(:collection_with_works)
        work = collection.works.first
        work.tag_list = "kaas"
        work.save
        expect(Work.to_workbook(collection.fields_to_expose(:default)).class).to eq(Workbook::Book)
      end

    end
  end
end
