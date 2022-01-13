class AddRemovedFromCollectionToWorks < ActiveRecord::Migration[6.1]
  def change
    add_column :works, :removed_from_collection_at, :datetime
    add_column :works, :removed_from_collection_note, :string
  end
end
