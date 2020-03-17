# frozen_string_literal: true

require_relative "../rails_helper"

RSpec.describe Work, type: :model do
  describe "instance methods" do
    describe "#all_work_ids_in_collection" do
      it "sorts by default on inventory and id" do
        w = works(:work1)
        expect(w.all_work_ids_in_collection.count).to eq 3
        expect(w.work_index_in_collection).to eq(0)
        w = works(:work5)
        expect(w.all_work_ids_in_collection.count).to eq 3
        expect(w.work_index_in_collection).to eq(2)
      end
      it "can sort on super collection" do
        w = works(:work1)
        parent = w.collection.parent_collection
        parent.sort_works_by = :inventoried_at
        parent.save
        expect(w.all_work_ids_in_collection.count).to eq 3
        expect(w.work_index_in_collection).to eq(1)
        w = works(:work2)
        expect(w.all_work_ids_in_collection.count).to eq 3
        expect(w.work_index_in_collection).to eq(0)
      end
    end
    describe "#artist_#\{index\}_methods" do
      it "should have a first artist" do
        w = works(:work1)
        expect(w.artist_0_last_name).to eq("artist_1")
        expect(w.artist_0_first_name).to eq("firstname")
      end
      it "should return nil when no artist is found at index" do
        w = works(:work1)
        expect(w.artist_4_last_name).to eq(nil)
        expect(w.artist_4_first_name).to eq(nil)
      end
    end
    describe "#frame_type" do
      it "should be able to set a FrameType" do
        w = works(:work1)
        w.frame_type = FrameType.create(name: "test")
        w.save
        expect(w.frame_type.name).to eq("test")
      end
    end
    describe "#stock_number_file_safe" do
      it "should not change good number" do
        expect(Work.new(stock_number: 123).stock_number_file_safe).to eq "123"
      end
      it "should change risky number" do
        expect(Work.new(stock_number: "12/3").stock_number_file_safe).to eq "12-3"
        expect(Work.new(stock_number: "12//3").stock_number_file_safe).to eq "12--3"
        expect(Work.new(stock_number: "1:\\2//3").stock_number_file_safe).to eq "1--2--3"
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
    describe "#purchased_on=" do
      it "should accept a date" do
        w = works(:work1)
        date = Date.new(1978, 12, 22)
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
        date = Date.new(1978, 12, 22)
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
        date = 2012
        w.purchased_on = date
        w.save
        w.reload
        expect(w.purchased_on).to eq(nil)
        expect(w.purchase_year).to eq(2012)
      end
      it "should accept a number in a string" do
        w = works(:work1)
        date = "2012"
        w.purchased_on = date
        w.save
        w.reload
        expect(w.purchased_on).to eq(nil)
        expect(w.purchase_year).to eq(2012)
      end
    end
    describe "#damage_types" do
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
        w.cluster_name = ""
        expect(w.cluster).to eq(nil)
        w = works(:work1)
        w.reload
        expect(w.cluster).to eq(clusters(:cluster1))
        w.cluster_name = nil
        expect(w.cluster).to eq(nil)
        w.save
        w.reload
        w = works(:work1)
        expect(w.cluster).to eq(nil)
      end
      it "should reset cluster when set to a different name" do
        w = works(:work1)
        expect(w.cluster).to eq(clusters(:cluster1))
        w.cluster_name = "cluster2"
        expect(w.cluster).to eq(clusters(:cluster2))
        w.save
        w.reload
        expect(w.cluster).to eq(clusters(:cluster2))
      end
      it "should create cluster when set to a different name" do
        w = works(:work1)
        expect(w.cluster).to eq(clusters(:cluster1))
        w.cluster_name = "cluster new"
        expect(w.cluster.class).to eq(Cluster)
        w.save
        w.reload
        expect(w.cluster_name).to eq("cluster new")
      end
    end
    describe "#location_description" do
      it "concats the location fields" do
        expect(works(:work1).location_description).to eq("Adres; Floor 1; Room 1")
      end
      it "returns emtpy string when none" do
        expect(Work.new.location_description).to eq(nil)
      end
    end
    describe "#location_history" do
      it "returns an empty array if no history" do
        expect(works(:work1).location_history).to eq([])
      end
      it "returns a single item array if no history" do
        work1 = works(:work1)
        work1.location = "New adress"
        work1.save
        work1.location = "Newer address"
        work1.save
        expect(works(:work1).location_history.collect { |a| a[:location] }).to eq(["New adress", "Newer address"])
      end
      it "returns complete history if work is created after enabling history" do
        work = collections(:collection1).works.create(location: "first location")
        work.location = "second location"
        work.save
        work.location = "third location"
        work.save
        expect(work.location_history.collect { |a| a[:location] }).to eq(["first location", "second location", "third location"])
      end
      it "skip_current options skips current" do
        work = collections(:collection1).works.create(location: "first location")
        work.location = "second location"
        work.save
        expect(work.location_history(skip_current: true).collect { |a| a[:location] }).to eq(["first location"])
      end
      it "returns empty location if empty location" do
        work = collections(:collection1).works.create(location: "first location")
        work.location = nil
        work.save
        expect(work.location_history.collect { |a| a[:location] }).to eq(["first location", nil])
      end
      it "never returns empty location if empty location and no empty locations" do
        work = collections(:collection1).works.create(location: "first location")
        work.location = ""
        work.save
        expect(work.location_history(empty_locations: false).collect { |a| a[:location] }).to eq(["first location"])
      end
      it "never returns empty location if empty location and no empty locations (and doesn't just pop the skip current false)" do
        work = collections(:collection1).works.create(location: "first location")
        work.location = ""
        work.save
        expect(work.location_history(empty_locations: false, skip_current: true).collect { |a| a[:location] }).to eq(["first location"])
      end
    end
    describe "#purchased_on_with_fallback" do
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
    describe "#next" do
      it "should redirect to the next work" do
        w = works(:work1)
        expect(w.next).to eq(works(:work2))
        expect(w.next.next).to eq(works(:work5))
      end
      it "should return first if no next" do
        expect(works(:work5).next).to eq(works(:work1))
      end
    end
    describe "#previous" do
      it "should redirect to the previous work" do
        w = works(:work5)
        expect(w.previous).to eq(works(:work2))
        expect(w.previous.previous).to eq(works(:work1))
      end
      it "should return last if no previous" do
        expect(works(:work1).previous).to eq(works(:work5))
      end
    end
    describe "#object_creation_year" do
      it "should return nil if object_creation_year_unknown = true" do
        w = works(:work2)
        w.object_creation_year = 2012
        w.save; w.reload
        expect(w.object_creation_year).to eq(2012)
        w.object_creation_year_unknown = true
        w.save; w.reload
        expect(w.object_creation_year).to eq(nil)
      end
    end
    describe "#object_format_code" do
      it "should return proper format code" do
        expect(works(:work2).object_format_code).to eq(nil)
        w = works(:work2)
        w.height = 200
        expect(w.object_format_code).to eq(:xl)
        w.height = 90
        expect(w.object_format_code).to eq(:l)
      end
    end
    describe "#frame_size_with_fallback" do
      it "should return frame size by default" do
        expect(works(:work1).frame_size_with_fallback).to eq(works(:work1).frame_size)
        expect(works(:work2).frame_size_with_fallback).to eq(nil)
        # expect(works(:work2).frame_size_with_fallback).to eq(works(:work2).frame_size)
      end
      it "should return work size if frame size is not present" do
        w = works(:work2)
        w.height = 90
        w.width = 180
        expect(works(:work2).frame_size_with_fallback).not_to eq(nil)
        expect(works(:work2).frame_size_with_fallback).to eq("180 × 90 (b×h)")
      end
    end
    describe "#restore_last_location_if_blank!" do
      it "shoudl restore last location when blenk" do
        w = collections(:collection1).works.create(location: "first location")

        original_location_description = w.location_description
        w.location = nil
        w.location_floor = nil
        w.location_detail = nil
        w.save

        expect(w.location_description).to eq(nil)
        expect(w.versions.last.reify.location_description).to eq(original_location_description)
        w.restore_last_location_if_blank!
        w.reload
        expect(w.location_description).to eq(original_location_description)
      end

      it "should not 'restore' a location if location is set" do
        w = collections(:collection1).works.create(location: "first location")
        w.location = "new location"
        w.save
        w.restore_last_location_if_blank!
        w.reload
        expect(w.location_description).to eq("new location")
      end
    end
    describe "#save" do
      it "should save, even without info" do
        w = collections(:collection1).works.new
        w.save
        expect(w.id).to be > 1
      end
      # it "should save, even with just comments set" do
      #   w = Work.new
      #   w.save
      #   expect(w.id).to be > 1
      # end
    end
  end
  describe "class methods" do
    describe ".artist_name_rendered" do
      it "should not fail on an empty name" do
        w = Work.new
        w.save
        expect(w.artist_name_rendered).to eq(nil)
      end
      it "should summarize the artists nicely" do
        w = works(:work1)
        w.save
        w.reload
        expect(w.artist_name_rendered).to eq("artist_1, firstname (1900 - 2000)")
      end
      it "should respect include_years option" do
        works(:work1).save
        expect(works(:work1).artist_name_rendered(include_years: false)).to eq("artist_1, firstname")
      end
    end
    describe ".artist_name_rendered_without_years_nor_locality" do
      it "should summarize the artist nicely" do
        works(:work1).save
        expect(works(:work1).artist_name_rendered_without_years_nor_locality).to eq("artist_1, firstname")
      end
      it "should summarize the artists nicely" do
        works(:work1).artists << artists(:artist2)
        works(:work1).save
        expect(works(:work1).artist_name_rendered_without_years_nor_locality_semicolon_separated).to match("artist_1, firstname")
        expect(works(:work1).artist_name_rendered_without_years_nor_locality_semicolon_separated).to match("artist_2 achternaam, firstie")
        expect(works(:work1).artist_name_rendered_without_years_nor_locality_semicolon_separated).to match(";")
      end
    end
    describe ".artist_name_rendered_without_years_nor_locality_semicolon_separated" do
      it "should summarize the artist nicely" do
        works(:work1).save
        expect(works(:work1).artist_name_rendered_without_years_nor_locality_semicolon_separated).to eq("artist_1, firstname")
      end
      it "should summarize the artists nicely" do
        works(:work1).artists << artists(:artist2)
        works(:work1).save
        expect(works(:work1).artist_name_rendered_without_years_nor_locality_semicolon_separated).to match("artist_1, firstname")
        expect(works(:work1).artist_name_rendered_without_years_nor_locality_semicolon_separated).to match("artist_2 achternaam, firstie")
        expect(works(:work1).artist_name_rendered_without_years_nor_locality_semicolon_separated).to match(";")
      end
    end
    describe ".possible_exposable_fields" do
      it "should return possible_exposable_fields" do
        expect(Work.possible_exposable_fields).to include(["Eigendom", "owner"])
        expect(Work.possible_exposable_fields).to include(["Locatie specificatie", "location_detail"])
        expect(Work.possible_exposable_fields).to include(["Verdieping", "location_floor"])
      end
    end

    describe ".fast_aggregations" do
      it "should allow to be initialized" do
        works = [works(:work1), works(:work2)]
        aggregations = Work.fast_aggregations [:title, :themes, :subset, :grade_within_collection]
        expect(aggregations.count).to eq 4
        expect(aggregations[:title]["Work1"][:count]).to eq 999999
        expect(aggregations[:themes][themes(:wind)][:count]).to eq 999999
        expect(aggregations[:grade_within_collection]["A"][:count]).to eq 999999
        expect(aggregations[:grade_within_collection]["H"]).to eq nil
      end
    end
    describe ".whd_to_s" do
      it "should render nil if all are nil" do
        expect(Work.new.whd_to_s).to eq(nil)
      end
      it "should render w x h x d if set" do
        expect(Work.new.whd_to_s(1, 2, 3)).to eq("1 × 2 × 3 (b×h×d)")
      end
      it "should round w x h x d" do
        expect(Work.new.whd_to_s(1.002345, 2.2323543, 3.777777)).to eq("1,0023 × 2,2324 × 3,7778 (b×h×d)")
      end
      it "should add diameter if set" do
        expect(Work.new.whd_to_s(1, 2, 3, 4)).to eq("1 × 2 × 3 (b×h×d); ⌀ 4")
      end
      it "should add diameter if set" do
        expect(Work.new.whd_to_s(1, nil, 3, 4)).to eq("1 × 3 (b×d); ⌀ 4")
      end
    end
    describe ".frame_size" do
      it "should use whd_to_s" do
        expect(Work.new(frame_width: 1, frame_height: nil, frame_depth: 3, frame_diameter: 4).frame_size).to eq("1 × 3 (b×d); ⌀ 4")
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
      it "should return basic types" do
        collection = collections(:collection_with_works)
        work = collection.works.order(:stock_number).first
        work.save
        workbook = collection.works.order(:stock_number).to_workbook(collection.fields_to_expose(:default))
        expect(workbook.class).to eq(Workbook::Book)
        expect(workbook.sheet.table[1][:inventarisnummer].value).to eq(work.stock_number)
        expect(work.artists.first.name).to eq("artist_1, firstname (1900 - 2000)")
        expect(workbook.sheet.table[1][:vervaardigers].value).to eq("artist_1, firstname (1900 - 2000)")
      end
    end
    describe ".update" do
      it "updates collection" do
        works = Work.where(id: works(:work1).id)
        new_collection = collections :collection_with_works_child

        expect(works[0].collection).not_to eq new_collection
        works.update(collection: new_collection)
        works = Work.where(id: works(:work1).id)
        expect(works[0].collection).to eq new_collection
      end
      it "throws error when updating a work that doesn't validate" do
        works = Work.where(id: works(:work_with_private_theme).id)
        new_collection = collections :collection_with_works_child

        expect(works[0].collection).not_to eq new_collection

        works = Work.where(id: works(:work1).id)
        # expect(works[0].collection).to eq new_collection
      end
    end
    describe ".column_types" do
      it "returns a hash" do
        expect(Work.column_types).to be_a(Hash)
      end
      [
        inventoried: :boolean,
        title: :string
      ].each do |k, v|
        it "should return #{v} for #{k}" do
          expect(Work.column_types[k.to_s]).to eq(v)
        end
      end
    end
  end
  describe "Scopes" do
    describe ".has_number" do
      it "finds nothing when an unknown number is passed" do
        expect(Work.has_number("not a known number").pluck(:id)).to eq([])
      end
      it "finds by alt number" do
        expect(Work.has_number(7201284).pluck(:id)).to match_array([works(:work1)].map(&:id))
      end
      it "finds by stock number" do
        expect(Work.has_number("Q001").pluck(:id)).to match_array([works(:work1)].map(&:id))
      end
      it "finds by array" do
        expect(Work.has_number(["Q001", "Q005"]).pluck(:id)).to match_array([works(:work1), works(:work5)].map(&:id))
      end
      it "finds by array on all numbers" do
        expect(Work.has_number(%w[Q001 7201286 7201212 7201213]).pluck(:id)).to match_array([works(:work1), works(:work2), works(:work3), works(:work4)].map(&:id))
      end
      it "adheres earlier scopes" do
        expect(collections(:collection_with_works).works.has_number(%w[Q001 7201286 7201212 7201213]).pluck(:id)).to match_array([works(:work1), works(:work2)].map(&:id))
      end
    end
    describe ".order_by" do
      describe "artist" do
        it "works when there are no artists" do
          expect(Work.order_by(:artist_name).last).to eq(works(:artistless_work))
        end
      end
      describe "location" do
        it "sorts -1 before BG" do
          c = collections(:sub_boring_collection)
          c.works.create(location_floor: "BG")
          c.works.create(location_floor: "1")
          c.works.create(location_floor: "-1")
          c.works.create(location_floor: "-2")
          c.works.create(location_floor: "-3")
          c.works.create(location_floor: "0")
          c.works.create(location_floor: "4")
          c.works.create(location_floor: "Depot")

          expect(c.works.order_by(:location).map(&:location_floor)).to eq(["-3", "-2", "-1", "0", "BG", "1", "4", "Depot"])
        end
        it "sorts by location, floor, detail" do
          c = collections(:sub_boring_collection)
          c.works.create(location: "A", location_floor: "-1", location_detail: "C1")
          c.works.create(location: "A", location_floor: "-1", location_detail: "D1")
          c.works.create(location: "A", location_floor: "1", location_detail: "C1")
          c.works.create(location: "A", location_floor: "1", location_detail: "C2")
          c.works.create(location: "A", location_floor: "BG", location_detail: "2")
          c.works.create(location: "A", location_floor: "BG", location_detail: "1")
          c.works.create(location: "B", location_floor: "-1", location_detail: "C1")
          c.works.create(location: "B", location_floor: "1", location_detail: "B1")
          c.works.create(location: "B", location_floor: "BG", location_detail: "A1")
          expect(c.works.map { |w| "#{w.location} #{w.location_floor} #{w.location_detail}" }.join(" < ")).not_to eq(
            ["A -1 C1", "A -1 D1", "A BG 1", "A BG 2", "A 1 C1", "A 1 C2", "B -1 C1", "B BG A1", "B 1 B1"].join(" < ")
          )
          expect(c.works.order_by(:location).map { |w| "#{w.location} #{w.location_floor} #{w.location_detail}" }.join(" < ")).to eq(
            ["A -1 C1", "A -1 D1", "A BG 1", "A BG 2", "A 1 C1", "A 1 C2", "B -1 C1", "B BG A1", "B 1 B1"].join(" < ")
          )
        end
      end
    end
  end
end
