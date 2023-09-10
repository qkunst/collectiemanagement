# frozen_string_literal: true

# == Schema Information
#
# Table name: artists
#
#  id                        :bigint           not null, primary key
#  artist_name               :string
#  date_of_birth             :date
#  date_of_death             :date
#  description               :text
#  first_name                :string
#  gender                    :string
#  geoname_ids_cache         :text
#  last_name                 :string
#  old_data                  :text
#  other_structured_data     :text
#  place_of_birth            :string
#  place_of_birth_lat        :float
#  place_of_birth_lon        :float
#  place_of_death            :string
#  place_of_death_lat        :float
#  place_of_death_lon        :float
#  prefix                    :string
#  year_of_birth             :integer
#  year_of_death             :integer
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  import_collection_id      :bigint
#  place_of_birth_geoname_id :bigint
#  place_of_death_geoname_id :bigint
#  replaced_by_artist_id     :bigint
#  rkd_artist_id             :bigint
#
require "rails_helper"

RSpec.describe Artist, type: :model do
  describe "#collection_attributes_attributes=" do
    it "should create collection attributes" do
      a = artists(:artist1)
      c = collections(:collection1)

      a.update(collection_attributes_attributes: {"0" => {label: "Label for artist spec", value: "Value", collection_id: c.id.to_s}})

      expect(a.collection_attributes.for_collection(c).map(&:label)).to include("Label for artist spec")
    end
    it "should destroy collection attributes when emptied" do
      a = artists(:artist1)
      c = collections(:collection1)

      a.update(collection_attributes_attributes: {"0" => {label: "Label for artist spec", value: "Value", collection_id: c.id.to_s}})
      a.update(collection_attributes_attributes: {"0" => {label: "Label for artist spec", value: "", collection_id: c.id.to_s}})

      expect(a.collection_attributes.for_collection(c).map(&:label)).not_to include("Label for artist spec")
    end
  end
  describe "#combine_artists_with_ids(artist_ids_to_combine_with)" do
    it "should work", skip_ci: true do
      Sidekiq::Worker.clear_all

      ids = []
      c = collections(:collection1)
      a = Artist.create(first_name: "a")
      wa = c.works.create(title: "by a")
      wa.artists << a
      b = Artist.create(first_name: "b")

      ids << b.id

      wb = c.works.create(title: "by a")
      wb.artists << b
      wb = c.works.create(title: "by a")
      wb.artists << b

      expect do
        expect(a.combine_artists_with_ids(ids)).to eq(2)
        expect(Artist.where(id: ids).count).to eq(0)
        expect(a.works.count).to eq(3)
      end.to change(UpdateWorkCachesWorker.jobs, :size).by(3)

      Sidekiq::Worker.drain_all

      expect(wb.reload.artist_name_rendered).to eq("a")
    end
    it "should move the collection specific atributes over" do
      artist1 = artists(:artist2)
      artist2 = artists(:artist2_dup1)
      collection = collections(:collection1)

      expect(artist1.collection_attributes.count).to eq(0)

      expect {
        artist2.update(collection_attributes_attributes: {"0" => {label: "Label for artist spec", value: "Value", collection_id: collection.id.to_s}})
        artist1.combine_artists_with_ids([artist2.id])
      }.to change(artist1.collection_attributes, :count).by(1)
    end
  end
  describe "#import" do
    it "should import from another artist" do
      b = Artist.create(first_name: "B", last_name: "A")
      b_newer = Artist.new(first_name: "Bernard", last_name: "A", year_of_birth: 1973)
      b.import!(b_newer)
      b.reload
      expect(b.first_name).to eq("Bernard")
      expect(b.last_name).to eq("A")
      expect(b.year_of_birth).to eq(1973)
    end
    it "should not overwrite name when prefix is present" do
      # rationale: when prefix is given, the name has probably gotten some attention already
      b = Artist.create(first_name: "B", prefix: "van", last_name: "A")
      b_newer = Artist.new(first_name: "Bernard", last_name: "A", year_of_birth: 1973)
      b.import!(b_newer)
      b.reload
      expect(b.first_name).to eq("B")
      expect(b.prefix).to eq("van")
      expect(b.last_name).to eq("A")
      expect(b.year_of_birth).to eq(1973)
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
      expect(a.name).to eq("Hopkins, Antony (1900 - 2000)")
    end
    it "should return a reasonable name string without years if given when include_years == false" do
      a = Artist.create(first_name: "Antony", last_name: "Hopkins", year_of_birth: 1900, year_of_death: 2000)
      expect(a.name(include_years: false)).to eq("Hopkins, Antony")
    end
    it "should render artist name, when present" do
      a = Artist.create(artist_name: "Antony", year_of_birth: 1900, year_of_death: 2000)
      expect(a.name).to eq("Antony (1900 - 2000)")
    end
    it "should render not the full name, just the artist name when present" do
      a = Artist.create(artist_name: "Artistname", first_name: "Antony", last_name: "Hopkins", year_of_birth: 1900, year_of_death: 2000)
      expect(a.name).to eq("Artistname (1900 - 2000)")
    end
  end

  describe "#save" do
    it "should update artist name at work" do
      Sidekiq::Testing.inline! do
        w = works(:work1)
        a = Artist.create(first_name: "Antony", last_name: "Hopkins")
        w.artists = [a]
        w.save
        a.reload
        expect(w.artist_name_rendered).to eq("Hopkins, Antony")
        a.first_name = "Charly"
        expect(a.works).to include(w)
        a.save
        w.reload
        expect(w.artist_name_rendered).to eq("Hopkins, Charly")
      end
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

  describe "#other_structured_data" do
    it "should work" do
      a = Artist.create(first_name: "A", kids_heden_kunstenaars_nummer: "123")
      expect(a.kids_heden_kunstenaars_nummer).to eq("123")
      expect(a.other_structured_data["kids_heden_kunstenaars_nummer"]).to eq("123")
      expect(a.alt_number_1).to eq("123")
    end
  end

  describe "Class methods" do
    describe ".empty_artists" do
      it "should list all workless-artists" do
        expect(Artist.empty_artists.count).to eq 3
        expect(Artist.empty_artists.first.id).to eq artists(:artist_no_works).id
      end
    end
    describe ".destroy_all_empty_artists!" do
      it "should destroy all workless-artists" do
        to_destroy_artist_id = artists(:artist_no_works).id
        destroyed_artists = Artist.destroy_all_empty_artists!
        expect(destroyed_artists.count).to eq 3
        expect(destroyed_artists.first.id).to eq to_destroy_artist_id
        expect(Artist.empty_artists.count).to eq 0
      end
      it "should list all workless-artists (check check)" do
        expect(Artist.empty_artists.count).to eq 3
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
