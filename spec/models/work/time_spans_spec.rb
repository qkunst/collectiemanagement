# frozen_string_literal: true

require_relative "../../rails_helper"

RSpec.describe Work::TimeSpans, type: :model do
  describe "instance methods" do
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
      it "is not available when it is concept rented" do
        w = works(:work1)
        w.time_spans.create(collection: w.collection, contact: contacts(:contact1), status: :concept, classification: :rental_outgoing, starts_at: 1.day.ago)
        expect(w.available?).to be_truthy
      end
    end
  end
end