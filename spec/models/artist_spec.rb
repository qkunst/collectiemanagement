require 'rails_helper'

RSpec.describe Artist, type: :model do
  describe  "#combine_artists_with_ids(artist_ids_to_combine_with)" do
    it "should work" do
      ids = []
      a = Artist.create(first_name: "a")
      wa = Work.create(title: "by a")
      wa.artists << a
      b = Artist.create(first_name: "b")
      ids << b.id

      wb = Work.create(title: "by a")
      wb.artists << b
      wb = Work.create(title: "by a")
      wb.artists << b

      expect(a.combine_artists_with_ids(ids)).to eq(2)
      expect(Artist.where(id: ids).count).to eq(0)
      expect(a.works.count).to eq(3)
    end
  end

  describe "#to_parameters" do
    it "should return basic params" do
      b = Artist.new(first_name: "B", last_name: "A")
      parameters = b.to_parameters
      expect(parameters["first_name"]).to eq("B")
      expect(parameters["last_name"]).to eq("A")
    end

  end

  describe "#name" do
    it "should return a reasonable name string" do
      a = Artist.create(first_name: "Antony", last_name: "Hopkins")
      expect(a.name).to eq("Hopkins, Antony")
      a = Artist.create(first_name: "Antony", last_name: "Hopkins", prefix: "van der")
      expect(a.name).to eq("Hopkins, Antony van der")
    end
    it "should return a reasonable name string with years if given" do
      a = Artist.create(first_name: "Antony", last_name: "Hopkins", year_of_birth: 1900, year_of_death: 2000)
      expect(a.name).to eq("Hopkins, Antony (1900-2000)")
    end
    it "should return a reasonable name string without years if given when include_years == false" do
      a = Artist.create(first_name: "Antony", last_name: "Hopkins", year_of_birth: 1900, year_of_death: 2000)
      expect(a.name(include_years: false)).to eq("Hopkins, Antony")
    end
  end

  describe "#import" do
    it "should import basic params" do
      a = Artist.create(first_name: "A")
      b = Artist.new(first_name: "B", last_name: "A")
      a.import!(b)
      expect(a.first_name).to eq("B")
      expect(a.last_name).to eq("A")
    end
    it "should not import name when middle name is given" do
      a = Artist.create(first_name: "A", prefix: "B", last_name: "C")
      b = Artist.new(first_name: "A", last_name: "B C")
      a.import!(b)
      a.save
      expect(a.first_name).to eq("A")
      expect(a.prefix).to eq("B")
      expect(a.last_name).to eq("C")
    end
    it "should import artist involvements" do
      a = Artist.create(first_name: "A")
      a.artist_involvements.create(place: "Berlijn", involvement_type: :professional)
      a.artist_involvements.create(place: "Parijs", involvement_type: :educational)
      b = Artist.new(first_name: "B", last_name: "A")
      b.artist_involvements.new(place: "Kopenhagen", involvement_type: :professional)

      a.import!(b)
      a.reload
      expect(a.artist_involvements.professional.count).to eq(1)
      expect(a.artist_involvements.professional.first.place).to eq("Kopenhagen")
      expect(a.artist_involvements.educational.first.place).to eq("Parijs")
    end
  end

  describe "Class methods" do
    describe ".empty_artists" do
      it "should list all workless-artists" do
        expect(Artist.empty_artists.count).to eq 1
        expect(Artist.empty_artists.first.id).to eq artists(:artist_no_works).id
      end
    end
    describe ".destroy_all_empty_artists!" do
      it "should destroy all workless-artists" do
        to_destroy_artist_id = artists(:artist_no_works).id
        destroyed_artists = Artist.destroy_all_empty_artists!
        expect(destroyed_artists.count).to eq 1
        expect(destroyed_artists.first.id).to eq to_destroy_artist_id
        expect(Artist.empty_artists.count).to eq 0
      end
      it "should list all workless-artists (check check)" do
        expect(Artist.empty_artists.count).to eq 1
        expect(Artist.empty_artists.first.id).to eq artists(:artist_no_works).id
      end
    end
    describe ".artists_with_no_name_that_have_works_that_already_belong_to_artists_with_a_name" do
      it "should list all workless-artists" do
        expect(Artist.artists_with_no_name_that_have_works_that_already_belong_to_artists_with_a_name.count).to eq 1
        expect(Artist.artists_with_no_name_that_have_works_that_already_belong_to_artists_with_a_name.first.id).to eq artists(:artist_no_name).id
      end
    end
    describe ".collapse_by_name!" do
      it "should colleapse only same creation date by default" do
        before_count = Artist.count
        Artist.collapse_by_name!
        expect(before_count - Artist.count).to eq 1
      end
      it "should colleapse only same creation date by default" do
        before_count = Artist.count
        Artist.collapse_by_name!({only_when_created_at_date_is_equal: false})
        expect(before_count - Artist.count).to eq 2
      end
    end
  end
end
