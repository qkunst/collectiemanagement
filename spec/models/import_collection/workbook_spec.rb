# frozen_string_literal: true

require "rails_helper"

RSpec.describe ImportCollection::Workbook, type: :model do
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
        i = ImportCollection.create(file: File.open(Rails.root.join("spec/fixtures/import_collection_file.csv").to_s))
        expect(i.workbook.class).to eq(Workbook::Book)
      end
    end
    describe "#import_file_to_workbook_table" do
      it "should return the table" do
        i = ImportCollection.create(file: File.open(Rails.root.join("spec/fixtures/import_collection_file.csv").to_s))
        expect(i.import_file_to_workbook_table.class).to eq(Workbook::Table)
        expect(i.import_file_to_workbook_table.to_csv).to match("stock_number,artist_name,work_title,Drager,Niveau")
        expect(i.import_file_to_workbook_table.to_csv).to match("Qimp001, Achternaam,Zonder Titel,doek,A")
        expect(i.import_file_to_workbook_table.to_csv).to match("Qimp002, Andere Achternaam,Zonder Unieke Titel,Papier,C")
        expect(i.import_file_to_workbook_table.to_csv).to match("Qimp003, onbekend,Uniek,,D,\"earth, wind\"\nQimp004, Onbekend,Uniek2,,G")
      end
    end
    describe "#columns_for_select" do
      it "should not expose unsupported options" do
        object_keys = ImportCollection.new.columns_for_select.keys
        expect(object_keys).to include(:work)
        expect(object_keys).to include(:artists)
        expect(object_keys).not_to include(:work_sets)
        expect(object_keys).not_to include(:library_items)
        expect(object_keys).not_to include(:collection_attributes)
        expect(object_keys.length).to eq(3)
      end

      it "should include must have appraisal keys" do
        expect(ImportCollection.new.columns_for_select[:appraisals].sort).to match(["appraised_on", "market_value", "replacement_value", "appraised_by", "reference", "market_value_min", "market_value_max", "replacement_value_min", "replacement_value_max", "notice"].sort)
      end
    end
    describe "#update" do
      it "should allow for updating import settings" do
        i = ImportCollection.create(file: File.open(Rails.root.join("spec/fixtures/import_collection_file.csv").to_s))
        i.update("import_settings" => {"title" => {"split_strategy" => "split_nothing", "assign_strategy" => "append", "fields" => ["work.title"]}})
        expect(i.import_settings).to eq({"title" => {"split_strategy" => "split_nothing", "assign_strategy" => "append", "fields" => ["work.title"]}})
      end
    end
    describe "#read" do
      it "should work" do
        i = ImportCollection.create(file: File.open(Rails.root.join("spec/fixtures/import_collection_file.csv").to_s))
        i.collection = collections(:collection1)
        i.update("import_settings" => {
          "work_title" => {"split_strategy" => "split_nothing", "assign_strategy" => "append", "fields" => ["work.title"]},
          "artist_name" => {"split_strategy" => "split_space", "assign_strategy" => "append", "fields" => ["artist.first_name", "artist.last_name"]},
          "Drager" => {"split_strategy" => "find_keywords", "assign_strategy" => "replace", "fields" => ["work.medium"]},
          "Niveau" => {"split_strategy" => "split_nothing", "assign_strategy" => "replace", "fields" => ["work.grade_within_collection"]},
          "Themas" => {"split_strategy" => "find_keywords", "assign_strategy" => "append", "fields" => ["work.themes"]}
        })
        read = i.read
        read.each do |a|
          a.save
          a.reload
        end
        expect(read[0].title).to eq(nil)
        expect(read[0].title_unknown).to eq(true)
        expect(read[0].id).to be > 0
        expect(read[1].id).to be > 0
        expect(read[2].id).to be > 0
        expect(read[3].id).to be > 0
        expect(read[1].title).to eq("Zonder Unieke Titel")
        expect(read[1].title_unknown).to be_falsy
        expect(read[1].themes.collect { |a| a.name }).to match_array(["earth", "wind"])
        expect(read[0].themes.collect { |a| a.name }).to eq(["earth"])
        expect(read[3].themes.collect { |a| a.name }).to eq(["fire"])
        expect(read[1].medium.name).to eq("Papier")
        expect(read[2].medium).to be_nil
        expect(read[0].grade_within_collection).to eq("A")
        expect(read[1].grade_within_collection).to eq("C")
        expect(read[0].artist_unknown).to be_falsy

        expect(read[0].collection).to eq(collections(:collection1))
        expect(read[1].collection).to eq(collections(:collection1))
        expect(read[2].collection).to eq(collections(:collection1))
        expect(read[3].collection).to eq(collections(:collection1))
        expect(read[3].artists).to eq([])
        expect(read[3].artist_unknown).to be_truthy
        expect(read[2].artists).to eq([])
      end
      it "should import into a different collection when sub" do
        i = ImportCollection.create(file: File.open(Rails.root.join("spec/fixtures/import_collection_file_edge_cases.csv").to_s))
        i.collection = collections(:collection1)
        i.update("import_settings" => {
          "work_title" => {"split_strategy" => "split_nothing", "assign_strategy" => "append", "fields" => ["work.title"]},
          "artist_name" => {"split_strategy" => "split_space", "assign_strategy" => "append", "fields" => ["artist.first_name", "artist.last_name"]},
          "Drager" => {"split_strategy" => "find_keywords", "assign_strategy" => "replace", "fields" => ["work.medium"]},
          "Niveau" => {"split_strategy" => "split_nothing", "assign_strategy" => "replace", "fields" => ["work.grade_within_collection"]},
          "Thema's" => {"split_strategy" => "find_keywords", "assign_strategy" => "append", "fields" => ["work.themes"]},
          "Collectie" => {"split_strategy" => "find_keywords", "assign_strategy" => "replace", "fields" => ["work.collection"]},
          "Cluster" => {"split_strategy" => "find_keywords", "assign_strategy" => "replace", "fields" => ["work.cluster"]},
          "tags" => {"split_strategy" => "split_comma", "assign_strategy" => "append", "fields" => ["work.tag_list"]},
          "tags more" => {"split_strategy" => "split_comma", "assign_strategy" => "append", "fields" => ["work.tag_list"]},
          "Nog een thema" => {"split_strategy" => "find_keywords", "assign_strategy" => "append", "fields" => ["work.themes"]},
          "driespaties" => {"split_strategy" => "split_nothing", "assign_strategy" => "replace", "fields" => ["work.description"]},
          "inventoried bool test" => {"split_strategy" => "split_nothing", "assign_strategy" => "replace", "fields" => ["work.inventoried"]}
        })
        read = i.read
        expect(read.count).to eq(6)
        expect(read[2].collection).to eq(collections(:collection_with_works))
        expect(read[1].tag_list).to include("kaas")
        expect(read[0].tag_list).to include("kaas")
        expect(read[0].themes.collect { |a| a.name }).to eq(["earth", "fire"])
        expect(read[3].artists).to include(artists(:artist1))
        expect(read[4].artists.count).to eq 0
        expect(read[4].artist_unknown).to be_falsy
        expect(read[0].description).to eq("één")
        expect(read[0].inventoried).to eq(true)
        expect(read[1].inventoried).to eq(true)
        expect(read[2].inventoried).to eq(false)
        expect(read[3].inventoried).to eq(false)
        expect(read[4].inventoried).to eq(false)
        expect(read[5].inventoried).to eq(false)
      end

      it "should not import into a different collection when not a child" do
        i = ImportCollection.create(file: File.open(Rails.root.join("spec/fixtures/import_failing_collection.csv").to_s))
        i.collection = collections(:collection1)
        i.update("import_settings" => {
          "work_title" => {"split_strategy" => "split_nothing", "assign_strategy" => "append", "fields" => ["work.title"]},
          "artist_name" => {"split_strategy" => "split_space", "assign_strategy" => "append", "fields" => ["artist.first_name", "artist.last_name"]},
          "Drager" => {"split_strategy" => "find_keywords", "assign_strategy" => "replace", "fields" => ["work.medium"]},
          "Niveau" => {"split_strategy" => "split_nothing", "assign_strategy" => "replace", "fields" => ["work.grade_within_collection"]},
          "Thema's" => {"split_strategy" => "find_keywords", "assign_strategy" => "append", "fields" => ["work.themes"]},
          "Collectie" => {"split_strategy" => "find_keywords", "assign_strategy" => "replace", "fields" => ["work.collection"]},
          "Cluster" => {"split_strategy" => "find_keywords", "assign_strategy" => "replace", "fields" => ["work.cluster"]}
        })
        expect {
          i.read
        }.to raise_error(ImportCollection::FailedImportError)
      end
    end
  end
end
