require "rails_helper"
RSpec.describe SimpleImportCollection, type: :model do
  let(:filename) { "import_collection_file.xlsx" }
  let(:subject) { described_class.new(file: File.open(Rails.root.join("spec", "fixtures", filename)), collection: collections(:collection1)) }

  describe "initialization" do
    it "sets defaults" do
      expect(subject.merge_data).to be_truthy
      expect(subject.primary_key).to eq(:stock_number)
      expect(subject.decimal_separator).to eq(",")
    end
  end

  describe "#import_settings" do
    let(:result) { subject.import_settings }
    it "only matches a single field" do
      result.map { |_, v| v["fields"].count }.uniq == [1]
    end

    it "doesn't split" do
      result.map { |_, v| v["split_strategy"] }.uniq == ["split_nothing"]
    end

    it "replaces" do
      result.map { |_, v| v["assign_strategy"] }.uniq == ["replace"]
    end

    it "reproduces system names" do
      expect(result[:stock_number]["fields"]).to eq(["work.stock_number"])
      expect(result[:artist_name]["fields"]).to eq(["work.artist_name"])
      expect(result[:work_title]["fields"]).to eq(["work.work_title"])
      expect(result[:locatie_specificatie]["fields"]).to eq(["work.location_detail"])
    end
    it "reproduces human names of attributes" do
      expect(result[:drager]["fields"]).to eq(["work.medium"])

      expect(result[:niveau_binnen_collectie]["fields"]).to eq(["work.grade_within_collection"])
    end

    xit "reproduces human names of has and belongs to manies" do
      expect(result[:themas]["fields"]).to eq(["work.themes"])
    end
    context "ods file" do
      let(:filename) { "import_collection_file.ods" }

      it "reproduces system names" do
        expect(result[:stock_number]["fields"]).to eq(["work.stock_number"])
        expect(result[:artist_name]["fields"]).to eq(["work.artist_name"])
        expect(result[:work_title]["fields"]).to eq(["work.work_title"])
      end
      it "reproduces human names of attributes" do
        expect(result[:drager]["fields"]).to eq(["work.medium"])
      end
    end
  end

  describe "#write" do
    before do
      subject.save
    end
    it "writes" do
      expect(subject.write).to be_truthy
    end

    it "adds missing works" do
      expect { subject.write }.to change { Work.count }.by(4)
    end

    it "adds updated fields" do
      expect { subject.write }.to change { Work.count }.by(4)

      some_work = Work.find_by_stock_number("Qimp001")
      some_work_id = some_work.id
      expect(some_work.location_detail).to eq("locatie specificatie")

      some_work.update(location_detail: "something set by test")
      expect(some_work.location_detail).to eq("something set by test")

      expect { subject.write }.to change { Work.count }.by(0)
      some_work = Work.find some_work_id

      expect(some_work.location_detail).to eq("locatie specificatie")
    end

    ["import_collection_file.ods", "import_collection_file.xlsx"].each do |file_context|
      context file_context do
        let(:filename) { file_context }
        it "imports correctly" do
          expect { subject.write }.to change { Work.count }.by(4)

          attributes = [:location_detail, :purchase_price, :purchased_on]
          {"Qimp001" => ["locatie specificatie", 1200, Date.new(2023, 12, 1)],
           "Qimp002" => ["locatie specificatie", 1200, Date.new(2023, 1, 12)],
           "Qimp003" => ["Aankoopdatum 1 december; 40 cent", 1200.4, Date.new(2023, 12, 1)],
           "Qimp004" => ["Aankoopdatum 12 januari", 1200.4, Date.new(2023, 1, 12)]}.each do |stock_number, expected|
            some_work_attributes = Work.where(stock_number:).pluck(*attributes).first
            expect(some_work_attributes).to eq expected
          end
        end
      end
    end
  end
end
