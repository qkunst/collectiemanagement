require 'rails_helper'

RSpec.describe Validators::CollectionScopeValidator, type: :model do
  describe "validates properly" do
    let(:work) { works(:work1) }
    it "works with theme in own collection" do
      work.themes << themes(:collection_with_works_theme)
      expect(work.valid?).to eq(true)
    end
    it "works with theme in super collection" do
      work.themes << themes(:collection1_theme)
      expect(work.valid?).to eq(true)
    end
    it "works with theme in hidden super collection" do
      work.themes << themes(:hidden_collection1_theme)
      expect(work.valid?).to eq(true)
    end
    it "should fail on theme in other collection" do
      work.themes << themes(:star)
      expect(work.valid?).to eq(false)
      expect(work.errors[:base].first).to match /Theme.*niet beschikbaar in collectie/
    end

  end
end