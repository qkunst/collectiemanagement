require "rails_helper"

RSpec.describe "SimpleImportCollections", type: :request do
  let(:collection) { collections(:collection1) }

  context "when not logged in" do
    describe "GET #new" do
      it "returns http redirect" do
        get "/collections/#{collection.id}/manage/simple_import_collections/new"
        expect(response.code).to eq "302"
      end
    end

    describe "POST #create" do
      it "returns http redirect" do
        post "/collections/#{collection.id}/manage/simple_import_collections"
        expect(response.code).to eq "302"
      end
    end
  end

  context "when logged in as advisor" do
    before do
      user = users(:advisor)
      sign_in user
    end

    describe "GET #new" do
      it "returns http success" do
        get "/collections/#{collection.id}/manage/simple_import_collections/new"
        expect(response.code).to eq "200"
      end
    end

    describe "POST #create" do
      it "will evaluat the params" do
        # skipping delivering correct values here for now
        post "/collections/#{collection.id}/manage/simple_import_collections"
        expect(response.code).to eq "400"
      end

      it "do the upload" do
        file = fixture_file_upload("simple_import.xlsx", "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", :binary)
        expect {
          post collection_simple_import_collections_path(collection), params: {simple_import_collection: {file: file}}
        }.to change(ImportCollection, :count).by(1)
      end
    end

    describe "GET #show" do
      it "shows the import and doesn't modify the work" do
        work = collection.works.find_by(stock_number: "Qwma")
        file = fixture_file_upload("simple_import.xlsx", "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", :binary)
        post collection_simple_import_collections_path(collection), params: {simple_import_collection: {file: file}}
        get collection_simple_import_collection_path(collection, SimpleImportCollection.last)
        expect(response.body).to match "Qwma"
        expect(response.body).to match "nieuwe loc spec"
        expect(work.location).to eq(nil)
      end
    end

    describe "GET #update" do
      it "regular update doesn't modify the work" do
        file = fixture_file_upload("simple_import.xlsx", "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", :binary)
        post collection_simple_import_collections_path(collection), params: {simple_import_collection: {file: file}}
        patch collection_simple_import_collection_path(collection, SimpleImportCollection.last, params: {simple_import_collection: {primary_key: :stock_number}})
        work = collection.works.find_by(stock_number: "Qwma")
        expect(work.location).to be_nil
      end

      it " update with write does modify the work" do
        file = fixture_file_upload("simple_import.xlsx", "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", :binary)
        post collection_simple_import_collections_path(collection), params: {simple_import_collection: {file: file}}
        patch collection_simple_import_collection_path(collection, SimpleImportCollection.last, params: {simple_import_collection: {primary_key: :stock_number}, write: true})
        work = collection.works.find_by(stock_number: "Qwma")
        expect(work.location).not_to be_nil
      end
    end
  end
end
