# == Schema Information
#
# Table name: locations
#
#  id            :bigint           not null, primary key
#  address       :text
#  hide          :boolean
#  lat           :float
#  lon           :float
#  name          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  collection_id :integer
#
require "rails_helper"

RSpec.describe Location, type: :model do
  let(:collection) { collections(:collection1) }
  let(:location) { locations(:location1) }
  describe "#name" do
    it "is required" do
      expect(Location.new(name: nil, collection: collection)).not_to be_valid
    end

    it "is required to have more than white spaces" do
      expect(Location.new(name: "   ", collection: collection)).not_to be_valid
    end

    it "is ok to be a word" do
      expect(Location.new(name: "Success", collection: collection)).to be_valid
    end

    it "splits to address if not persisted" do
      location = Location.new(name: "Depot, Straat 12, Amsterdam")
      expect(location.name).to eq("Depot")
      expect(location.address).to eq("Straat 12\nAmsterdam")
    end

    it "does not split to address if persisted" do
      location.name = "Depot, Straat 12, Amsterdam"
      expect(location.name).to eq("Depot, Straat 12, Amsterdam")
    end
  end
end
