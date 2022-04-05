class AddOldDataToWorks < ActiveRecord::Migration[6.1]
  def change
    add_column :works, :old_data, :text
  end
end
