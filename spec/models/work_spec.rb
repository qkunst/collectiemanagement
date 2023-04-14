# frozen_string_literal: true

# == Schema Information
#
# Table name: works
#
#  id                                                  :bigint           not null, primary key
#  abstract_or_figurative                              :string
#  alt_number_1                                        :string
#  alt_number_2                                        :string
#  alt_number_3                                        :string
#  appraisal_notice                                    :text
#  artist_name_for_sorting                             :string
#  artist_name_rendered                                :string
#  artist_unknown                                      :boolean
#  checked_at                                          :datetime
#  collection_locality_artist_involvements_texts_cache :text
#  condition_frame_comments                            :text
#  condition_work_comments                             :text
#  created_by_name                                     :string
#  depth                                               :float
#  description                                         :text
#  diameter                                            :float
#  entry_status                                        :string
#  entry_status_description                            :text
#  external_inventory                                  :boolean
#  for_purchase_at                                     :datetime
#  for_rent_at                                         :datetime
#  frame_depth                                         :float
#  frame_diameter                                      :float
#  frame_height                                        :float
#  frame_width                                         :float
#  grade_within_collection                             :string
#  height                                              :float
#  highlight_priority                                  :integer
#  image_rights                                        :boolean
#  imported_at                                         :datetime
#  information_back                                    :text
#  internal_comments                                   :text
#  inventoried_at                                      :datetime
#  location                                            :string
#  location_detail                                     :string
#  location_floor                                      :string
#  lognotes                                            :text
#  main_collection                                     :boolean
#  market_value                                        :decimal(16, 2)
#  market_value_max                                    :decimal(16, 2)
#  market_value_min                                    :decimal(16, 2)
#  medium_comments                                     :text
#  minimum_bid                                         :decimal(16, 2)
#  new_found_at                                        :datetime
#  no_signature_present                                :boolean
#  object_creation_year                                :integer
#  object_creation_year_unknown                        :boolean
#  old_data                                            :text
#  other_comments                                      :text
#  other_structured_data                               :text
#  permanently_fixed                                   :boolean
#  photo_back                                          :string
#  photo_detail_1                                      :string
#  photo_detail_2                                      :string
#  photo_front                                         :string
#  price_reference                                     :text
#  print                                               :string
#  print_unknown                                       :boolean
#  public_description                                  :text
#  publish                                             :boolean
#  publish_selling_price                               :boolean          default(TRUE)
#  purchase_price                                      :decimal(16, 2)
#  purchase_price_in_eur                               :decimal(16, 2)
#  purchase_year                                       :integer
#  purchased_on                                        :date
#  refound_at                                          :datetime
#  removed_from_collection_at                          :datetime
#  removed_from_collection_note                        :string
#  replacement_value                                   :decimal(16, 2)
#  replacement_value_max                               :decimal(16, 2)
#  replacement_value_min                               :decimal(16, 2)
#  selling_price                                       :decimal(16, 2)
#  selling_price_minimum_bid_comments                  :text
#  signature_comments                                  :text
#  significantly_updated_at                            :datetime
#  source_comments                                     :text
#  stock_number                                        :string
#  tag_list_cache                                      :text
#  title                                               :string
#  title_unknown                                       :boolean
#  valuation_on                                        :date
#  width                                               :float
#  created_at                                          :datetime         not null
#  updated_at                                          :datetime         not null
#  balance_category_id                                 :bigint
#  cluster_id                                          :bigint
#  collection_id                                       :bigint
#  condition_frame_id                                  :bigint
#  condition_work_id                                   :bigint
#  created_by_id                                       :bigint
#  fin_balance_item_id                                 :string
#  frame_type_id                                       :bigint
#  import_collection_id                                :bigint
#  locality_geoname_id                                 :bigint
#  medium_id                                           :bigint
#  owner_id                                            :bigint
#  placeability_id                                     :bigint
#  purchase_price_currency_id                          :bigint
#  source_id                                           :bigint
#  style_id                                            :bigint
#  subset_id                                           :bigint
#  work_status_id                                      :bigint
#
# Indexes
#
#  index_works_on_alt_number_1   (alt_number_1)
#  index_works_on_alt_number_2   (alt_number_2)
#  index_works_on_alt_number_3   (alt_number_3)
#  index_works_on_collection_id  (collection_id)
#  index_works_on_stock_number   (stock_number)
#
require_relative "../rails_helper"

RSpec.describe Work, type: :model do
  describe "callbacks" do
    describe "significantly_updated_at" do
      it "does not update when nothing changed" do
        w = works(:work1)
        expect {
          w.save
        }.not_to change(w, :significantly_updated_at)
      end
      it "does update on create" do
        w = collections(:collection1).works.create
        expect(w.significantly_updated_at.to_date).to eq(w.created_at.to_date)
      end
      it "does update on a title change" do
        w = works(:work1)
        expect {
          w.title = "abc"
          w.save
        }.to change(w, :significantly_updated_at)
        w = works(:work1)
        expect {
          w.update(title: "abca")
        }.to change(w, :significantly_updated_at)
      end
      it "does update on a publish" do
        w = works(:work1)
        expect {
          w.update(publish: !w.publish)
        }.to change(w, :significantly_updated_at)
      end
      it "does update on a artist change" do
        w = works(:work1)
        expect {
          w.artists << artists(:artist2)
          w.save
        }.to change(w, :significantly_updated_at)

        expect(w.versions.last.object_changes).to match(/artist_name_for_sorting/)
      end
    end
  end
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
        expect(w.all_work_ids_in_collection.count).to eq 5
        expect(w.work_index_in_collection).to eq(1)
        w = works(:work2)
        expect(w.all_work_ids_in_collection.count).to eq 5
        expect(w.work_index_in_collection).to eq(0)
      end
    end
    describe "#appraisable?" do
      it "should return true by default" do
        expect(works(:work1)).to be_appraisable
      end
      it "should return false on a work part of a diptych" do
        expect(works(:work_diptych_1)).not_to be_appraisable
      end
    end
    describe "#appraised?" do
      it "should return false by default" do
        expect(Work.new).not_to be_appraised
      end
      it "should return true for an appraised work" do
        expect(works(:work1)).to be_appraised
      end
    end

    describe "#balance_category" do
      it "returns nil none is set, balance category when set, and nil when appraised, but set" do
        w = Work.new(collection: collections(:collection1))
        expect(w.appraised?).to be_falsey
        expect(w.balance_category).to be_nil

        w.balance_category = balance_categories(:one)
        w.save

        expect(w.balance_category).to eq(balance_categories(:one))
        expect(w.balance_category_id).to eq(balance_categories(:one).id)

        Appraisal.create(appraised_on: Time.now, market_value: 1200, user: users(:admin), appraisee: w)

        expect(w.balance_category).to eq(nil)
        expect(w.balance_category_id).to eq(nil)
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
        w = works(:work2)
        expect(w.damage_types).to eq([])
      end
      it "should should touch work on add (and should only return once)" do
        w = works(:work2)
        original_updated_at = w.updated_at
        w.damage_types << damage_types(:a)
        w.damage_types << damage_types(:a)
        expect(w.damage_types).to match_array([damage_types(:a)])
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
    describe "#highlight, #highlight_priority" do
      it "defaults to false" do
        expect(works(:work1).highlight).to be_falsey
        expect(works(:work1).highlight?).to be_falsey
        expect(works(:work1).highlight_priority).to eq(nil)
      end

      it "returns true when > 0" do
        w = works(:work1)
        w.highlight_priority = 1

        expect(w.highlight).to be_truthy
        expect(w.highlight?).to be_truthy
        expect(w.highlight_priority).to eq(1)
      end

      it "returns nil for prio 0" do
        w = works(:work1)

        w.highlight_priority = 0
        expect(w.highlight_priority).to eq(nil)
        expect(works(:work1).highlight).to be_falsey
        expect(works(:work1).highlight?).to be_falsey
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
        w.save
        w.reload
        expect(w.object_creation_year).to eq(2012)
        w.object_creation_year_unknown = true
        w.save
        w.reload
        expect(w.object_creation_year).to eq(nil)
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
    describe "public_tag_list" do
      it "filters public tags" do
        w = Work.create(collection: collections(:collection1), tag_list: %(inventariseren 2020, vermist, 1984, blauw, bekijKen op, aangetroffen, naar fotograaf, selectie, H3 definitief, ontzamelen, aankopen, herplaatsen, navragen, Herplaatsing, Industrie))
        expect(w.public_tag_list).to eq(["1984", "blauw", "Industrie"])
      end
    end
    describe "work_set_attributes=" do
      it "ignores empty hashes" do
        w = Work.create(work_set_attributes: {})
        expect(w.work_sets.count).to eq(0)
      end
      it "ignores partially empty hashes" do
        w = Work.create(work_set_attributes: {identification_number: 123})
        expect(w.work_sets.count).to eq(0)
      end
      it "creates when full hash is given" do
        w = Work.new
        expect {
          w = Work.create(collection: collections(:collection1), work_set_attributes: {work_set_type_id: work_set_types(:meerluik).id, identification_number: 123})
        }.to change(WorkSet, :count).by(1)
        expect(w.work_sets.count).to eq(1)
      end
      it "reuses when full hash is given equal to earlier in same collection" do
        w1 = Work.new
        w2 = Work.new
        expect {
          w1 = Work.create(collection: collections(:collection1), work_set_attributes: {work_set_type_id: work_set_types(:meerluik).id, identification_number: 123})
        }.to change(WorkSet, :count).by(1)
        expect {
          w2 = Work.create(collection: collections(:collection1), work_set_attributes: {work_set_type_id: work_set_types(:meerluik).id, identification_number: 123})
        }.to change(WorkSet, :count).by(0)
        expect(w1.work_sets.count).to eq(1)
        expect(w2.work_sets.count).to eq(1)
        w2.work_sets.reload
        expect(w2.work_sets.first.work_ids).to match_array([w1, w2].map(&:id))
      end
      it "creates when full hash is given equal to earlier in other collection" do
        w1 = Work.new
        w2 = Work.new
        expect {
          w1 = Work.create(collection: collections(:collection1), work_set_attributes: {work_set_type_id: work_set_types(:meerluik).id, identification_number: 123})
        }.to change(WorkSet, :count).by(1)
        expect {
          w2 = Work.create(collection: collections(:collection2), work_set_attributes: {work_set_type_id: work_set_types(:meerluik).id, identification_number: 123})
        }.to change(WorkSet, :count).by(1)
        expect(w1.work_sets.count).to eq(1)
        expect(w2.work_sets.count).to eq(1)

        w1.work_sets.reload
        w2.work_sets.reload

        expect(w1.work_sets.first.work_ids).not_to include(w2.id)
        expect(w2.work_sets.first.work_ids).not_to include(w1.id)
      end
    end
  end
  describe "class methods" do
    describe ".count_as_whole_works" do
      it "should return all works uniquele" do
        work_count = Work.count
        works_in_worksets_counted_as_one = WorkSet.count_as_one.flat_map { |a| a.works.pluck(:id) }.uniq.count
        worksets_counted_as_one = WorkSet.count_as_one.count

        expect(Work.count_as_whole_works).to eq(work_count - works_in_worksets_counted_as_one + worksets_counted_as_one)
      end

      it "should return all works uniquely even when in two work sets" do
        work_count = Work.count
        works_in_worksets_counted_as_one = WorkSet.count_as_one.flat_map { |a| a.works.pluck(:id) }.uniq.count
        worksets_counted_as_one = WorkSet.count_as_one.count

        WorkSet.create(work_set_type: work_set_types(:possible_same_artist), works: [works(:work_diptych_1), works(:artistless_work)])

        expect(Work.count_as_whole_works).to eq(work_count - works_in_worksets_counted_as_one + worksets_counted_as_one)
      end
    end

    describe ".fast_aggregations" do
      it "should allow to be initialized" do
        works(:work1)
        works(:work2)
        aggregations = Work.fast_aggregations [:title, :themes, :subset, :grade_within_collection]
        expect(aggregations.count).to eq 4
        expect(aggregations[:title]["Work1"][:count]).to eq 999999
        expect(aggregations[:themes][themes(:wind)][:count]).to eq 999999
        expect(aggregations[:grade_within_collection]["A"][:count]).to eq 999999
        expect(aggregations[:grade_within_collection]["H"]).to eq nil
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

        Work.where(id: works(:work1).id)
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
    describe ".by_group" do
      describe "has and belongs to many" do
        it "returns works when id is passed in array" do
          expect(Work.by_group(:themes, [themes(:wind).id])).to match_array([works(:work1), works(:work2)])
        end
        it "returns relationless works when :not_set is passed in array" do
          expect(Work.by_group(:themes, [:not_set])).not_to include(works(:work1))
          expect(Work.by_group(:themes, ["not_set"])).not_to include(works(:work2))
          expect(Work.by_group(:themes, [nil])).to include(works(:work3))
          expect(Work.by_group(:themes, [nil])).to include(works(:work4))
          expect(Work.by_group(:themes, [nil])).to include(works(:work5))
        end
        it "returns relationless works and works with relations when both :not_set and and id is passed" do
          result_set = Work.by_group(:themes, [themes(:wind).id, :not_set])
          expect(result_set).to include(works(:work1))
          expect(result_set).to include(works(:work2))
          expect(result_set).to include(works(:work3))
          expect(result_set).to include(works(:work4))
          expect(result_set).to include(works(:work5))
        end
      end
      describe "belongs to" do
        it "returns works when id is passed in array" do
          expect(Work.by_group(:subset, [subsets(:contemporary).id])).to match_array([works(:work1)])
        end
        it "returns relationless works when :not_set is passed in array" do
          expect(Work.by_group(:subset, [:not_set])).not_to include(works(:work1))
          expect(Work.by_group(:subset, [:not_set])).to include(works(:work3))
        end
        it "returns relationless works and works with relations when both :not_set and and id is passed" do
          result_set = Work.by_group(:subset, [subsets(:contemporary).id, :not_set])
          expect(result_set).to include(works(:work1))
          expect(result_set).not_to include(works(:work2))
          expect(result_set).to include(works(:work3))
        end
      end
      describe "string to" do
        it "returns works when id is passed in array" do
          expect(Work.by_group(:grade_within_collection, ["A"])).to match_array([works(:work1)])
        end
        it "returns relationless works when :not_set is passed in array" do
          expect(Work.by_group(:grade_within_collection, [:not_set])).not_to include(works(:work1))
          expect(Work.by_group(:grade_within_collection, [:not_set])).to include(works(:work3))
        end
        it "returns relationless works and works with relations when both :not_set and and id is passed" do
          result_set = Work.by_group(:grade_within_collection, ["A", :not_set])
          expect(result_set).to include(works(:work1))
          expect(result_set).not_to include(works(:work2))
          expect(result_set).to include(works(:work3))
        end
      end
    end
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
    describe ".significantly_updated_since" do
      it "returns nothing when future" do
        expect(Work.significantly_updated_since(1.day.from_now)).to eq([])
      end
      it "returns only matching work" do
        w = works(:work1)
        w.update_columns(significantly_updated_at: 2.day.from_now)

        expect(Work.significantly_updated_since(1.day.from_now)).to eq([w])
      end
    end
    describe ".created_at_between" do
      it "works" do
        expect(Work.created_at_between(Date.new(2012, 1, 1), Date.new(2013, 1, 1)).count).to eq(7)
        expect(Work.created_at_between(Date.new(2012, 1, 1), Date.new(2013, 1, 1)).pluck(:id)).to include(works(:work1).id)
        expect(Work.created_at_between(Date.new(2012, 1, 1), Date.new(2013, 1, 1)).pluck(:id)).not_to include(works(:collection_with_availability_rent_work).id)
      end
    end
    describe ".sold_between" do
      let(:work) { works(:collection_with_availability_sold_with_time_span) }

      it "doesn't find a work when time period doesn't match any" do
        works = Work.sold_between(1.year.ago, Time.now)
        expect(works).to eq([])
      end

      it "does find a work if it is before a certain end date" do
        works = Work.sold_between(nil, Time.now)
        expect(works).to eq([work])
      end

      it "does find a work matching a very short period around the selling date" do
        works = Work.sold_between(DateTime.new(2020, 12, 31), DateTime.new(2021, 1, 2, 0))
        expect(works).to eq([work])
      end

      it "does not find a work matching a very short period just before the selling date" do
        works = Work.sold_between(DateTime.new(2020, 12, 31), DateTime.new(2021, 1, 1, 0))
        expect(works).to eq([])
      end
    end
    describe ".outgoing_rental_between" do
      let(:relevant_timespans) {
        {
          historic: time_spans(:time_span_historic),
          expired: time_spans(:time_span_expired),
          active: time_spans(:time_span_active)
        }
      }
      it "expect period to include current and past lendings if < Time.now" do
        works = Work.outgoing_rental_between(nil, Time.now)
        expect(works).to include(relevant_timespans[:historic].subject)
        expect(works).to include(relevant_timespans[:expired].subject)
        expect(works).to include(relevant_timespans[:active].subject)
      end
      it "expect period to include only active and expired lendings if 1.day.ago < Time.now" do
        works = Work.outgoing_rental_between(1.day.ago, Time.now)
        expect(works).not_to include(relevant_timespans[:historic].subject)
        expect(works).to include(relevant_timespans[:expired].subject)
        expect(works).to include(relevant_timespans[:active].subject)
      end

      it "expect period to include only historic lendings if < active" do
        works = Work.outgoing_rental_between(nil, Date.new(2005, 1, 1))
        expect(works).to include(relevant_timespans[:historic].subject)
        expect(works).not_to include(relevant_timespans[:expired].subject)
        expect(works).not_to include(relevant_timespans[:active].subject)
      end
    end
  end
end
