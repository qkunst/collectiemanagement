require 'rails_helper'

RSpec.describe TimeSpan, type: :model do
  let(:work) { works(:work1) }

  describe ".new & validations" do
    context "concept" do
      it "is valid when subject, collection and contact are set" do
        ts = TimeSpan.new(subject: work, collection: works(:work1).collection.base_collection, contact: contacts(:contact1), status: :concept, classification: :rental_outgoing)
        expect(ts.valid?).to be_truthy
      end

      it "is not valid when work is no longer available, collection and contact are set" do
        work.removed_from_collection!
        ts = TimeSpan.new(subject: work, collection: works(:work1).collection.base_collection, contact: contacts(:contact1), status: :concept, classification: :rental_outgoing)
        expect(ts.valid?).to be_falsey
      end
    end
  end

  describe "Callbacks" do
    it "#remove_work_from_collection_when_purchase_active" do
      ts = TimeSpan.create(subject: work, collection: works(:work1).collection.base_collection, contact: contacts(:contact1), status: :concept, classification: :purchase)
      work.reload
      expect(work.removed_from_collection?).to be_falsey


      ts = TimeSpan.create(subject: work, collection: works(:work1).collection.base_collection, contact: contacts(:contact1), status: :active, classification: :purchase)
      work.reload
      expect(work.removed_from_collection?).to be_truthy
    end
  end

  describe "scopes" do
    describe ".current" do
      [:time_span1,:time_span2,:time_span3,:time_span4].each do |span|
        it { expect(TimeSpan.current).to include time_spans(span) }
      end
      [:time_span_historic, :time_span_future].each do |span|
        it { expect(TimeSpan.current).not_to include time_spans(span) }
      end

      it "should include expired, active time spans" do
        expect(TimeSpan.current).to include time_spans(:time_span_expired)
      end
    end

    describe ".expired" do
      [:time_span1,:time_span2,:time_span3,:time_span4].each do |span|
        it { expect(TimeSpan.expired).not_to include time_spans(span) }
      end
      [:time_span_historic, :time_span_future].each do |span|
        it { expect(TimeSpan.expired).not_to include time_spans(span) }
      end

      it "should include expired, active time spans" do
        expect(TimeSpan.expired).to include time_spans(:time_span_expired)
      end
    end
  end
end
