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
        expect {
          post "/collections/#{collection.id}/manage/simple_import_collections"
        }.to raise_error(ActionController::ParameterMissing)
      end
    end
  end
end
