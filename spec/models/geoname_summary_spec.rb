# frozen_string_literal: true

require "rails_helper"

RSpec.describe GeonameSummary, type: :model do
  describe "Class methods" do
    describe ".search" do
      it "should return an empty array when nil" do
        expect(GeonameSummary.search(nil)).to eq([])
        expect(GeonameSummary.search("")).to eq([])
      end
      it "should return an empty array when not found" do
        expect(GeonameSummary.search("totally weird name that never exists")).to eq([])
      end
    end
  end
end
