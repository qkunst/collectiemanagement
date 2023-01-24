# == Schema Information
#
# Table name: time_spans
#
#  id             :bigint           not null, primary key
#  classification :string
#  comments       :text
#  ends_at        :datetime
#  old_data       :text
#  starts_at      :datetime
#  status         :string
#  subject_type   :string
#  uuid           :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  collection_id  :bigint
#  contact_id     :bigint
#  subject_id     :bigint
#  time_span_id   :bigint
#
require "rails_helper"

RSpec.describe TimeSpan, type: :model do
  let(:work) { works(:work1) }

  describe ".new & validations" do
    context "concept" do
      it "is valid when subject, collection and contact are set" do
        ts = TimeSpan.new(subject: work, collection: works(:work1).collection.base_collection, contact: contacts(:contact1), starts_at: Time.now, status: :concept, classification: :rental_outgoing)
        expect(ts.valid?).to be_truthy
      end

      it "is not valid when work is no longer available, collection and contact are set" do
        work.removed_from_collection!
        ts = TimeSpan.new(subject: work, collection: works(:work1).collection.base_collection, contact: contacts(:contact1), starts_at: Time.now, status: :concept, classification: :rental_outgoing)
        expect(ts.valid?).to be_falsey
      end

      it "is not valid when classification is false, but subject, collection and contact are set" do
        ts = TimeSpan.new(subject: work, collection: works(:work1).collection.base_collection, contact: contacts(:contact1), starts_at: Time.now, status: :concept, classification: :false_classification)
        expect(ts.valid?).to be_falsey
      end

      it "is valid when classification is reservation and work is in use" do
        ts = TimeSpan.create(subject: work, collection: works(:work1).collection.base_collection, contact: contacts(:contact1), starts_at: Time.now, status: :active, classification: :rental_outgoing)
        work.reload
        ts = TimeSpan.create(subject: work, collection: works(:work1).collection.base_collection, contact: contacts(:contact_internal), starts_at: Time.now, status: :reservation, classification: :rental_outgoing)
        expect(ts.valid?).to be_truthy
        fully_reloaded_work = Work.find(work.id)
        expect(fully_reloaded_work.availability_status).to eq(:lent)
      end

      it "is valid when work was reserved but will now be lent" do
        ts = TimeSpan.create(subject: work, collection: works(:work1).collection.base_collection, contact: contacts(:contact_internal), starts_at: Time.now, status: :reservation, classification: :rental_outgoing)
        work.reload
        ts = TimeSpan.create(subject: work, collection: works(:work1).collection.base_collection, contact: contacts(:contact1), starts_at: Time.now, status: :active, classification: :rental_outgoing)
        expect(ts.valid?).to be_truthy
        fully_reloaded_work = Work.find(work.id)
        expect(fully_reloaded_work.availability_status).to eq(:lent)
      end

      it "is is not valid when work was lent but will now be lent" do
        ts = TimeSpan.create(subject: work, collection: works(:work1).collection.base_collection, contact: contacts(:contact_internal), starts_at: Time.now, status: :active, classification: :rental_outgoing)
        work.reload
        ts = TimeSpan.create(subject: work, collection: works(:work1).collection.base_collection, contact: contacts(:contact1), starts_at: Time.now, status: :active, classification: :rental_outgoing)
        expect(ts.valid?).to be_falsey
        fully_reloaded_work = Work.find(work.id)
        expect(fully_reloaded_work.availability_status).to eq(:lent)
        expect(fully_reloaded_work.current_active_time_span.contact).to eq(contacts(:contact_internal))
      end
    end
    context "finished" do
      it "doesn't override end time" do
        ts = TimeSpan.new(subject: work, collection: works(:work1).collection.base_collection, contact: contacts(:contact1), starts_at: 1.year.ago, ends_at: 1.month.ago, status: :finished, classification: :rental_outgoing)
        ts.save
        expect(ts.ends_at).to be < 1.day.ago
      end
    end
    context "import failurs" do
      it "should work for all examples" do
        data = [{"contact" => {"external" => true, "url" => "http://localhost:5001/customers/0343df8a-92ed-45bc-893e-bbd424a7015a", "name" => ""}, "starts_at" => "1997-11-15", "ends_at" => "2006-06-05", "status" => "finished", "classification" => "rental_outgoing"}, {"contact" => {"external" => true, "url" => "http://localhost:5001/customers/4bc1db3d-fc1d-470c-a16f-4a86628fc766", "name" => ""}, "starts_at" => "2002-11-25", "ends_at" => "2003-11-28", "status" => "finished", "classification" => "rental_outgoing"}, {"contact" => {"external" => true, "url" => "http://localhost:5001/customers/86679f73-bbc4-46aa-bc38-61d9fb2b2ac0", "name" => ""}, "starts_at" => "2010-10-25", "ends_at" => "2011-10-25", "status" => "finished", "classification" => "rental_outgoing"}, {"contact" => {"external" => true, "url" => "http://localhost:5001/customers/17336a8b-9a88-4c29-a7bc-48d89ecf5579", "name" => ""}, "starts_at" => "2012-03-20", "ends_at" => "2013-03-20", "status" => "finished", "classification" => "rental_outgoing"}, {"contact" => {"external" => true, "url" => "http://localhost:5001/customers/fb8f7555-d6ae-41f3-b814-3294dff96ce9", "name" => ""}, "starts_at" => "2020-02-19", "ends_at" => "2021-02-19", "status" => "finished", "classification" => "rental_outgoing"}, {"contact" => {"external" => true, "url" => "http://localhost:5001/customers/"}, "starts_at" => "2021-08-25", "status" => "active", "classification" => "rental_outgoing"}]
        work = works(:work7)
        data.each do |time_span|
          contact = time_span["contact"]["external"] ?
            Contact.find_or_create_by(url: time_span["contact"]["url"]) { |contact| contact.name = time_span["contact"]["name"], contact.address = time_span["contact"]["address"], contact.external = true } :
            Contact.find_or_create_by(name: time_span["contact"]["name"], address: time_span["contact"]["address"], external: false, url: time_span["contact"]["url"], collection: base_collection)

          time_span = TimeSpan.find_or_create_by(contact: contact, starts_at: time_span["starts_at"], ends_at: time_span["ends_at"], subject: work, uuid: time_span["uuid"], status: time_span["status"], classification: time_span["classification"], collection: work.collection)

          expect(time_span).to be_valid
          # work.time_spans << time_span
        end
        expect(work.time_spans.count).to eq(data.count)
        work.time_spans.each do |ts|
          expect(ts).to be_valid
        end
      end
    end
  end

  describe "Callbacks" do
    it "#remove_work_from_collection_when_purchase_active" do
      ts = TimeSpan.create(subject: work, collection: works(:work1).collection.base_collection, contact: contacts(:contact1), starts_at: Time.now, status: :concept, classification: :purchase)
      work.reload
      expect(work.removed_from_collection?).to be_falsey

      ts = TimeSpan.create(subject: work, collection: works(:work1).collection.base_collection, contact: contacts(:contact1), starts_at: Time.now, status: :active, classification: :purchase)
      work.reload
      expect(work.removed_from_collection?).to be_truthy
    end

    describe "#sync_time_spans_for_works_when_work_set" do
      it "creates none when a work" do
        ts = TimeSpan.create(subject: work, collection: works(:work1).collection.base_collection, contact: contacts(:contact1), starts_at: Time.now, status: :concept, classification: :purchase)
        expect(ts.time_spans).to eq([])
      end

      it "creates time spans when for works in a work_set" do
        work_set = work_sets(:random_other_collection)
        ts = TimeSpan.create(subject: work_set, collection: works(:work1).collection.base_collection, contact: contacts(:contact1), starts_at: Time.now, status: :concept, classification: :purchase)
        expect(ts.time_spans.count).to eq(work_set.works.count)
      end

      it "results in underlying works to be no longer available" do
        work_set = work_sets(:random_other_collection)
        ts = TimeSpan.create(subject: work_set, collection: works(:work1).collection.base_collection, contact: contacts(:contact1), starts_at: Time.now, status: :active, classification: :purchase)
        expect(work_set.works.first.availability_status).to eq(:sold)
        expect(work_set.works.first.removed_from_collection?).to eq(true)
      end

      it "results in underlying works to become available when returned" do
        work_set = work_sets(:random_other_collection)
        ts = TimeSpan.create(subject: work_set, collection: works(:work1).collection.base_collection, contact: contacts(:contact1), starts_at: Time.now, status: :active, classification: :rental_outgoing)
        expect(ts.time_spans.count).to eq(work_set.works.count)

        work_set.works.reload

        expect(work_set.works.first.availability_status).to eq(:lent)
        expect(work_set.works.first.removed_from_collection?).to eq(false)

        ts.finish
        ts.save

        work_set.works.reload

        expect(work_set.works.first.availability_status).to eq(:available)
        expect(work_set.works.first.removed_from_collection?).to eq(false)
      end

      it "results in underlying works to become available when converted to concept" do
        work_set = work_sets(:random_other_collection)
        ts = TimeSpan.create(subject: work_set, collection: works(:work1).collection.base_collection, contact: contacts(:contact1), starts_at: Time.now, status: :active, classification: :rental_outgoing)
        expect(ts.time_spans.count).to eq(work_set.works.count)

        work_set.works.reload

        expect(work_set.works.first.availability_status).to eq(:lent)
        expect(work_set.works.first.removed_from_collection?).to eq(false)

        ts.status = :concept
        ts.save

        work_set.works.reload

        expect(work_set.works.first.availability_status).to eq(:available)
        expect(work_set.works.first.removed_from_collection?).to eq(false)
      end

      it "results in underlying works to become available when ended" do
        work_set = work_sets(:random_other_collection)
        ts = TimeSpan.create(subject: work_set, collection: works(:work1).collection.base_collection, contact: contacts(:contact1), starts_at: Time.now, status: :active, classification: :rental_outgoing)
        expect(ts.time_spans.count).to eq(work_set.works.count)

        work_set.works.reload

        expect(work_set.works.first.availability_status).to eq(:lent)
        expect(work_set.works.first.removed_from_collection?).to eq(false)

        ts.end_time_span!

        work_set.works.reload

        expect(work_set.works.first.availability_status).to eq(:available)
        expect(work_set.works.first.removed_from_collection?).to eq(false)

        work_set.works.reload

        work_set.works.update_all(for_purchase_at: nil)
        work_set.works.reload

        expect(work_set.works.first.availability_status).to eq(:available_not_for_rent_or_purchase)
        expect(work_set.works.first.removed_from_collection?).to eq(false)
      end
    end
  end

  describe "instance methods" do
    describe "#current?" do
      [:time_span1, :time_span2, :time_span3, :time_span4].each do |span|
        it { expect(time_spans(span).current?).to be_truthy }
      end
      [:time_span_historic, :time_span_future].each do |span|
        it { expect(time_spans(span).current?).not_to be_truthy }
      end

      it "should include expired, active time spans" do
        expect(time_spans(:time_span_expired).current?).to be_truthy
      end
    end

    describe "#finished?" do
      [:time_span1, :time_span2, :time_span3, :time_span4, :time_span_future, :time_span_expired].each do |span|
        it { expect(time_spans(span).finished?).to be_falsey }
      end
      [:time_span_historic].each do |span|
        it { expect(time_spans(span).finished?).not_to be_falsey }
        it { expect(time_spans(span).current_and_active?).to be_falsey }
      end
    end
  end

  describe "scopes" do
    describe ".current" do
      [:time_span1, :time_span2, :time_span3, :time_span4].each do |span|
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
      [:time_span1, :time_span2, :time_span3, :time_span4].each do |span|
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
