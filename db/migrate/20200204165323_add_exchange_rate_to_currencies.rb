# frozen_string_literal: true

class AddExchangeRateToCurrencies < ActiveRecord::Migration[5.2]
  def change
    add_column :currencies, :exchange_rate, :decimal, precision: 16, scale: 8
    add_column :works, :purchase_price_in_eur, :decimal, precision: 16, scale: 2

    Currency.where(iso_4217_code: "EUR").update_all(exchange_rate: 1)

    {"USD" => 1.106270, "NLG" => 2.20371}.each do |code, rate|
      c = Currency.find_by(iso_4217_code: code)
      c.exchange_rate = rate
      c.save
    end
  end
end
