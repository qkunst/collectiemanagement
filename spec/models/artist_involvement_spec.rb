require 'rails_helper'

RSpec.describe ArtistInvolvement, type: :model do
  describe  "#to_s" do
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