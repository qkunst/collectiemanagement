require "rails_helper"

RSpec.describe "SimpleImportCollections", type: :request do
  let(:collection) { collections(:collection1) }

  context "when not logged in" do
    describe "GET #new" do
      it "returns http success" do
        get "/collections/#{collection.id}/manage/simple_import_collections/new"
        expect(response.code).to eq "302"
      end
    end

    describe "POST #create" do
      it "returns http success" do
        post "/collections/#{collection.id}/manage/simple_import_collections"
        expect(response.code).to eq "302"
      end
    end
  end
end
