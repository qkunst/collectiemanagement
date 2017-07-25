require 'rails_helper'

RSpec.describe Collection, type: :model do
  describe "methods" do
    describe "#parent_collections_flattened" do
      it "should return the oldest parent, then that child ." do
        collection = collections(:collection4)
        expect(collection.parent_collections_flattened[0]).to eq(collections(:collection1))
        expect(collection.parent_collections_flattened[1]).to eq(collections(:collection2))
        expect(collection.parent_collections_flattened[2]).to eq(nil)
      end
    end
    describe "#child_collections_flattened" do
      it "should return all childs" do
        expect(collections(:collection1).child_collections_flattened.map(&:id).sort).to eq([collections(:collection2),collections(:collection4), collections(:collection_with_works)].map(&:id).sort)
      end
    end
    describe "#fields_to_expose" do
      it "should return almost all fields when fields_to_expose(:default)" do
        collection = collections(:collection4)
        ["location", "location_floor", "location_detail", "stock_number", "alt_number_1", "alt_number_2", "alt_number_3", "information_back", "artists", "artist_unknown", "title", "title_unknown", "description", "object_creation_year", "object_creation_year_unknown", "object_categories", "techniques", "medium", "medium_comments", "signature_comments", "no_signature_present", "print", "frame_height", "frame_width", "frame_depth", "frame_diameter", "height", "width", "depth", "diameter", "condition_work", "damage_types", "condition_work_comments", "condition_frame", "frame_damage_types", "condition_frame_comments", "placeability", "other_comments", "sources", "source_comments", "abstract_or_figurative", "style", "themes", "subset", "purchased_on", "purchase_price", "purchase_price_currency", "price_reference", "grade_within_collection", "public_description", "internal_comments", "imported_at", "id", "created_at", "updated_at", "created_by", "appraisals", "versions", "collection", "external_inventory", "cluster", "version", "artist_name_rendered", "valuation_on", "lognotes", "market_value", "replacement_value"].each do |a|
          expect(collection.fields_to_expose(:default)).to include(a)
        end
      end
    end
  end
  describe "Class methods" do
    describe ".expand_with_child_collections" do
      it "returns child collections" do
        set = Collection.where(name: "Collection 1").expand_with_child_collections
        # expect(set.class).to eq(Collection::ActiveRecord_Relation)
        expect(set.map(&:id).sort).to eq([collections(:collection1),collections(:collection2),collections(:collection4),collections(:collection_with_works)].map(&:id).sort)
      end
      it "returns child collections until depth 1" do
        set = Collection.where(name: "Collection 1").expand_with_child_collections(2)
        # expect(set.class).to eq(Collection::ActiveRecord_Relation)
        expect(set.map(&:id).sort).to eq([collections(:collection1),collections(:collection2),collections(:collection_with_works)].map(&:id).sort)
      end
      it "works with larger start-set that includes child" do
        set = Collection.where(name: ["Collection 1", "Collection 2"]).expand_with_child_collections
        # expect(set.class).to eq(Collection::ActiveRecord_Relation)
        expect(set.map(&:id).sort).to eq([collections(:collection1),collections(:collection2),collections(:collection4),collections(:collection_with_works)].map(&:id).sort)
      end
      it "works with larger start-set that does not  include child" do
        set = Collection.where(name: ["Collection 1", "Collection 3"]).expand_with_child_collections
        # expect(set.class).to eq(Collection::ActiveRecord_Relation)
        expect(set.map(&:id).sort).to eq([collections(:collection1),collections(:collection2),collections(:collection3),collections(:collection4),collections(:collection_with_works)].map(&:id).sort)
      end
    end
  end
  describe "Scopes" do
    describe ".works_including_child_works" do
      it "should return all child works" do
        child_works = collections(:collection3).works_including_child_works
        expect(child_works).to include(works(:work6))
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
