require 'rails_helper'

RSpec.describe User, type: :model do
  describe "methods" do
    describe "#roles" do
      it "should return read_only by default" do
        u = User.new
        expect(u.roles).to eq([:read_only])
      end
      it "should return read_only by default" do
        u = users(:admin)
        expect(u.roles).to eq([:admin, :qkunst, :read_only])
      end
    end
    pending "#collection_accessibility_log" do
      u = User.new
      u.save
      u.reload
      expect(u.collection_accessibility_serialization).to eq({})
    end
    describe "#role" do
      it "should return read_only by default" do
        u = User.new
        expect(u.role).to eq(:read_only)
      end
      it "should return read_only by default" do
        u = users(:admin)
        expect(u.role).to eq(:admin)
      end
    end
  end
  describe "Class methods" do
  end
  describe "Scopes" do
  end
end
