require_relative "../../rails_helper"

RSpec.describe Work::Export do
  describe "class methods" do
    describe ".possible_exposable_fields" do
      it "should return possible_exposable_fields" do
        expect(Work.possible_exposable_fields).to include("owner")
        expect(Work.possible_exposable_fields).to include("location_detail")
        expect(Work.possible_exposable_fields).to include("location_floor")
      end
    end

    describe ".to_workbook" do
      let(:collection) { collections(:collection_with_works) }

      it "should be callable and return a workbook" do
        expect(Work.to_workbook.class).to eq(Workbook::Book)
      end
      it "should be work even with complex fieldset" do
        expect(Work.to_workbook(collection.fields_to_expose(:default)).class).to eq(Workbook::Book)
      end
      it "should work with tags" do
        work = collection.works.first
        work.tag_list = "kaas"
        work.save
        expect(Work.to_workbook(collection.fields_to_expose(:default)).class).to eq(Workbook::Book)
      end
      it "should return basic types" do
        work = collection.works.order(:stock_number).first
        work.save

        artist_name = "artist_1, firstname (1900 - 2000)"

        expect(work.artists.first.name).to eq(artist_name)

        workbook = collection.works.order(:stock_number).to_workbook(collection.fields_to_expose(:default))

        expect(workbook.class).to eq(Workbook::Book)
        expect(workbook.sheet.table[1][:inventarisnummer].value).to eq(work.stock_number)

        expect(workbook.sheet.table[1][:vervaardigers].value).to eq(artist_name)
      end
      it "should allow for sorting by location" do
        # this is the typical query ran
        works = collection.works.order_by(:location).where(location: "Adres").distinct

        workbook = works.to_workbook(collection.fields_to_expose(:default))
        expect(workbook.class).to eq(Workbook::Book)

        expect(workbook.sheet.table[1]["Adres en/of gebouw(deel)"].value).to eq("Adres")
        expect(workbook.sheet.table[1]["Verdieping"].value).to eq("Floor 1")
        expect(workbook.sheet.table[1]["Locatie specificatie"].value).to eq("Room 1")
      end
    end
  end

  describe "Instance methods" do
    describe "#artist_#\{index\}_methods" do
      it "should have a first artist" do
        w = works(:work1)
        expect(w.artist_0_last_name).to eq("artist_1")
        expect(w.artist_0_first_name).to eq("firstname")
      end
      it "should return nil when no artist is found at index" do
        w = works(:work1)
        expect(w.artist_4_last_name).to eq(nil)
        expect(w.artist_4_first_name).to eq(nil)
      end
    end
  end
end
