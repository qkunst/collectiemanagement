class AddHideToLocations < ActiveRecord::Migration[7.0]
  def change
    add_column :locations, :hide, :boolean
  end
end
