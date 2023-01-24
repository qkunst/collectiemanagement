# == Schema Information
#
# Table name: ids_hashes
#
#  id             :bigint           not null, primary key
#  hashed         :string           not null
#  ids_compressed :text             not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_ids_hashes_on_hashed  (hashed) UNIQUE
#
require 'rails_helper'

RSpec.describe IdsHash, type: :model do
  describe ".store" do
    it "creates or retrieves" do
      store = IdsHash.store([12,13,14])
      expect(store).to be_a(IdsHash)
      store_same = IdsHash.store([12,13,14])
      expect(store_same).to be_a(IdsHash)
      expect(store).to be_persisted
      expect(store.id).to eq(store_same.id)
    end
  end
  describe ".init" do
    it "creates a hash" do
      store = IdsHash.init([12,13,14])
      expect(store.hashed).to eq("023b1e12402d04a743223f5d4da2e7e5dac733df4ed9854354a9afeadc808bce")
      store = IdsHash.init([12,13,16])
      expect(store.hashed).to eq("8ab05ec15dcd0c58a952faaf1bf42271aa5d2d9729c0d62e06b76b4700d4fe40")
      store = IdsHash.init([14,13,12])
      expect(store.hashed).to eq("023b1e12402d04a743223f5d4da2e7e5dac733df4ed9854354a9afeadc808bce")
    end
  end

  describe ".to_ranges" do
    it "returns ranges" do
      expect(IdsHash.to_ranges([12,13,14])).to eq([12..14])
      expect(IdsHash.to_ranges([18,12,5,17,13,16,14])).to eq([5, 12..14, 16..18])
    end
  end

  describe "#ids" do
    it "returns ranges" do
      store = IdsHash.init([12,13,14])
      expect(store.ids).to eq([12..14])
    end

    it "returns ranges complex" do
      store = IdsHash.init([12,5,13,14])
      expect(store.ids).to eq([5, 12..14])
    end
  end


end
