# frozen_string_literal: true

# == Schema Information
#
# Table name: collections
#
#  id                                        :bigint           not null, primary key
#  api_setting_expose_only_published_works   :boolean
#  appraise_with_ranges                      :boolean          default(FALSE)
#  base                                      :boolean
#  collection_name_extended_cache            :text
#  commercial                                :boolean
#  default_collection_attributes_for_artists :text             default(["\"website\"", "\"email\"", "\"telephone_number\"", "\"description\""]), is an Array
#  default_collection_attributes_for_works   :text             default([]), is an Array
#  derived_work_attributes_present_cache     :text
#  description                               :text
#  exposable_fields                          :text
#  external_reference_code                   :string
#  geoname_ids_cache                         :text
#  internal_comments                         :text
#  label_override_work_alt_number_1          :string
#  label_override_work_alt_number_2          :string
#  label_override_work_alt_number_3          :string
#  name                                      :string
#  pdf_title_export_variants_text            :text
#  qkunst_managed                            :boolean          default(TRUE)
#  root                                      :boolean          default(FALSE)
#  show_availability_status                  :boolean
#  show_library                              :boolean
#  sort_works_by                             :string
#  supported_languages                       :text             default(["\"nl\""]), is an Array
#  unique_short_code                         :string
#  work_attributes_present_cache             :text
#  created_at                                :datetime         not null
#  updated_at                                :datetime         not null
#  parent_collection_id                      :bigint           default(1)
#
# Indexes
#
#  index_collections_on_unique_short_code  (unique_short_code) UNIQUE
#
require "rails_helper"

RSpec.describe Collection, type: :model do
  describe "callbacks" do
    describe "after save" do
      it "doesn't touch child works if nothing has changed" do
        collection = collections(:collection_with_works)
        w = collection.works.first
        w_originally_updated_at = w.updated_at
        sleep(0.001)
        collection.save
        w.reload
        expect(w.updated_at).to eq(w_originally_updated_at)
      end

      it "touches child works when name has changed" do
        collection = collections(:collection_with_works)
        w = collection.works.first
        w_originally_updated_at = w.updated_at
        sleep(0.001)
        collection.name = "test"
        collection.save
        w.reload
        expect(w.updated_at).to be > w_originally_updated_at
      end

      it "doesn't change collection_locality_artist_involvements_texts_cache" do
        collection = collections(:collection_with_works)
        w = collection.works.first
        w.update_column(:collection_locality_artist_involvements_texts_cache, "['abc']")
        collection.save
        w.reload
        expect(w.collection_locality_artist_involvements_texts_cache).to eq("['abc']")
      end

      it "does change collection_locality_artist_involvements_texts_cache when locality has been updated" do
        collection = collections(:collection_with_works)
        w = collection.works.first
        w.update_column(:collection_locality_artist_involvements_texts_cache, "['abc']")

        collection.collections_geoname_summaries = [CollectionsGeonameSummary.new(geoname_summary: geoname_summaries(:geoname_summary1))]
        collection.save
        w.reload
        expect(w.collection_locality_artist_involvements_texts_cache).not_to eq("['abc']")
      end
    end

    describe "before save" do
      before(:each) do
        collections(:sub_boring_collection).themes.create(name: "boring theme")
        collections(:boring_collection).themes.create(name: "boring theme")
        collections(:sub_boring_collection).clusters.create(name: "boring unique cluster")
        collections(:boring_collection).clusters.create(name: "boring unique cluster")

        [:sub_boring_collection, :boring_collection].each do |cname|
          collection = collections(cname)
          5.times do |counter|
            work = collection.works.create(title: "Work #{counter}")
            work.themes = collection.themes
            work.cluster = collection.clusters.first
            work.save
          end
        end
      end
      it "#attach_sub_collection_ownables_when_base" do
        expect(collections(:sub_boring_collection).themes.count).to eq(1)
        expect(collections(:sub_boring_collection).clusters.count).to eq(1)
        expect(collections(:sub_boring_collection).attachments.count).to eq(1)
        expect(collections(:sub_boring_collection).collection_attributes.count).to eq(1)

        # fix as fixture doesn't link to an actual file
        attachment = collections(:sub_boring_collection).attachments.first
        attachment.file = File.open("Gemfile")
        attachment.save

        expect(collections(:boring_collection).themes.count).to eq(1)
        expect(collections(:boring_collection).clusters.count).to eq(1)
        expect(collections(:boring_collection).collection_attributes.count).to eq(0)

        expect(collections(:sub_boring_collection).themes.first.works.count).to eq(5)
        expect(collections(:sub_boring_collection).clusters.first.works.count).to eq(5)

        boring_collection_theme = collections(:boring_collection).themes.first
        boring_collection_cluster = collections(:boring_collection).clusters.first

        expect(boring_collection_theme.works.count).to eq(5)
        expect(boring_collection_cluster.works.count).to eq(5)

        c = collections(:boring_collection)
        c.base = true
        c.save
        expect(collections(:sub_boring_collection).themes.count).to eq(0)
        expect(collections(:sub_boring_collection).clusters.count).to eq(0)
        expect(collections(:sub_boring_collection).attachments.count).to eq(0)
        expect(collections(:sub_boring_collection).collection_attributes.count).to eq(0)

        expect(collections(:boring_collection).themes.count).to eq(2)
        expect(collections(:boring_collection).themes.not_hidden.count).to eq(1)
        expect(collections(:boring_collection).clusters.count).to eq(1)
        expect(collections(:boring_collection).attachments.count).to eq(1)
        expect(collections(:boring_collection).collection_attributes.count).to eq(1)

        boring_collection_theme.reload
        boring_collection_cluster.reload

        expect(collections(:boring_collection).works_including_child_works.count).to eq(10)

        expect(boring_collection_theme.works.count).to eq(10)
        expect(boring_collection_cluster.works.count).to eq(10)
      end
    end
  end
  describe "validations" do
    let(:collection) { collections(:boring_collection) }
    describe "validates validity of pdf_title_export_variants_text" do
      it "is valid by default" do
        expect(collection.valid?).to be_truthy
      end

      it "is valid when nil or empty" do
        collection.update(pdf_title_export_variants_text: nil)
        expect(collection.valid?).to be_truthy

        collection.update(pdf_title_export_variants_text: "")
        expect(collection.valid?).to be_truthy
      end

      it "is valid with valid contents" do
        collection.update(pdf_title_export_variants_text: "default:\n  show_logo: false")
        expect(collection.valid?).to be_truthy
      end

      it "is invalid with invalid contents" do
        collection.update(pdf_title_export_variants_text: "default:\n  show_logo :\aa false")
        expect(collection.valid?).to be_falsey
      end
    end
  end
  describe "methods" do
    describe "#appraise_with_ranges?" do
      it "should return false by default" do
        expect(collections(:collection_with_stages_child).appraise_with_ranges?).to eq(false)
      end
      it "should return true when self true" do
        expect(collections(:collection1).appraise_with_ranges?).to eq(true)
      end
      it "should return true when parent true" do
        expect(collections(:collection_with_works).appraise_with_ranges?).to eq(true)
      end
    end
    describe "#available_clusters" do
      it "should list all private clusters" do
        expect(collections(:collection_with_works).available_clusters).to include(clusters(:cluster1))
        expect(collections(:collection_with_works).available_clusters).to include(clusters(:cluster2))
        expect(collections(:collection1).available_clusters).to include(clusters(:cluster1))
        expect(collections(:collection1).available_clusters).to include(clusters(:cluster2))
      end
      it "should list not list private clusters" do
        expect(collections(:collection_with_stages).available_clusters).not_to include(clusters(:cluster1))
        expect(collections(:collection_with_stages).available_clusters).not_to include(clusters(:cluster2))
      end
    end

    describe "#available_themes" do
      it "should include all generic themes" do
        col_1_available_themes = collections(:collection1).available_themes
        expect(col_1_available_themes).to include(themes(:earth))
      end
      it "should not include hidden generic themes" do
        col_1_available_themes = collections(:collection1).available_themes
        expect(col_1_available_themes).not_to include(themes(:old))
      end
      it "should not include themes that belong to another collection" do
        col_1_available_themes = collections(:collection1).available_themes
        expect(col_1_available_themes).not_to include(themes(:wind_private_to_collection_with_stages))
      end
      it "should include collection specific themes if any" do
        col_with_stages_available_themes = collections(:collection_with_stages).available_themes
        expect(col_with_stages_available_themes).not_to include(themes(:old))
        expect(col_with_stages_available_themes).to include(themes(:wind_private_to_collection_with_stages))
        expect(col_with_stages_available_themes).to include(themes(:earth))
        expect(col_with_stages_available_themes).to include(themes(:wind))
      end
    end

    describe "#can_be_accessed_by_user" do
      it "collection_with_works not to be accessed by collection_with_works_child_user" do
        user = users(:collection_with_works_child_user)
        collection = collections(:collection_with_works)

        expect(collection.can_be_accessed_by_user?(user)).to eq(false)
      end
      it "collection_with_works not to be accessed by collection_with_works_user" do
        user = users(:collection_with_works_user)
        collection = collections(:collection_with_works)

        expect(collection.can_be_accessed_by_user?(user)).to eq(true)
      end
      it "admin can see collection_with_works" do
        user = users(:admin)
        collection = collections(:collection_with_works)
        expect(collection.can_be_accessed_by_user?(user)).to eq(true)
      end
      it "admin can not see  not_qkunst_managed_collection" do
        user = users(:admin)
        collection = collections(:not_qkunst_managed_collection)
        expect(collection.can_be_accessed_by_user?(user)).to eq(false)
      end
      it "super admin can see  not_qkunst_managed_collection" do
        user = users(:super_admin)
        collection = collections(:not_qkunst_managed_collection)

        expect(collection.can_be_accessed_by_user?(user)).to eq(true)
      end
    end

    describe "#collection_name_extended" do
      it "should have a logical order of parents" do
        expect(collections(:collection_with_works_child).collection_name_extended).to eq("Collection 1 » Collection with works (sub of Collection 1) » Collection with works child (sub of Collection 1 » colection with works)")
      end
    end

    describe "#fields_to_expose" do
      it "should return almost all fields when fields_to_expose(:default)" do
        collection = collections(:collection4)
        fields = collection.fields_to_expose(:default)

        expect(fields).to include("location", "location_floor", "location_detail", "stock_number", "alt_number_1", "alt_number_2", "alt_number_3", "information_back", "artists", "artist_unknown", "title", "title_unknown", "description", "object_creation_year", "object_creation_year_unknown", "object_categories", "techniques", "medium", "medium_comments", "signature_comments", "no_signature_present", "print", "frame_height", "frame_width", "frame_depth", "frame_diameter", "height", "width", "depth", "diameter", "condition_work", "damage_types", "condition_work_comments", "condition_frame", "frame_damage_types", "condition_frame_comments", "placeability", "other_comments", "sources", "source_comments", "abstract_or_figurative", "style", "themes", "subset", "purchased_on", "purchase_price", "purchase_price_currency", "price_reference", "grade_within_collection", "public_description", "internal_comments", "imported_at", "id", "created_at", "updated_at", "created_by", "appraisals", "collection", "external_inventory", "cluster", "artist_name_rendered", "valuation_on", "lognotes", "market_value", "replacement_value", "cached_tag_list")
      end

      it "should return no condition, appraisal and location fields when public" do
        collection = collections(:collection4)
        fields = collection.fields_to_expose(:public)

        expect(fields).to include("public_description", "title", "artists")

        expect(fields).not_to include("market_value", "location_floor", "replacement_value", "damage_types")
      end
    end

    describe "#base_collection" do
      it "should return self if no main collection exists" do
        expect(collections(:boring_collection).base_collection).to eq(collections(:boring_collection))
        expect(collections(:sub_boring_collection).base_collection).to eq(collections(:sub_boring_collection))
      end

      it "should return the parent collection marked as base when it exists" do
        expect(collections(:collection_with_works_child).base_collection).to eq(collections(:collection_with_works))
        expect(collections(:collection_with_works).base_collection).to eq(collections(:collection_with_works))
      end

      it "should return the first parent collection marked as base when it exists" do
        collections(:collection1).update(base: true)
        expect(collections(:collection_with_works_child).base_collection).to eq(collections(:collection_with_works))
        expect(collections(:collection_with_works).base_collection).to eq(collections(:collection_with_works))
      end
    end

    describe "#base_collections" do
      it "should return an empty array if no main collection exists" do
        expect(collections(:boring_collection).base_collections).to eq([])
        expect(collections(:sub_boring_collection).base_collections).to eq([])
      end

      it "should return the parent collection marked as base when it exists" do
        expect(collections(:collection_with_works_child).base_collections).to eq([collections(:collection_with_works)])
        expect(collections(:collection_with_works).base_collections).to eq([collections(:collection_with_works)])
      end

      it "should return the first parent collection marked as base when it exists" do
        collections(:collection1).update(base: true)
        expect(collections(:collection_with_works_child).base_collections).to eq([collections(:collection1), collections(:collection_with_works)])
        expect(collections(:collection_with_works).base_collections).to eq([collections(:collection1), collections(:collection_with_works)])
      end
    end

    describe "#pdf_title_export_variants" do
      let(:collection) { collections(:boring_collection) }
      it "has a default variant" do
        expect(collection.pdf_title_export_variants[:default]).to eq({
          show_logo: true,
          resource_variant: "public",
          foreground_color: "000000"
        })
      end

      it "s default can be overwritten" do
        collection.update(pdf_title_export_variants_text: "default:\n  show_logo: false\n  foreground_color: \"ffff00\"")
        expect(collection.pdf_title_export_variants[:default]).to eq({
          show_logo: false,
          resource_variant: "public",
          foreground_color: "ffff00"
        })
      end

      it "can contain other settings" do
        collection.update(pdf_title_export_variants_text: "Een bijzondere klantwens:\n  show_logo: false\n  foreground_color: \"ffff00\"")
        expect(collection.pdf_title_export_variants[:default]).to eq({
          show_logo: true,
          resource_variant: "public",
          foreground_color: "000000"
        })
        expect(collection.pdf_title_export_variants[:"Een bijzondere klantwens"]).to eq({
          show_logo: false,
          resource_variant: "public",
          foreground_color: "ffff00"
        })
      end
    end

    describe "#super_base_collection" do
      it "should return self if no main collection exists" do
        expect(collections(:boring_collection).super_base_collection).to eq(collections(:boring_collection))
        expect(collections(:sub_boring_collection).super_base_collection).to eq(collections(:sub_boring_collection))
      end

      it "should return the parent collection marked as base when it exists" do
        expect(collections(:collection_with_works_child).super_base_collection).to eq(collections(:collection_with_works))
        expect(collections(:collection_with_works).super_base_collection).to eq(collections(:collection_with_works))
      end

      it "should return the first parent collection marked as base when it exists" do
        collections(:collection1).update(base: true)
        expect(collections(:collection_with_works_child).super_base_collection).to eq(collections(:collection1))
        expect(collections(:collection_with_works).super_base_collection).to eq(collections(:collection1))
      end
    end

    describe "#search_works" do
      it "should return works for this collection" do
        expect(collections(:collection1).search_works.pluck(:id)).to include(works(:work1).id)
      end
      it "should not return works outside this collection when skipping elastic search" do
        works(:work_diptych_1).reindex!

        sleep(1)

        expect(Work).not_to receive(:search)

        expect(collections(:collection3).search_works("", {}, {return_records: true}).pluck(:id)).to include(works(:work_diptych_1).id)
        expect(collections(:collection1).search_works("", {}, {return_records: true}).pluck(:id)).not_to include(works(:work_diptych_1).id)
      end
      it "uses elastic search when searching for text" do
        expect(Work).to receive(:search)

        collections(:collection3).search_works("Diptych", {}, {return_records: false})
      end

      it "should not return works outside this collection when involving elastic search", requires_elasticsearch: true do
        works(:work_diptych_1).reindex!

        sleep(1)

        expect(collections(:collection3).search_works("Diptych", {}, {return_records: true}).pluck(:id)).to include(works(:work_diptych_1).id)
        expect(collections(:collection1).search_works("Diptych", {}, {return_records: true}).pluck(:id)).not_to include(works(:work_diptych_1).id)
      end
    end

    describe "#sort_works_by" do
      it "should not accept noise" do
        c = collections(:collection1)
        c.sort_works_by = "asdf"
        expect(c.sort_works_by).to eq nil
      end
      it "should not valid value" do
        c = collections(:collection1)
        c.sort_works_by = "created_at"
        expect(c.sort_works_by).to eq :created_at
      end
    end

    describe "#show_availability_status" do
      {collection1: false, sub_collection_with_inherited_availability: true, collection_with_availability: true}.each do |k, v|
        it "returns false for #{k}" do
          expect(collections(k).show_availability_status).to eq(v)
        end
      end
    end

    describe "#unique_short_code_from_self_or_base" do
      let(:child_col) { collections(:collection_with_works_child) }

      it "will return its own short code" do
        short_code = "af3913412"
        child_col.update(unique_short_code: "af3913412")
        expect(child_col.unique_short_code_from_self_or_base).to eq(short_code)
      end

      it "will return base collection short code if none set" do
        expect(child_col.unique_short_code_from_self_or_base).to eq("col_with_works")
      end
    end

    describe "#works_including_child_works" do
      it "should return all child works" do
        child_works = collections(:collection3).works_including_child_works
        expect(child_works).to include(works(:work6))
      end
      it "should return child collections' works" do
        child_works = collections(:collection1).works_including_child_works
        expect(child_works).not_to include(works(:work6))
        expect(child_works).to include(works(:work1))
      end
    end

    describe "#work_attributes_present" do
      let(:collection) { collections(:collection3).tap(&:save).tap(&:save) }
      let(:found_attributes) { collection.work_attributes_present }
      it "should return all the attributes used" do
        expect(found_attributes).to include(:location)
        expect(found_attributes).not_to include(:no_signature_present)
      end

      it "s cached equivalent should also return symbols" do
        expect(found_attributes).to eq(collection.cached_work_attributes_present)
      end
    end

    describe "#derived_work_attributes_present" do
      let(:collection) { collections(:collection3).tap(&:save).tap(&:save) }
      let(:found_attributes) { collection.derived_work_attributes_present }
      it "should return derived attributes used" do
        expect(found_attributes).to include :cluster
        expect(found_attributes).not_to include :alt_number_6
        expect(found_attributes).to include :balance_category
      end

      it "s cached equivalent should also return symbols" do
        expect(found_attributes).to eq(collection.cached_derived_work_attributes_present)
      end
    end

    describe "#displayable_work_attributes_present" do
      let(:collection) { collections(:collection3).tap(&:save).tap(&:save) }
      let(:found_attributes) { collection.displayable_work_attributes_present }

      it "returns only work attributes that are presented and available" do
        expect(found_attributes).to include :cluster
        expect(found_attributes).not_to include :cluster_id
        expect(found_attributes).to include :balance_category
        expect(found_attributes).to include :location
      end
    end
  end
  describe "Class methods" do
    describe ".for_user" do
      it "returns collections with root parent for super admin user" do
        expect(Collection.for_user(users(:super_admin)).all.collect(&:id).sort).to eq(Collection.root_collection.collections.all.collect(&:id).sort)
      end

      it "returns collections with root parent for admin user, except for those not qkunst managed" do
        expect(Collection.for_user(users(:admin)).all.collect(&:id).sort).to eq(Collection.root_collection.collections.qkunst_managed.all.collect(&:id).sort)
      end

      it "returns only base collection for user" do
        expect(Collection.for_user(users(:facility_manager))).to eq([collections(:collection1)])
      end
    end

    describe ".for_user_expanded" do
      it "returns collections with root parent for super admin user" do
        expect(Collection.for_user_expanded(users(:super_admin)).all.collect(&:id).sort).to eq((Collection.not_system.all.collect(&:id) - [collections(:proto_collection).id]).sort)
      end

      it "returns collections with root parent for admin user, except for those not qkunst managed" do
        expect(Collection.for_user_expanded(users(:admin)).all.collect(&:id).sort).to eq((Collection.not_system.qkunst_managed.all.collect(&:id) - [collections(:proto_collection).id]).sort)
      end

      it "returns only base collection for user" do
        expect(Collection.for_user_expanded(users(:facility_manager)).all.collect(&:id).sort).to eq(collections(:collection1).expand_with_child_collections.all.collect(&:id).sort)
      end
    end
  end
  describe "Scopes" do
    describe "default scope" do
      it "orders by collection_name_extended_cache" do
        Collection.all.each { |c| c.cache_collection_name_extended!(true) }

        collections = Collection.where(id: collections(:collection1).expand_with_child_collections.pluck(:id))
        expect(collections.map(&:collection_name_extended_cache)).to eq([
          "\"Collection 1\"",
          "\"Collection 1 » Collection 2 (sub of Collection 1)\"",
          "\"Collection 1 » Collection 2 (sub of Collection 1) » Collection 4\"",
          "\"Collection 1 » Collection with works (sub of Collection 1)\"",
          "\"Collection 1 » Collection with works (sub of Collection 1) » Collection with works child (sub of Collection 1 » colection with works)\""
        ])
      end
    end
    describe ".artist" do
      it "should return all works by certain artist" do
        artist_works = Work.artist(artists(:artist1))
        artists(:artist1).works.each do |work|
          expect(artist_works).to include(work)
        end
      end
      it "should return all works by certain artist, but not expand scope" do
        artist_works = collections(:collection3).works_including_child_works.artist(artists(:artist4))
        artist_works.each do |work|
          expect(work.artists).to include(artists(:artist4))
        end
        artist_works.each do |work|
          expect(work.collection).to eq(collections(:collection3))
        end
      end
    end
  end
end
