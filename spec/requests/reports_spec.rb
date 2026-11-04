# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Reports", type: :request do
  let(:collection) { collections(:collection1) }
  let(:user) { users(:admin) }

  # Helper to build a mock elasticsearch response object
  def build_mock_elastic_response(aggregations:, count: 0, records_count: 0)
    double(
      aggregations: aggregations,
      count: count,
      records: double(count_as_whole_works: records_count)
    )
  end

  # Minimal valid aggregations that won't cause errors during parsing
  def minimal_aggregations
    {
      "total" => double(value: 0)
    }
  end

  # Stub Work.search to avoid hitting elasticsearch
  def stub_elasticsearch_search(response = build_mock_elastic_response(aggregations: minimal_aggregations))
    allow(Work).to receive(:search).and_return(response)
  end

  describe "GET /collections/:collection_id/report" do
    context "when not signed in" do
      it "redirects to sign in page" do
        get collection_report_path(collection)
        expect(response).to have_http_status(302)
      end
    end

    context "when user cannot access the collection" do
      let(:user) { users(:user_with_no_rights) }

      before do
        sign_in user
      end

      it "redirects to root path" do
        get collection_report_path(collection)
        expect(response).to have_http_status(302)
        expect(response).to redirect_to(root_path)
      end
    end

    context "when user lacks :read_report ability" do
      let(:user) { users(:read_only) }

      before do
        sign_in user
      end

      it "redirects to root path" do
        get collection_report_path(collection)
        expect(response).to have_http_status(302)
        expect(response).to redirect_to(root_path)
      end
    end

    context "with admin user" do
      before do
        sign_in user
        stub_elasticsearch_search
      end

      it "renders successfully" do
        get collection_report_path(collection)
        expect(response).to be_successful
      end

      it "sets the correct title" do
        get collection_report_path(collection)
        expect(response.body).to include("Rapportage voor #{collection.name}")
      end

      it "shows filter checkboxes when user has :filter_report ability" do
        get collection_report_path(collection)
        expect(response).to be_successful
        expect(response.body).to include("filter")
      end

      it "includes basic Locaties section" do
        get collection_report_path(collection)
        expect(response.body).to include("locaties")
      end
    end

    context "with facility_manager user" do
      let(:user) { users(:facility_manager) }

      before do
        sign_in user
        stub_elasticsearch_search
      end

      it "renders successfully" do
        get collection_report_path(collection)
        expect(response).to be_successful
      end

      it "only shows Locaties section without tab navigation" do
        get collection_report_path(collection)
        # Facility manager only has one section (Locaties), so no tab navigation is rendered
        expect(response.body).not_to include("<nav class=\"tab-head\"")
        # Extended report sections should not be rendered as report sections
        expect(response.body).not_to include("<section id=\"vervaardigers\"")
        expect(response.body).not_to include("<section id=\"conditie\"")
        expect(response.body).not_to include("<section id=\"typering\"")
        expect(response.body).not_to include("<section id=\"marktwaardering\"")
      end
    end

    context "with facility_manager_support user" do
      let(:user) { users(:facility_manager_support) }

      before do
        sign_in user
        stub_elasticsearch_search
      end

      it "renders successfully" do
        get collection_report_path(collection)
        expect(response).to be_successful
      end

      it "shows Typering section but not extended report sections" do
        get collection_report_path(collection)
        # Facility manager support has cluster report access, so shows Typering section
        expect(response.body).to include("<section id=\"locaties\"")
        expect(response.body).to include("<section id=\"typering\"")
        # Should not have extended report sections
        expect(response.body).not_to include("<section id=\"vervaardigers\"")
        expect(response.body).not_to include("<section id=\"conditie\"")
      end
    end

    context "with compliance user" do
      let(:user) { users(:compliance) }

      before do
        sign_in user
        stub_elasticsearch_search
      end

      it "renders successfully with extended report" do
        get collection_report_path(collection)
        expect(response).to be_successful
        expect(response.body).to include("<section id=\"vervaardigers\"")
        expect(response.body).to include("<section id=\"conditie\"")
      end
    end

    context "with appraiser user" do
      let(:user) { users(:appraiser) }

      before do
        sign_in user
        stub_elasticsearch_search
      end

      it "renders successfully with extended report" do
        get collection_report_path(collection)
        expect(response).to be_successful
        expect(response.body).to include("<section id=\"marktwaardering\"")
      end
    end

    context "with advisor user" do
      let(:user) { users(:advisor) }

      before do
        sign_in user
        stub_elasticsearch_search
      end

      it "renders successfully with extended report and valuation" do
        get collection_report_path(collection)
        expect(response).to be_successful
        expect(response.body).to include("<section id=\"vervaardigers\"")
        expect(response.body).to include("<section id=\"marktwaardering\"")
        expect(response.body).to include("<section id=\"beprijzing\"")
      end
    end

    context "with registrator user" do
      let(:user) { users(:registrator) }

      before do
        sign_in user
        stub_elasticsearch_search
      end

      it "renders successfully with extended report" do
        get collection_report_path(collection)
        expect(response).to be_successful
        expect(response.body).to include("<section id=\"vervaardigers\"")
      end

      it "shows empty Beprijzing section without pricing details" do
        get collection_report_path(collection)
        # Beprijzing section exists but is empty without :read_valuation
        expect(response.body).to include("<section id=\"beprijzing\"")
        expect(response.body).not_to include("minimum_bid")
        expect(response.body).not_to include("selling_price")
      end
    end

    context "when filter_on is works" do
      before do
        sign_in user
        stub_elasticsearch_search
      end

      it "redirects to works page" do
        get collection_report_path(collection, params: {filter_on: "works"})
        expect(response).to have_http_status(302)
        expect(URI(response.headers["Location"]).path).to eq(collection_works_path(collection))
      end
    end

    context "when filter_on is create_work_set" do
      before do
        sign_in user
        stub_elasticsearch_search
      end

      it "redirects to new work set page" do
        get collection_report_path(collection, params: {filter_on: "create_work_set"})
        expect(response).to have_http_status(302)
        expect(URI(response.headers["Location"]).path).to eq(new_collection_work_set_path(collection))
      end

      context "when user cannot create work sets" do
        let(:user) { users(:facility_manager) }

        it "still redirects to new work set page" do
          get collection_report_path(collection, params: {filter_on: "create_work_set"})
          expect(response).to have_http_status(302)
          expect(URI(response.headers["Location"]).path).to eq(new_collection_work_set_path(collection))
        end
      end
    end

    context "with filter parameters" do
      before do
        sign_in user
        stub_elasticsearch_search
      end

      it "passes filter params in redirect when filter_on is works" do
        get collection_report_path(collection, params: {
          filter: {abstract_or_figurative: ["abstract"]},
          filter_on: "works"
        })
        expect(response).to have_http_status(302)
        # URL-encoded version of filter[abstract_or_figurative][]=abstract
        expect(response.headers["Location"]).to include("filter%5Babstract_or_figurative%5D%5B%5D=abstract")
      end
    end

    context "when collection has show_availability_status enabled" do
      let(:collection) { collections(:collection_with_availability) }

      before do
        sign_in user
        stub_elasticsearch_search
      end

      it "includes Status section with availability" do
        get collection_report_path(collection)
        expect(response).to be_successful
        expect(response.body).to include("<li><a href=\"#status\">")
      end
    end

    context "with time filter parameters" do
      before do
        sign_in user
        stub_elasticsearch_search
      end

      it "accepts time filter params when disabled" do
        get collection_report_path(collection, params: {
          time_filter: {
            name: "created_at_between",
            start: "2024-01-01",
            end: "2024-12-31",
            enabled: "0"
          }
        })
        expect(response).to be_successful
      end
    end

    context "with collection without works" do
      let(:collection) { collections(:boring_collection) }

      before do
        sign_in user
        stub_elasticsearch_search
      end

      it "renders successfully" do
        get collection_report_path(collection)
        expect(response).to be_successful
      end
    end

  end
end
