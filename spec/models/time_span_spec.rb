# == Schema Information
#
# Table name: time_spans
#
#  id             :bigint           not null, primary key
#  classification :string
#  ends_at        :datetime
#  starts_at      :datetime
#  status         :string
#  subject_type   :string
#  uuid           :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  collection_id  :bigint
#  contact_id     :bigint
#  subject_id     :bigint
#
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

      it "is not valid when classification is false, but subject, collection and contact are set" do
        ts = TimeSpan.new(subject: work, collection: works(:work1).collection.base_collection, contact: contacts(:contact1), status: :concept, classification: :false_classification)
        expect(ts.valid?).to be_falsey
      end
    end
    context "import failurs" do
      it "should work for all examples" do
        data = [{"contact"=>{"external"=>true, "url"=>"http://localhost:5001/customers/0343df8a-92ed-45bc-893e-bbd424a7015a", "name"=>""}, "starts_at"=>"1997-11-15", "ends_at"=>"2006-06-05", "status"=>"finished", "classification"=>"rental_outgoing"}, {"contact"=>{"external"=>true, "url"=>"http://localhost:5001/customers/4bc1db3d-fc1d-470c-a16f-4a86628fc766", "name"=>""}, "starts_at"=>"2002-11-25", "ends_at"=>"2003-11-28", "status"=>"finished", "classification"=>"rental_outgoing"}, {"contact"=>{"external"=>true, "url"=>"http://localhost:5001/customers/86679f73-bbc4-46aa-bc38-61d9fb2b2ac0", "name"=>""}, "starts_at"=>"2010-10-25", "ends_at"=>"2011-10-25", "status"=>"finished", "classification"=>"rental_outgoing"}, {"contact"=>{"external"=>true, "url"=>"http://localhost:5001/customers/17336a8b-9a88-4c29-a7bc-48d89ecf5579", "name"=>""}, "starts_at"=>"2012-03-20", "ends_at"=>"2013-03-20", "status"=>"finished", "classification"=>"rental_outgoing"}, {"contact"=>{"external"=>true, "url"=>"http://localhost:5001/customers/fb8f7555-d6ae-41f3-b814-3294dff96ce9", "name"=>""}, "starts_at"=>"2020-02-19", "ends_at"=>"2021-02-19", "status"=>"finished", "classification"=>"rental_outgoing"}, {"contact"=>{"external"=>true, "url"=>"http://localhost:5001/customers/"}, "starts_at"=>"2021-08-25", "status"=>"active", "classification"=>"rental_outgoing"}]
        work = works(:work7)
        data.each do |time_span|
          contact = time_span["contact"]["external"] ?
            Contact.find_or_create_by(url: time_span["contact"]["url"]) { |contact| contact.name=time_span["contact"]["name"], contact.address= time_span["contact"]["address"], contact.external = true } :
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
      ts = TimeSpan.create(subject: work, collection: works(:work1).collection.base_collection, contact: contacts(:contact1), status: :concept, classification: :purchase)
      work.reload
      expect(work.removed_from_collection?).to be_falsey


      ts = TimeSpan.create(subject: work, collection: works(:work1).collection.base_collection, contact: contacts(:contact1), status: :active, classification: :purchase)
      work.reload
      expect(work.removed_from_collection?).to be_truthy
    end
  end

  describe "instance methods" do
    describe "#current?" do
      [:time_span1,:time_span2,:time_span3,:time_span4].each do |span|
        it { expect(time_spans(span).current?).to  be_truthy }
      end
      [:time_span_historic, :time_span_future].each do |span|
        it { expect(time_spans(span).current?).not_to  be_truthy }
      end

      it "should include expired, active time spans" do
        expect(time_spans(:time_span_expired).current?).to be_truthy
      end
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
