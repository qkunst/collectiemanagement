# frozen_string_literal: true

# == Schema Information
#
# Table name: artist_involvements
#
#  id               :integer          not null, primary key
#  involvement_id   :integer
#  artist_id        :integer
#  start_year       :integer
#  end_year         :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  involvement_type :string
#  place            :string
#  place_geoname_id :integer
#

require "rails_helper"

RSpec.describe ArtistInvolvement, type: :model do
  describe "#copy_place_geoname_id_from_involvement_when_nil" do
    it "should work copy geoname from involvement" do
      i = involvements(:involvement1)
      a = artists(:artist1)
      ai = ArtistInvolvement.new(involvement: i, artist: a, involvement_type: :professional)
      ai.save
      expect(ai.geoname_summary.geoname_id).to eq(123)
    end
  end
  describe "#to_s" do
    it "should include name" do
      a = Involvement.new(name: "Naam Involvment")
      expect(ArtistInvolvement.new(involvement: a).to_s).to eq("Naam Involvment")
    end
    it "should include name and year" do
      a = Involvement.new(name: "Naam Involvment")
      expect(ArtistInvolvement.new(involvement: a, start_year: 2000, end_year: 2010).to_s).to eq("Naam Involvment (2000-2010)")
    end
    it "should include name, geoname and year" do
      i = Involvement.new(name: "Naam Involvment")
      g = GeonameSummary.new(name: "SpacePlace")
      expect(ArtistInvolvement.new(involvement: i, start_year: 2000, end_year: 2010, geoname_summary: g).to_s).to eq("Naam Involvment (SpacePlace, 2000-2010)")
    end
    describe "option={format:short}" do
      it "should include name" do
        a = Involvement.new(name: "Naam Involvment")
        expect(ArtistInvolvement.new(involvement: a).to_s(format: :short)).to eq("Naam Involvment")
      end
      it "should include name and year" do
        a = Involvement.new(name: "Naam Involvment")
        expect(ArtistInvolvement.new(involvement: a, start_year: 2000, end_year: 2010).to_s(format: :short)).to eq("Naam Involvment (2000-2010)")
      end
      it "should include name, geoname and year" do
        i = Involvement.new(name: "Naam Involvment")
        g = GeonameSummary.new(name: "SpacePlace")
        expect(ArtistInvolvement.new(involvement: i, start_year: 2000, end_year: 2010, geoname_summary: g).to_s(format: :short)).to eq("Naam Involvment (2000-2010)")
      end
      it "should include geoname when no name" do
        g = GeonameSummary.new(name: "SpacePlace")
        expect(ArtistInvolvement.new(start_year: 2000, end_year: 2010, geoname_summary: g).to_s(format: :short)).to eq("SpacePlace (2000-2010)")
      end
    end
  end
end
