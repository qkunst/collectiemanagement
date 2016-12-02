require 'rails_helper'

RSpec.describe ImportCollection, type: :model do
  describe ".split_strategies" do
    it "should work" do
      expect(ImportCollection.split_strategies[:split_space].call("ad sf")).to eq(["ad","sf"])
      expect(ImportCollection.split_strategies[:split_nothing].call("ad sf")).to eq(["ad sf"])
    end
  end
end
