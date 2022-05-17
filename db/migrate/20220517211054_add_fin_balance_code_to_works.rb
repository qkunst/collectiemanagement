class AddFinBalanceCodeToWorks < ActiveRecord::Migration[6.1]
  def change
    add_column :works, :fin_balance_item_id, :string
  end
end
