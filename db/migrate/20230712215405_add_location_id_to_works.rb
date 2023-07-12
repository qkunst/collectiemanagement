class AddLocationIdToWorks < ActiveRecord::Migration[7.0]
  def change
    add_column :works, :main_location_id, :integer
  end
end
