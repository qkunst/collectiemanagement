# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Condition, type: :model do
  describe "class methods" do
    describe ".find_by_name" do
      it "should work" do
        expect(Condition.find_by_name("Goed")).to eq(conditions(:goed))
      end
    end
  end
end
