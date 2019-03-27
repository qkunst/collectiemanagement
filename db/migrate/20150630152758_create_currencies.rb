# frozen_string_literal: true

class CreateCurrencies < ActiveRecord::Migration
  def change
    create_table :currencies do |t|
      t.string :iso_4217_code
      t.string :symbol

      t.timestamps null: false
    end
    add_column :works, :purchase_price_currency_id, :integer

  end
end
