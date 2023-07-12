class ChangeLocationsAddressToText < ActiveRecord::Migration[7.0]
  def self.up
    change_column :locations, :address, :text
  end

  def self.down
    change_column :locations, :address, :string
  end
end
