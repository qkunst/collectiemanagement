require 'rails_helper'


RSpec.describe CollectionOwnable, type: :model do
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
