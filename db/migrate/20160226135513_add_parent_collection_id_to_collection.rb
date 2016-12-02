class AddParentCollectionIdToCollection < ActiveRecord::Migration
  def change
    add_column :collections, :parent_collection_id, :integer
  end
end
