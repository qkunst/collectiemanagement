# == Schema Information
#
# Table name: locations
#
#  id                    :integer          not null, primary key
#  name                  :string
#  address               :text
#  lat                   :float
#  lon                   :float
#  collection_id         :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  hide                  :boolean
#  building_number       :string
#  other_structured_data :text
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
