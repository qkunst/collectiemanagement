# frozen_string_literal: true

require "rails_helper"

RSpec.describe Currency, type: :model do
  describe "instance methods" do
    describe "#update_conversions" do
      it "should update works" do
        c = currencies(:nlg)
        w = c.works.first
        expect(w.purchase_price).to eq(100)
        expect(w.purchase_price_in_eur).to eq(200)
        c.exchange_rate = 3
        c.save
        w.reload
        expect(w.purchase_price_in_eur).to eq(33.33)
      end
    end
  end
end
