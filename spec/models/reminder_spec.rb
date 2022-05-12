# frozen_string_literal: true

# == Schema Information
#
# Table name: reminders
#
#  id              :bigint           not null, primary key
#  interval_length :integer
#  interval_unit   :string
#  name            :string
#  repeat          :boolean
#  text            :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  collection_id   :bigint
#  stage_id        :bigint
#
require "rails_helper"

RSpec.describe Reminder, type: :model do
  describe "methods" do
    describe "#additional_time" do
      it "should work for all time intervals in INTERVAL_UNITS" do
        Reminder::INTERVAL_UNITS.each do |a, v|
          expect(Reminder.new(interval_unit: v, interval_length: 1).additional_time).to be > 0.seconds
        end
      end
    end
    describe "reference_date" do
      it "should be the created at date by default" do
        r = Reminder.create(interval_unit: :year, interval_length: 10, name: "Naam")
        expect(r.reference_date).to eq(r.created_at.to_date)
      end
      it "should return nil when stage is set and no collection has no stages" do
        c = collections(:collection1)
        s1 = stages(:stage1)
        r = Reminder.create(interval_unit: :year, interval_length: 10, name: "Naam", stage: s1, collection: c)
        expect(r.reference_date).to eq(nil)
      end
    end
    describe "#last_sent_at" do
      it "should return nil by default" do
        c = collections(:collection_with_stages)
        r = Reminder.create(interval_unit: :year, interval_length: 10, name: "Naam", collection: c)
        expect(r.last_sent_at).to eq(nil)
      end
      it "should return nil by default" do
        c = collections(:collection_with_stages)
        r = Reminder.create(interval_unit: :year, interval_length: 10, name: "Naam", collection: c)
        r.to_message!
        expect(r.last_sent_at.to_date).to eq(Time.now.to_date)
      end
    end
    describe "#next_dates / #next_date" do
      it "should return one date for non repeating" do
        c = collections(:collection_with_stages)
        r = Reminder.create(interval_unit: :year, interval_length: 10, name: "Naam", collection: c)
        expect(r.next_dates).to eq([(r.created_at + 10.years).to_date])
      end
      it "should return one date for non repeating" do
        c = collections(:collection_with_stages)
        s1 = stages(:stage1)
        r = Reminder.create(interval_unit: :year, interval_length: 50, name: "Naam", collection: c, stage: s1)
        expect(r.next_dates).to eq([("2000-01-01T12:00".to_time + 50.years).to_date])
        expect(r.next_date).to eq(("2000-01-01T12:00".to_time + 50.years).to_date)
      end
      it "should return an empty array if the next date for non repeating has already passed" do
        c = collections(:collection_with_stages)
        s1 = stages(:stage1)
        r = Reminder.create(interval_unit: :year, interval_length: 1, name: "Naam", collection: c, stage: s1)
        expect(r.next_dates).to eq([])
        expect(r.next_date).to eq(nil)
      end
      it "should return 10 dates for non repeating" do
        c = collections(:collection_with_stages)
        s1 = stages(:stage1)
        r = Reminder.create(interval_unit: :year, interval_length: 50, name: "Naam", collection: c, stage: s1, repeat: true)
        expect(r.next_dates).to eq([
          ("2000-01-01T12:00".to_time + 50.years).to_date,
          ("2000-01-01T12:00".to_time + 100.years).to_date,
          ("2000-01-01T12:00".to_time + 150.years).to_date,
          ("2000-01-01T12:00".to_time + 200.years).to_date,
          ("2000-01-01T12:00".to_time + 250.years).to_date,
          ("2000-01-01T12:00".to_time + 300.years).to_date,
          ("2000-01-01T12:00".to_time + 350.years).to_date,
          ("2000-01-01T12:00".to_time + 400.years).to_date,
          ("2000-01-01T12:00".to_time + 450.years).to_date,
          ("2000-01-01T12:00".to_time + 500.years).to_date
        ])
        expect(r.next_date).to eq(("2000-01-01T12:00".to_time + 50.years).to_date)
      end
      it "should return today for event that triggers today" do
        c = collections(:collection_with_stages)
        s1 = stages(:stage1)
        r = Reminder.create(interval_unit: :year, interval_length: 1, name: "Naam", collection: c, stage: s1, repeat: true)

        next_first_jan = (Time.now.beginning_of_year + 1.year).to_date

        expect(r.next_dates).to eq([
          next_first_jan,
          next_first_jan + 1.year,
          next_first_jan + 2.year,
          next_first_jan + 3.year,
          next_first_jan + 4.year,
          next_first_jan + 5.year,
          next_first_jan + 6.year,
          next_first_jan + 7.year,
          next_first_jan + 8.year,
          next_first_jan + 9.year
        ])
      end
      it "should return today for singular event that triggers today" do
        c = collections(:collection_with_stages)
        s1 = stages(:stage1)
        cs1 = c.find_state_of_stage(s1)
        cs1.completed_at = Time.now - 1.day
        r = Reminder.create(interval_unit: :day, interval_length: 1, name: "Naam", collection: c, stage: s1, repeat: false)
        expect(r.next_dates).to eq([
          Time.now.to_date
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
        expect(r.next_date).to eq(nil)
      end
    end
    describe "#to_message" do
      it "should return nil if no collection is given" do
        r = Reminder.create(interval_unit: :year, interval_length: 10, name: "Naam")
        expect(r.to_message).to eq(nil)
      end
      it "should return message if collection is given" do
        c = collections(:collection_with_stages)
        r = Reminder.create(interval_unit: :year, interval_length: 10, name: "Naam", text: "Uitgebreid bericht", collection: c)
        allow(r).to receive(:current_time).and_return r.created_at
        expect(r.to_message.to_json).to eq(Message.new(
          subject: "Herinnering: Naam",
          message: "Uitgebreid bericht",
          created_at: r.created_at,
          qkunst_private: true,
          subject_object: c,
          reminder: r,
          from_user_name: "QKunst Collectiemanagement Herinneringen"
        ).to_json)
      end
      it "should inform all admins" do
        c = collections(:collection_with_stages)
        r = Reminder.create(interval_unit: :year, interval_length: 10, name: "Naam", text: "Uitgebreid bericht", collection: c)
        allow(r).to receive(:current_time).and_return r.created_at
        expect(r.to_message.notifyable_users.map(&:email)).to match_array(["qkunst-admin-user@murb.nl", "qkunst-super-admin-user@murb.nl"])
      end
    end
    describe "#to_message!" do
      it "should return nil if no collection is given" do
        message_count_before = Message.count
        r = Reminder.create(interval_unit: :year, interval_length: 10, name: "Naam")
        expect(r.to_message!).to eq(nil)
        expect(Message.count).to eq(message_count_before)
      end
      it "should return message if collection is given" do
        message_count_before = Message.count
        c = collections(:collection_with_stages)
        r = Reminder.create(interval_unit: :year, interval_length: 10, name: "Naam", text: "Uitgebreid bericht", collection: c)
        expect(r.to_message!.class).to be_truthy
        expect(Message.count).to eq(message_count_before + 1)
      end
    end
    describe "#send_message_if_current_date_is_next_date!" do
      it "should not send any message when next_date is not equal to now" do
        message_count_before = Message.count
        c = collections(:collection_with_stages)
        r = Reminder.create(interval_unit: :year, interval_length: 50, name: "Naam", collection: c)
        expect(r.current_date).to eq(Time.now.to_date)
        expect(r.next_date).to eq((Time.now + 50.years).to_date)
        expect(r.send_message_if_current_date_is_next_date!).to eq(nil)
        expect(Message.count).to eq(message_count_before)
      end
      it "should send any message when next_date is equal to now" do
        message_count_before = Message.count
        c = collections(:collection_with_stages)
        r = Reminder.create(interval_unit: :year, interval_length: 50, name: "Naam", collection: c)
        allow(r).to receive(:current_date).and_return (r.created_at + 50.years).to_date
        expect(r.current_date).to eq((r.created_at + 50.years).to_date)
        expect(r.next_date).to eq((r.created_at + 50.years).to_date)
        expect(r.send_message_if_current_date_is_next_date!).to eq(true)
        expect(Message.count).to eq(message_count_before + 1)
      end
      it "should not double send any message when next_date is equal to now" do
        message_count_before = Message.count
        c = collections(:collection_with_stages)
        r = Reminder.create(interval_unit: :year, interval_length: 50, name: "Naam", collection: c)
        allow(r).to receive(:current_time).and_return(r.created_at + 50.years)
        expect(r.current_date).to eq((r.created_at + 50.years).to_date)
        expect(r.next_date).to eq((r.created_at + 50.years).to_date)
        expect(r.send_message_if_current_date_is_next_date!).to eq(true)
        expect(Message.count).to eq(message_count_before + 1)
        expect(r.current_date).to eq((r.created_at + 50.years).to_date)
        expect(r.next_date).to eq((Time.now + 50.years).to_date)
        expect(Message.where(reminder: r).count).to eq(1)
        expect(Message.where(reminder: r).first.created_at.to_date).to eq((r.created_at + 50.years).to_date)
        expect(r.send_message_if_current_date_is_next_date!).to eq(nil)
        expect(Message.count).to eq(message_count_before + 1)
      end
    end
  end
end
