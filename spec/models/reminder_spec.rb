require 'rails_helper'

RSpec.describe Reminder, type: :model do
  describe "methods" do
    describe "#additional_time" do
      it "should work for all time intervals in INTERVAL_UNITS" do
        Reminder::INTERVAL_UNITS.each do |a,v|
          expect(Reminder.new(interval_unit: v, interval_length: 1).additional_time).to be > 0.seconds
        end
      end
    end
    describe "#next_dates" do
      it "should return one date for non repeating" do
        c = collections(:collection_with_stages)
        r = Reminder.create(interval_unit: :year, interval_length: 10, name: "Naam", collection: c)
        expect(r.next_dates).to eq([(r.created_at+10.years).to_date])
      end
      it "should return one date for non repeating" do
        c = collections(:collection_with_stages)
        s1 = stages(:stage1)
        r = Reminder.create(interval_unit: :year, interval_length: 50, name: "Naam", collection: c, stage: s1)
        expect(r.next_dates).to eq([("2000-01-01T12:00".to_time+50.years).to_date])
      end
      it "should return an empty array if the next date for non repeating has already passed" do
        c = collections(:collection_with_stages)
        s1 = stages(:stage1)
        r = Reminder.create(interval_unit: :year, interval_length: 1, name: "Naam", collection: c, stage: s1)
        expect(r.next_dates).to eq([])
      end
      it "should return 10 dates for non repeating" do
        c = collections(:collection_with_stages)
        s1 = stages(:stage1)
        r = Reminder.create(interval_unit: :year, interval_length: 50, name: "Naam", collection: c, stage: s1, repeat: true)
        expect(r.next_dates).to eq([
          ("2000-01-01T12:00".to_time+50.years).to_date,
          ("2000-01-01T12:00".to_time+100.years).to_date,
          ("2000-01-01T12:00".to_time+150.years).to_date,
          ("2000-01-01T12:00".to_time+200.years).to_date,
          ("2000-01-01T12:00".to_time+250.years).to_date,
          ("2000-01-01T12:00".to_time+300.years).to_date,
          ("2000-01-01T12:00".to_time+350.years).to_date,
          ("2000-01-01T12:00".to_time+400.years).to_date,
          ("2000-01-01T12:00".to_time+450.years).to_date,
          ("2000-01-01T12:00".to_time+500.years).to_date
        ])
      end
      it "should return nil for event that hasn't passed yet" do
        c = collections(:collection_with_stages)
        s2 = stages(:stage2a)
        r = Reminder.create(interval_unit: :year, interval_length: 50, name: "Naam", collection: c, stage: s2)
        expect(r.next_dates).to eq(nil)
      end
      it "should return nil if no collection is given" do
        r = Reminder.create(interval_unit: :year, interval_length: 10, name: "Naam")
        expect(r.next_dates).to eq(nil)
      end
    end
  end
end
