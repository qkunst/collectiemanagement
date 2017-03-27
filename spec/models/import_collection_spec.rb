require 'rails_helper'

RSpec.describe ImportCollection, type: :model do
  describe "instance methods" do
    describe "#internal_header_row_offset" do
      it "should work humanely" do
        i = ImportCollection.new
        expect(i.internal_header_row_offset).to eq(0)
        i.header_row = 0
        expect(i.internal_header_row_offset).to eq(0)
        i.header_row = 1
        expect(i.internal_header_row_offset).to eq(0)
        i.header_row = 2
        expect(i.internal_header_row_offset).to eq(1)
      end
    end
    describe "#workbook" do
      it "should update import settings" do
        i = ImportCollection.create(file: File.open(File.join(Rails.root,"spec","fixtures","import_collection_file.csv")))
        expect(i.workbook.class).to eq(Workbook::Book)
      end
    end
    describe "#import_file_to_workbook_table" do
      it "should return the table" do
        i = ImportCollection.create(file: File.open(File.join(Rails.root,"spec","fixtures","import_collection_file.csv")))
        expect(i.import_file_to_workbook_table.class).to eq(Workbook::Table)
        expect(i.import_file_to_workbook_table.to_csv).to eq("artist_name,work_title\nAchternaam,Zonder Titel\nAndere Achternaam,Zonder Unieke Titel\n")
      end
    end
    describe "#update" do
      it "should allow for updating import settings" do
        i = ImportCollection.create(file: File.open(File.join(Rails.root,"spec","fixtures","import_collection_file.csv")))
        i.update("import_settings"=>{"title"=>{"split_strategy"=>"split_nothing", "assign_strategy"=>"append", "fields"=>["work.title"]}})
        expect(i.import_settings).to eq({"title"=>{"split_strategy"=>"split_nothing", "assign_strategy"=>"append", "fields"=>["work.title"]}})
      end
    end
    describe "#read" do
      it "should work" do
        i = ImportCollection.create(file: File.open(File.join(Rails.root,"spec","fixtures","import_collection_file.csv")))
        i.collection = collections(:collection1)
        i.update("import_settings"=>{"work_title"=>{"split_strategy"=>"split_nothing", "assign_strategy"=>"append", "fields"=>["work.title"]}})
        expect(i.read.count).to eq(2)
        expect(i.read[0].title).to eq(nil)
        expect(i.read[0].title_unknown).to eq(true)
        expect(i.read[1].title).to eq("Zonder Unieke Titel")
        expect(i.read[1].title_unknown).to be_falsy
      end
    end
  end
  describe "class methods" do
    describe ".split_strategies" do
      it "should work" do
        expect(ImportCollection.split_strategies[:split_space].call("ad sf")).to eq(["ad","sf"])
        expect(ImportCollection.split_strategies[:split_nothing].call("ad sf")).to eq(["ad sf"])
      end
    end
    describe ".import_type.new(parameters)" do
      it "should create a new work" do
        expect(ImportCollection.import_type.new(title: "abc").title).to eq("abc")
      end
    end
  end
end
