class AddIndexToCollectionIdInWorks < ActiveRecord::Migration[5.2]
  def change
    add_index :works, :collection_id
  end
end
