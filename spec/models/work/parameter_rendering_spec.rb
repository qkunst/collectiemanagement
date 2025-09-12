require_relative "../../rails_helper"

RSpec.describe Work::ParameterRendering do
  describe "constants" do
    describe "DISPLAYED_PROPERTIES" do
      it "contains all the fields from the detailed data erb" do
        detailed_data_erb = File.read(Rails.root.join("app", "views", "works", "_work_detailed_data.html.erb"))
        fields = detailed_data_erb.scan(/(define_when_present|define\?)[\s(]:(\w+)/).map { _2.to_sym }

        expect(described_class::DISPLAYED_PROPERTIES.sort).to match(fields.uniq.sort)
      end
    end
  end
  describe "artist_name" do
    it "should keep a log of changed artists" do
      w = works(:work1)
      w.save # saving just to make the diff smaller
      w.artists << artists(:artist2)
      w.save
      change_set = YAML.unsafe_load(w.versions.last.object_changes) # standard:disable Security/YAMLLoad # object_changes is created by papertrail
      artist_name_for_sorting_changes = change_set["artist_name_for_sorting"]
      expect(artist_name_for_sorting_changes[0]).to eq("artist_1, firstname")
      expect(artist_name_for_sorting_changes[1].split(";")).to match_array(["artist_1, firstname", "artist_2 achternaam, firstie"])
    end
  end
  describe "#artist_name_rendered" do
    it "should not fail on an empty name" do
      w = Work.new
      w.save
      expect(w.artist_name_rendered).to eq(nil)
    end
    it "should summarize the artists nicely" do
      w = works(:work1)
      w.save
      w.reload
      expect(w.artist_name_rendered).to eq("artist_1, firstname (1900 - 2000)")
    end
    it "should respect include_years option" do
      works(:work1).save
      expect(works(:work1).artist_name_rendered(include_years: false)).to eq("artist_1, firstname")
    end
  end
  describe "#artist_name_rendered_without_years_nor_locality" do
    it "should summarize the artist nicely" do
      works(:work1).save
      expect(works(:work1).artist_name_rendered_without_years_nor_locality).to eq("artist_1, firstname")
    end
    it "should summarize the artists nicely" do
      works(:work1).artists << artists(:artist2)
      works(:work1).save
      expect(works(:work1).artist_name_rendered_without_years_nor_locality_semicolon_separated).to match("artist_1, firstname")
      expect(works(:work1).artist_name_rendered_without_years_nor_locality_semicolon_separated).to match("artist_2 achternaam, firstie")
      expect(works(:work1).artist_name_rendered_without_years_nor_locality_semicolon_separated).to match(";")
    end
  end
  describe "#artist_name_rendered_without_years_nor_locality_semicolon_separated" do
    it "should summarize the artist nicely" do
      works(:work1).save
      expect(works(:work1).artist_name_rendered_without_years_nor_locality_semicolon_separated).to eq("artist_1, firstname")
    end
    it "should summarize the artists nicely" do
      works(:work1).artists << artists(:artist2)
      works(:work1).save
      expect(works(:work1).artist_name_rendered_without_years_nor_locality_semicolon_separated).to match("artist_1, firstname")
      expect(works(:work1).artist_name_rendered_without_years_nor_locality_semicolon_separated).to match("artist_2 achternaam, firstie")
      expect(works(:work1).artist_name_rendered_without_years_nor_locality_semicolon_separated).to match(";")
    end
  end
  describe "#location_raw, #location_floor_raw, #location_detail_raw" do
    it "returns not set when nil" do
      w = Work.new
      expect(w.location_raw).to eq("not_set")
      expect(w.location_floor_raw).to eq("not_set|>|not_set")
      expect(w.location_detail_raw).to eq("not_set|>|not_set|>|not_set")
    end
    it "returns values when set" do
      w = Work.new(location: "A ", location_floor: " b ", location_detail: " 1")

      expect(w.location_raw).to eq("A")
      expect(w.location_floor_raw).to eq("A|>|b")
      expect(w.location_detail_raw).to eq("A|>|b|>|1")
    end
  end

  describe "#ppid_url" do
    it "returns nil by default" do
      expect(Work.new.ppid_url).to eq(nil)
    end

    it "returns a ppid url when code is present on collection" do
      expect(works(:work1).ppid_url).to eq("https://ppid.qkunst.nl/col_with_works/Q001.public")
    end

    it "returns a ppid url when code contains spaces" do
      work = works(:work1)
      work.stock_number = "Q 001"
      expect(work.ppid_url).to eq("https://ppid.qkunst.nl/col_with_works/Q+001.public")
    end
  end
end
