# frozen_string_literal: true

require 'rails_helper'


RSpec.describe CollectionOwnable, type: :model do
  describe "scopes" do
    describe ".for_collection_including_generic" do
      it "should include generic themes" do
        expect(Theme.for_collection_including_generic(collections(:collection_with_stages))).to include(themes(:earth))
      end
      it "should include private themes" do
        expect(Theme.for_collection_including_generic(collections(:collection_with_stages))).to include(themes(:wind_private_to_collection_with_stages))
        expect(Theme.for_collection_including_generic(collections(:collection_with_stages_child))).to include(themes(:wind_private_to_collection_with_stages))
      end
    end
    describe ".for_collection" do
      it "should include generic themes" do
        expect(Theme.for_collection(collections(:collection_with_stages))).not_to include(themes(:earth))
      end
      it "should include private themes" do
        expect(Theme.for_collection(collections(:collection_with_stages))).to include(themes(:wind_private_to_collection_with_stages))
        expect(Theme.for_collection(collections(:collection_with_stages_child))).to include(themes(:wind_private_to_collection_with_stages))
      end
    end
  end
  describe "actually Theme that includes CollectionOwnable" do
    it "should validate name" do
      expect { Theme.create!(name: nil) }.to raise_error(ActiveRecord::RecordInvalid)
      expect { Theme.create!(name: "kaas") }.not_to raise_error
      expect { Theme.create!(name: "kaas") }.to raise_error(ActiveRecord::RecordInvalid)
      expect { collections(:collection1).themes.create!(name: "kaas") }.not_to raise_error
      expect { collections(:collection1).themes.create!(name: "kaas") }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
  describe "it should belong to a collection" do
    it "well, neot necesarily" do
      theme = Theme.create!(name: "kaas")
      expect(theme.collection).to eq(nil)
    end
    it "typical roundtrip" do
      theme = collections(:collection1).themes.create!(name: "kaas")
      expect(theme.collection).to eq(collections(:collection1))
    end
  end
end
