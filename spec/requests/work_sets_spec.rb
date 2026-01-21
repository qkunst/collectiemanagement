require "rails_helper"

RSpec.describe "/collection/:id/work_sets", type: :request do
  let(:collection) {
    collections(:collection1)
  }

  context "signed in" do
    before do
      sign_in users(:admin)
    end

    describe "GET #index" do
      it "responds" do
        get collection_work_sets_url(collection)
        expect(response).to be_successful
      end
    end

    describe "GET #show" do
      it "responds in collection context" do
        get collection_work_set_url(collection, work_sets(:work_set_collection1))
        expect(response).to be_successful
        expect(response.body).to match(/Q007/)
        expect(response.body).to match(/Q001/)
        expect(response.body).not_to match(/Q002/)
      end
      it "responds outside collection context" do
        get work_set_url(work_sets(:work_set_collection1))
        follow_redirect!
        expect(response).to be_successful
        expect(response.body).to match(/Q007/)
        expect(response.body).to match(/Q001/)
        expect(response.body).not_to match(/Q002/)
      end

      it "highlights works that do not belong to the same contact" do
        time_span = time_spans(:time_span_contact_2)
        time_span.status = "active"
        time_span.save

        work_set_time_span = time_spans(:work_set_time_span)
        work_set_time_span.status = "active"
        work_set_time_span.save

        expect(TimeSpan.active).to include(time_span)
        expect(time_span.contact).not_to eq(work_sets(:work_set_collection1).current_active_time_span.contact)

        get collection_work_set_url(collection, work_sets(:work_set_collection1))
        expect(response).to be_successful

        separator = "Werken die niet gekoppeld zijn aan de huidige klant"
        expect(response.body).to match(separator)
        response_body_after_separator = response.body.split(separator)[1]

        expect(response_body_after_separator).to match(/Q001/)
      end
    end

    describe "GET #new" do
      it "responds in collection context" do
        get new_collection_work_set_url(collection)
        expect(response).to be_successful
      end
      it "responds outside collection context" do
        get new_collection_work_set_url(collection)
        expect(response.body).to match "<h1>Groepeer werken</h1>"
      end
      it "doesn't show update" do
        get new_collection_work_set_url(collection)
        expect(response.body).not_to match "Werken toevoegen"
      end
    end
  end
end
