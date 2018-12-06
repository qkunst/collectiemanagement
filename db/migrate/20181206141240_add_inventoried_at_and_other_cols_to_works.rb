class AddInventoriedAtAndOtherColsToWorks < ActiveRecord::Migration[5.2]
  def change
    add_column :works, :inventoried_at, :datetime
    add_column :works, :refound_at, :datetime
    add_column :works, :new_found_at, :datetime
  end
end
