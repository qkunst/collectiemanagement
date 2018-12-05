require 'rails_helper'

RSpec.describe SimpleArtist, type: :model do
  describe  "instance methods" do
    describe "#name" do
      it "should return no name given string by default" do
        expect(SimpleArtist.new().name).to eq "-geen naam opgevoerd (-)-"
      end
      it "should return full name (with years when given)" do
        expect(SimpleArtist.new(first_name: "Jan", last_name: "Sluys", prefix: "van der").name).to eq "Sluys, Jan van der"
        expect(SimpleArtist.new(first_name: "Jan", last_name: "Sluys", prefix: "van der", year_of_birth: 1000, year_of_death: 1200).name).to eq "Sluys, Jan van der (1000 - 1200)"
        expect(SimpleArtist.new(first_name: "Jan", last_name: "Sluys", prefix: "van der", year_of_birth: 1000, year_of_death: 1200, place_of_birth: "Amsterdam", place_of_death: "Rome").name).to eq "Sluys, Jan van der (1000 - 1200)"
      end
      it "can render places as well" do
        expect(SimpleArtist.new(first_name: "Jan", last_name: "Sluys", prefix: "van der", year_of_birth: 1000, year_of_death: 1200, place_of_birth: "Amsterdam", place_of_death: "Rome").name({include_locality: true})).to eq "Sluys, Jan van der (Amsterdam, 1000 - Rome, 1200)"
      end
    end
    describe "#to_json_for_simple_artist" do
      it "should work" do
        expect(SimpleArtist.new(first_name: "Jan", last_name: "Sluys", prefix: "van der").to_json_for_simple_artist).to eq "{\"first_name\":\"Jan\",\"last_name\":\"Sluys\",\"prefix\":\"van der\"}"
      end
    end
  end





end
