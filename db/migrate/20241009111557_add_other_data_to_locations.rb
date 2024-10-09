class AddOtherDataToLocations < ActiveRecord::Migration[7.1]
  def change
    add_column :locations, :other_structured_data, :text
  end
end
