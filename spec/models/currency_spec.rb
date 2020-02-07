# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Currency, type: :model do
  describe "instance methods" do
    describe "#update_conversions" do
      it "should update works" do
        c = currencies(:nlg)
        expect(c.works.first.purchase_price).to eq(100)
        expect(c.works.first.purchase_price_in_eur).to eq(200)
        c.exchange_rate = 3
        c.save
        expect(c.works.first.purchase_price_in_eur).to eq(33.33)
      end
    end
  end
end
