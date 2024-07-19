class AddWorkAttributesPresentCacheToCollections < ActiveRecord::Migration[7.1]
  def change
    add_column :collections, :work_attributes_present_cache, :text
  end
end
