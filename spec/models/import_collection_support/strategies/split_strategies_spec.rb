require 'rails_helper'

RSpec.describe ImportCollection::Strategies::SplitStrategies, type: :model do
  describe "class methods" do
    describe ".split_space" do
      it "should work" do
        expect(ImportCollection::Strategies::SplitStrategies.split_space("ad sf")).to eq(["ad","sf"])
        expect(ImportCollection::Strategies::SplitStrategies.split_nothing("ad sf")).to eq(["ad sf"])
      end
    end
  end
end
