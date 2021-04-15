# frozen_string_literal: true

class AddMinimumBidAndSellingPriceToWorks < ActiveRecord::Migration[5.2]
  def change
    add_column :works, :minimum_bid, :decimal, scale: 2, precision: 16 # nl: startbod
    add_column :works, :selling_price, :decimal, scale: 2, precision: 16 # nl: verkoopprijs
    add_column :works, :print_unknown, :boolean # oplage onbekend
  end
end
