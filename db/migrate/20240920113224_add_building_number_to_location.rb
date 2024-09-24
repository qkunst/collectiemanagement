class AddBuildingNumberToLocation < ActiveRecord::Migration[7.1]
  def change
    add_column :locations, :building_number, :string
  end
end
