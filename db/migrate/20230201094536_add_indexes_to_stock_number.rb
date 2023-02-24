class AddIndexesToStockNumber < ActiveRecord::Migration[7.0]
  def change
    add_index :works, :stock_number, unique: false
    add_index :works, :alt_number_1, unique: false
    add_index :works, :alt_number_2, unique: false
    add_index :works, :alt_number_3, unique: false
  end
end
