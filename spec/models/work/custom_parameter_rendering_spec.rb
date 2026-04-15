require_relative "../../rails_helper"

RSpec.describe Work::CustomParameterRendering do
  include ActiveSupport::Testing::TimeHelpers

  let(:work) { Work.new(selling_price: 1000) }

  describe "#business_rent_price_ex_vat" do
    let(:new_date) { Date.new(2026, 5, 1) }

    {nil => nil, 12 => 7, 1000 => 12.4, 1700 => 17, 10000 => 100}.each do |selling_price, rent_price|
      it "returns #{rent_price} when the selling price is #{selling_price}" do
        travel_to(new_date - 1.day) do
          expect(Work.new(selling_price: selling_price).business_rent_price_ex_vat).to eq(rent_price)
        end
      end
    end

    {nil => nil, 12 => 8.5, 1000 => 14, 2000 => 22, 10000 => 110}.each do |selling_price, rent_price|
      it "returns #{rent_price} when the selling price is #{selling_price} when new date is explicitly sent" do
        travel_to(new_date - 1.day) do
          expect(Work.new(selling_price: selling_price).business_rent_price_ex_vat(new_date)).to eq(rent_price)
        end
      end
    end

    context "new price regime" do
      {nil => nil, 12 => 8.5, 1000 => 14, 2000 => 22, 10000 => 110}.each do |selling_price, rent_price|
        it "returns #{rent_price} when the selling price is #{selling_price}" do
          travel_to(new_date) do
            expect(Work.new(selling_price: selling_price).business_rent_price_ex_vat).to eq(rent_price)
          end
        end
      end

      {nil => nil, 12 => 7, 1000 => 12.4, 1700 => 17, 10000 => 100}.each do |selling_price, rent_price|
        it "returns #{rent_price} when the selling price is #{selling_price} and old date is explititly sent" do
          travel_to(new_date) do
            expect(Work.new(selling_price: selling_price).business_rent_price_ex_vat(new_date - 1)).to eq(rent_price)
          end
        end
      end
    end
    # Zakelijk 1mei
    # Huidig tarief Euro 7,00.  Dit verhogen we naar 8,50
    # Huidig tarief Euro 12,40. Dit verhogen we naar Euro 14,00
    # Huidig tarief van 1% van de waarde v.h. werk. Dit verhogen we naar 1,1% van de waarde voor werken vanaf Euro 2.000
  end

  describe "#default_rent_price_ex_vat" do
    let(:new_date) { Date.new(2026, 7, 1) }

    {nil => nil, 12 => 8.75, 1000 => 14, 1700 => 14, 4700 => 40}.each do |selling_price, rent_price|
      it "returns #{rent_price} when the selling price is #{selling_price}" do
        travel_to(new_date - 1.day) do
          expect(Work.new(selling_price: selling_price).default_rent_price).to eq(rent_price)
        end
      end
    end

    {nil => nil, 12 => 9.50, 1000 => 16, 1700 => 16, 4700 => 40, 7500 => nil}.each do |selling_price, rent_price|
      it "returns #{rent_price} when the selling price is #{selling_price} and new date is explicitly sent" do
        travel_to(new_date - 1.day) do
          expect(Work.new(selling_price: selling_price).default_rent_price(new_date)).to eq(rent_price)
        end
      end
    end

    context "new price regime" do
      {nil => nil, 12 => 9.50, 1000 => 16, 1700 => 16, 4700 => 40, 7500 => nil}.each do |selling_price, rent_price|
        it "returns #{rent_price} when the selling price is #{selling_price}" do
          travel_to(new_date) do
            expect(Work.new(selling_price: selling_price).default_rent_price).to eq(rent_price)
          end
        end
      end
    end

    # Particulier 1juli
    # Huidig tarief Euro 8.75.  Dit verhogen we naar 9,50
    # Huidig tarief Euro 14,00. Dit verhogen we naar Euro 16,00
    # Huidig tarief van 1% van de waarde naar 1,1% van de waarde voor werken vanaf Euro 2.000 tot max Euro 40 per mnd.
    # Werken boven Euro 7.500 prijs op aanvraag

    # context ""

    # Voor andere tarieven geldt:
    # Transport van Euro 0,60 per km naar Euro 0,80 per km
    # Art Handling van Euro 50 p.uur naar Euro 60 p.uur
    # Kunstadviseur Euro 80 p.uur
    # Vervoer in Den Haag Euro 30,-- per rit
    # Reiskosten kunstadviseur Euro 0,25 per km
    # *Deze tarieven gelden incl BTW voor particulieren en excl BTW voor bedrijven
  end
end
