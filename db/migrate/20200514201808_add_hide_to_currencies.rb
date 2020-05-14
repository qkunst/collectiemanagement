class AddHideToCurrencies < ActiveRecord::Migration[5.2]
  def change
    add_column :currencies, :hide, :boolean, default: false
  end
end
