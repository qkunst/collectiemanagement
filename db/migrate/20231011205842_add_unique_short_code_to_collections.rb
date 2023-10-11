class AddUniqueShortCodeToCollections < ActiveRecord::Migration[7.0]
  def change
    add_column :collections, :unique_short_code, :string
    add_index :collections, :unique_short_code, unique: true
  end
end
