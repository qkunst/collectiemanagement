class AddIndexToCollectionIdOnCollectionAttributes < ActiveRecord::Migration[8.0]
  def change
    add_index :collection_attributes, :collection_id
  end
end
