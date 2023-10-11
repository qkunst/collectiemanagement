require "rails_helper"

RSpec.describe "ShortCodeResolvers", type: :request do
  describe "GET /resolve" do
    let(:work) { works(:work_diptych_2) }

    it "returns http not found for unknown collection code" do
      expect {
        get "/short_code_resolver/resolve/ABC/123"
      }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "returns http not found for unknown work code" do
      expect {
        get "/short_code_resolver/resolve/COL4/123"
      }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "redirects when known combi is given" do
      get "/short_code_resolver/resolve/#{work.collection.unique_short_code}/#{work.stock_number}"
      expect(response).to redirect_to(collection_work_path(work.collection, work))
    end
  end
end
