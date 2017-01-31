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
  end
end
