# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Collection::Hierarchy, type: :model do
  describe "callbacks" do

  end
  describe "methods" do
    describe "#child_collections_flattened" do
      it "should return all childs" do
        expect(collections(:collection1).child_collections_flattened.map(&:id).sort).to eq([collections(:collection2),collections(:collection4), collections(:collection_with_works),collections(:collection_with_works_child)].map(&:id).sort)
      end
    end

    describe "#expand_with_child_collections" do
      it "should return all collections when expanded from root" do
        expect(collections(:root_collection).expand_with_child_collections.count).to eq(Collection.all.count)
      end
      it "should return empty array when no id" do
        expect(Collection.new.expand_with_child_collections).to eq([])
      end
      it "should return subset for collection1" do
        collections = collections(:collection1).expand_with_child_collections.all
        expect(collections).to include(collections(:collection1))
        expect(collections).to include(collections(:collection_with_works))
        expect(collections).to include(collections(:collection_with_works_child))

        expect(collections).not_to include(collections(:collection3))
      end
    end

    describe "#expand_with_parent_collections" do
      it "should return only the root when expanded from root" do
        expect(collections(:root_collection).expand_with_parent_collections).to eq([Collection.root_collection])
      end
      it "should return all parents" do
        expect(collections(:collection_with_works_child).expand_with_parent_collections).to match_array([Collection.root_collection, collections(:collection_with_works_child), collections(:collection_with_works), collections(:collection1)])
      end
    end

    describe "#self_and_parent_collections_flattened" do
      it "should return sorted from parent to child" do
        expect(collections(:collection_with_works_child).self_and_parent_collections_flattened.map(&:id)).to eq([:collection1, :collection_with_works, :collection_with_works_child].map{|c| collections(c).id})
      end
    end

    describe "#parent_collections_flattened" do
      it "should return sorted from parent to child" do
        expect(collections(:collection_with_works_child).parent_collections_flattened.map(&:id)).to eq([:collection1, :collection_with_works].map{|c| collections(c).id})
      end
    end

    describe "#parent_collections_flattened" do
      it "should return the oldest parent, then that child ." do
        collection = collections(:collection4)
        expect(collection.parent_collections_flattened[0]).to eq(collections(:collection1))
        expect(collection.parent_collections_flattened[1]).to eq(collections(:collection2))
        expect(collection.parent_collections_flattened[2]).to eq(nil)
      end
    end

    describe "#possible_parent_collections" do
      it "should return all collections if new" do
        expect(Collection.new.possible_parent_collections(user: users(:admin)).count).to eq(Collection.all.count)
      end

      it "should not return child collections" do
        expect(collections(:collection_with_works).possible_parent_collections(user: users(:admin)).map(&:id)).not_to include(collections(:collection_with_works_child).id)
        expect(collections(:collection_with_works).possible_parent_collections(user: users(:admin)).map(&:id)).not_to include(collections(:collection_with_works).id)
        expect(collections(:collection_with_works).possible_parent_collections(user: users(:admin)).map(&:id)).to include(collections(:collection1).id)
        expect(collections(:collection_with_works).possible_parent_collections(user: users(:admin)).map(&:id)).to include(collections(:collection2).id)
      end

    end

  end
  describe "Class methods" do
    describe ".expand_with_child_collections" do
      it "returns child collections" do
        set = collections(:collection1).expand_with_child_collections
        # expect(set.class).to eq(Collection::ActiveRecord_Relation)
        expect(set.map(&:id).sort).to eq([collections(:collection1),collections(:collection2),collections(:collection4),collections(:collection_with_works),collections(:collection_with_works_child)].map(&:id).sort)
      end
      it "returns child collections until depth 1" do
        set = Collection.where(name: "Collection 1").expand_with_child_collections(2)
        # expect(set.class).to eq(Collection::ActiveRecord_Relation)
        expect(set.map(&:id).sort).to eq([collections(:collection1),collections(:collection2),collections(:collection_with_works)].map(&:id).sort)
      end
      it "works with larger start-set that includes child" do
        set = Collection.where(name: ["Collection 1", "Collection 2"]).expand_with_child_collections
        # expect(set.class).to eq(Collection::ActiveRecord_Relation)
        expect(set.map(&:id).sort).to eq([collections(:collection1),collections(:collection2),collections(:collection4),collections(:collection_with_works),collections(:collection_with_works_child)].map(&:id).sort)
      end
      it "works with larger start-set that does not  include child" do
        set = Collection.where(name: ["Collection 1", "Collection 3"]).expand_with_child_collections
        # expect(set.class).to eq(Collection::ActiveRecord_Relation)
        expect(set.map(&:id).sort).to eq([collections(:collection1),collections(:collection2),collections(:collection3),collections(:collection4),collections(:collection_with_works),collections(:collection_with_works_child)].map(&:id).sort)
      end
    end
  end
end
