# frozen_string_literal: true

require "rails_helper"

RSpec.describe Collection, type: :model do
  describe "callbacks" do
    describe "after save" do
      it "touches child works" do
        collection = collections(:collection_with_works)
        w = collection.works.first
        w_originally_updated_at = w.updated_at
        sleep(0.001)
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
        expect(collections(:collection_with_works_child).collection_name_extended).to eq("Collection 1 » Collection with works (sub of Collection 1) » Collection with works child (sub of Collection 1 >> colection with works)")
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

    describe "#main_collection" do
      it "should return self if no main collection exists" do
        expect(collections(:boring_collection).base_collection).to eq(collections(:boring_collection))
        expect(collections(:sub_boring_collection).base_collection).to eq(collections(:sub_boring_collection))
      end

      it "should return the parent collection marked as base when it exists" do
        expect(collections(:collection_with_works_child).base_collection).to eq(collections(:collection_with_works))
        expect(collections(:collection_with_works).base_collection).to eq(collections(:collection_with_works))
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
        expect(Collection.for_user_expanded(users(:super_admin)).all.collect(&:id).sort).to eq(Collection.not_system.all.collect(&:id).sort)
      end

      it "returns collections with root parent for admin user, except for those not qkunst managed" do
        expect(Collection.for_user_expanded(users(:admin)).all.collect(&:id).sort).to eq(Collection.not_system.qkunst_managed.all.collect(&:id).sort)
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
