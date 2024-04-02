class AddCommercialToCollections < ActiveRecord::Migration[7.1]
  def change
    add_column :collections, :commercial, :boolean
  end
end
