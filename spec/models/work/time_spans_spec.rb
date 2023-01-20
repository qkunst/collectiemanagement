# frozen_string_literal: true

require_relative "../../rails_helper"

RSpec.describe Work::TimeSpans, type: :model do
  include ActiveSupport::Testing::TimeHelpers

  describe "instance methods" do
    describe "#current_active_time_span" do
      it "returns nil by default" do
        expect(works(:work1).current_active_time_span).to eq(nil)
      end

      it "returns active time span by default" do
        works(:work1).time_spans.create(collection: works(:work1).collection, contact: contacts(:contact1), status: :active, classification: :rental_outgoing, starts_at: 1.day.ago)

        expect(works(:work1).current_active_time_span.status).to eq("active")
      end

      it "returns reservation if none active" do
        works(:work1).time_spans.create(collection: works(:work1).collection, contact: contacts(:contact1), status: :reservation, classification: :rental_outgoing, starts_at: 1.day.ago)

        expect(works(:work1).current_active_time_span.status).to eq("reservation")
      end

      it "returns active time span by default even when reservation is later" do
        travel_to(1.day.ago) do
          works(:work1).time_spans.create(collection: works(:work1).collection, contact: contacts(:contact1), status: :active, classification: :rental_outgoing, starts_at: 1.day.ago)
        end
        works(:work1).time_spans.create(collection: works(:work1).collection, contact: contacts(:contact1), status: :reservation, classification: :rental_outgoing, starts_at: 1.day.ago)

        expect(works(:work1).current_active_time_span.status).to eq("active")
      end
    end

    describe "#available?" do
      it "is available by default" do
        expect(Work.new.available?).to be_truthy
        expect(works(:work1).available?).to be_truthy

        expect(works(:collection_with_availability_available_work).available?).to be_truthy
      end
      it "is not available when sold" do
        w = works(:work1)
        w.removed_from_collection!
        expect(w.available?).to be_falsey

        w = works(:collection_with_availability_sold)
        expect(w.available?).to be_falsey
      end
      it "is not available when it is actively rented" do
        w = works(:work1)
        w.time_spans.create(collection: w.collection, contact: contacts(:contact1), status: :active, classification: :rental_outgoing, starts_at: 1.day.ago)
        expect(w.available?).to be_falsey
      end
      it "is available when it is concept rented" do
        w = works(:work1)
        w.time_spans.create(collection: w.collection, contact: contacts(:contact1), status: :concept, classification: :rental_outgoing, starts_at: 1.day.ago)
        expect(w.available?).to be_truthy
      end
    end
  end
end
