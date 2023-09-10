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
# Indexes
#
#  index_time_spans_on_subject_type_and_subject_id  (subject_type,subject_id)
#  index_time_spans_on_uuid                         (uuid)
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
        TimeSpan.create(subject: work, collection: works(:work1).collection.base_collection, contact: contacts(:contact1), starts_at: Time.now, status: :active, classification: :rental_outgoing)
        work.reload
        ts = TimeSpan.create(subject: work, collection: works(:work1).collection.base_collection, contact: contacts(:contact_internal), starts_at: Time.now, status: :reservation, classification: :rental_outgoing)
        expect(ts.valid?).to be_truthy
        fully_reloaded_work = Work.find(work.id)
        expect(fully_reloaded_work.availability_status).to eq(:lent)
      end

      it "is valid when work was reserved but will now be lent" do
        TimeSpan.create(subject: work, collection: works(:work1).collection.base_collection, contact: contacts(:contact_internal), starts_at: Time.now, status: :reservation, classification: :rental_outgoing)
        work.reload
        ts = TimeSpan.create(subject: work, collection: works(:work1).collection.base_collection, contact: contacts(:contact1), starts_at: Time.now, status: :active, classification: :rental_outgoing)
        expect(ts.valid?).to be_truthy
        fully_reloaded_work = Work.find(work.id)
        expect(fully_reloaded_work.availability_status).to eq(:lent)
      end

      it "is is not valid when work was lent but will now be lent" do
        TimeSpan.create(subject: work, collection: works(:work1).collection.base_collection, contact: contacts(:contact_internal), starts_at: Time.now, status: :active, classification: :rental_outgoing)
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
      TimeSpan.create(subject: work, collection: works(:work1).collection.base_collection, contact: contacts(:contact1), starts_at: Time.now, status: :concept, classification: :purchase)
      work.reload
      expect(work.removed_from_collection?).to be_falsey

      TimeSpan.create(subject: work, collection: works(:work1).collection.base_collection, contact: contacts(:contact1), starts_at: Time.now, status: :active, classification: :purchase)
      work.reload
      expect(work.removed_from_collection?).to be_truthy
    end

    describe "#sync_time_spans_for_works_when_work_set" do
      let(:work_set) { work_sets(:random_other_collection) }
      let(:classification) { :purchase }
      let(:time_span) { TimeSpan.create(subject: work_set, collection: works(:work1).collection.base_collection, contact: contacts(:contact1), starts_at: Time.now, status: :active, classification: classification) }

      it "creates none when a work" do
        ts = TimeSpan.create(subject: work, collection: works(:work1).collection.base_collection, contact: contacts(:contact1), starts_at: Time.now, status: :concept, classification: classification)
        expect(ts.time_spans).to eq([])
      end

      it "creates time spans when for works in a work_set" do
        expect(time_span.time_spans.count).to eq(work_set.works.count)
      end

      it "results in underlying works to be no longer available" do
        time_span

        expect(work_set.works.first.availability_status).to eq(:sold)
        expect(work_set.works.first.removed_from_collection?).to eq(true)
      end

      it "updates contact when time span is updated and time span is connected" do
        time_span.time_spans.first.update(contact: contacts(:contact2))

        time_span.update(contact: contacts(:contact3))
        expect(time_span.time_spans.map(&:contact).uniq).to eq([contacts(:contact3)])
      end

      it "updates the status when work set's time span is updated and time span is connected" do
        time = "2021-04-12T12:00:00+02:00".to_datetime
        expect(time_span.time_spans.map(&:ends_at).uniq).to eq([nil])
        time_span.update(created_at: 1.day.ago, status: :finished, ends_at: time)

        expect(time_span.time_spans.map(&:status).uniq).to eq(["finished"])
        expect(time_span.time_spans.map(&:ends_at).uniq).to eq([time])
      end

      it "doesn't update contact when time span is updated and time span is not connected" do
        work_time_spans = time_span.time_spans
        work_time_span = work_time_spans.first
        work_time_span.update(contact: contacts(:contact2), time_span: nil)

        reloaded_time_span = TimeSpan.find(time_span.id)
        reloaded_time_span.update(contact: contacts(:contact3))

        expect(work_time_spans.map(&:reload).map(&:contact).uniq).to eq([contacts(:contact2), contacts(:contact3)])
      end

      it "disconnects time spans if work is removed from work set" do
        work_time_spans = time_span.time_spans
        work_time_span = work_time_spans.first
        work = work_time_span.subject

        work.work_sets -= [work_set]
        work.save

        reloaded_time_span = TimeSpan.find(time_span.id)
        reloaded_time_span.update(contact: contacts(:contact3))

        expect(work_time_spans.map(&:reload).map(&:time_span).uniq).to include(nil)
        expect(work_time_spans.map(&:reload).map(&:time_span).uniq).to include(time_span)
      end

      describe "#significantly_update_works!" do
        it "significantly updates edit status of works" do
          work = works(:work1)
          work.update_column(:significantly_updated_at, 1.day.ago)
          time_span = TimeSpan.new(subject: work, collection: collections(:collection1), contact: contacts(:contact1), starts_at: Time.now, status: :concept, classification: :rental_outgoing)
          time_span.save
          expect(Work.find(work.id).significantly_updated_at).to be > 1.hour.ago
        end

        it "triggers async reindex of work" do
          work = works(:work1)
          expect(work).to receive(:reindex_async!)
          time_span = TimeSpan.new(subject: work, collection: collections(:collection1), contact: contacts(:contact1), starts_at: Time.now, status: :concept, classification: :rental_outgoing)
          time_span.save
        end
      end

      context "rental outgoing" do
        let(:classification) { :rental_outgoing }

        it "results in underlying works to become available when returned" do
          expect(time_span.time_spans.count).to eq(work_set.works.count)

          work_set.works.reload

          expect(work_set.works.first.availability_status).to eq(:lent)
          expect(work_set.works.first.removed_from_collection?).to eq(false)

          time_span.finish
          time_span.save

          work_set.works.reload

          expect(work_set.works.first.availability_status).to eq(:available)
          expect(work_set.works.first.removed_from_collection?).to eq(false)
        end

        it "results in underlying works to become available when converted to concept" do
          expect(time_span.time_spans.count).to eq(work_set.works.count)

          work_set.works.reload

          expect(work_set.works.first.availability_status).to eq(:lent)
          expect(work_set.works.first.removed_from_collection?).to eq(false)

          time_span.status = :concept
          time_span.save

          work_set.works.reload

          expect(work_set.works.first.availability_status).to eq(:available)
          expect(work_set.works.first.removed_from_collection?).to eq(false)
        end

        it "results in underlying works to become available when ended" do
          expect(time_span.time_spans.count).to eq(work_set.works.count)

          work_set.works.reload

          expect(work_set.works.first.availability_status).to eq(:lent)
          expect(work_set.works.first.removed_from_collection?).to eq(false)

          time_span.end_time_span!

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

    describe "#next_time_span" do
      it "returns the next one for the same subject" do
        expect(time_spans(:time_span1).next_time_span).to eq(time_spans(:time_span2))
        expect(time_spans(:time_span2).next_time_span).to eq(time_spans(:time_span3))
      end

      it "returns nil when no next time span exist" do
        expect(time_spans(:time_span_future).next_time_span).to be_nil
      end
    end
  end

  describe "scopes" do
    describe ".current / .period" do
      [:time_span1, :time_span2, :time_span3, :time_span4].each do |span|
        it { expect(TimeSpan.current).to include time_spans(span) }
        it { expect(TimeSpan.period((Time.current...Time.current))).to include time_spans(span) }
      end
      [:time_span_historic, :time_span_future].each do |span|
        it { expect(TimeSpan.current).not_to include time_spans(span) }
        it { expect(TimeSpan.period((Time.current...Time.current))).not_to include time_spans(span) }
      end

      it "should include expired, active time spans" do
        expect(TimeSpan.current).to include time_spans(:time_span_expired)
        expect(TimeSpan.period((Time.current...Time.current))).to include time_spans(:time_span_expired)
      end

      it "should include all when period is extreme" do
        expect(TimeSpan.period(Date.new(1900, 1, 1)...Date.new(2300, 1, 1)).ids.sort).to eq TimeSpan.all.ids.sort
      end

      it "should include only future and when period is extreme future" do
        period = Time.now...Date.new(2300, 1, 1)
        [:time_span1, :time_span2, :time_span3, :time_span4, :time_span_future].each do |span|
          expect(TimeSpan.period(period)).to include time_spans(span)
        end
        [:time_span_historic].each do |span|
          expect(TimeSpan.period(period)).not_to include time_spans(span)
        end
      end

      it "should include only past and current when period is extreme history till now" do
        period = Date.new(1900, 1, 1)...Time.now
        [:time_span1, :time_span2, :time_span3, :time_span4, :time_span_historic].each do |span|
          expect(TimeSpan.period(period)).to include time_spans(span)
        end
        [:time_span_future].each do |span|
          expect(TimeSpan.period(period)).not_to include time_spans(span)
        end
      end
    end

    describe ".active" do
      [:time_span1, :time_span2, :time_span3, :time_span4].each do |span|
        it { expect(TimeSpan.active).not_to include time_spans(span) }
      end

      %i[time_span_expired time_span_active time_span_collection_with_availability_sold_with_time_span].each do |span|
        it { expect(TimeSpan.active).to include time_spans(span) }
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
