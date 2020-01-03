class AddBaseCollectionToCollections < ActiveRecord::Migration[5.2]
  def change
    add_column :collections, :base, :boolean
  end
end
