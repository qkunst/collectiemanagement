class AddBalanceCategoryIdWorks < ActiveRecord::Migration[6.0]
  def change
    add_column :works, :balance_category_id, :integer
  end
end