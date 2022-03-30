# frozen_string_literal: true

class AddExchangeRateToCurrencies2 < ActiveRecord::Migration[5.2]
  def change
    {"USD" => 1.106270, "NLG" => 2.20371}.each do |code, rate|
      c = Currency.find_or_create_by(iso_4217_code: code)
      c.save
      Currency.where(iso_4217_code: code).update_all(exchange_rate: rate)

    end
  end
end
