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
  end
  describe "Class methods" do
  end
  describe "Scopes" do
  end
end
