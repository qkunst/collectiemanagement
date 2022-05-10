# frozen_string_literal: true

# == Schema Information
#
# Table name: currencies
#
#  id            :bigint           not null, primary key
#  exchange_rate :decimal(16, 8)
#  hide          :boolean          default(FALSE)
#  iso_4217_code :string
#  name          :string
#  symbol        :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
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
