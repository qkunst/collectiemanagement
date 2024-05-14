require_relative "../../rails_helper"

RSpec.describe Work::CustomParameterRendering do
  let(:work) { Work.new(selling_price: 1000) }

  describe "#business_rent_price_ex_vat" do
    it "doesn't return anything when selling price is nil" do
      expect(Work.new(selling_price: nil).business_rent_price_ex_vat).to be_nil
    end
    it "works for other pairs" do
      {12 => 7, 1000 => 12.4, 1700 => 17, 4700 => 47}.each do |selling_price, rent_price|
        expect(Work.new(selling_price: selling_price).business_rent_price_ex_vat).to eq(rent_price)
      end
    end
  end

  describe "#default_rent_price_ex_vat" do
    it "doesn't return anything when selling price is nil" do
      expect(Work.new(selling_price: nil).default_rent_price).to be_nil
    end
    it "works for other pairs" do
      {12 => 8.75, 1000 => 14, 1700 => 14, 4700 => 47}.each do |selling_price, rent_price|
        expect(Work.new(selling_price: selling_price).default_rent_price).to eq(rent_price)
      end
    end
  end
end
