class AddDerivedWorkAttributesPresentCacheToCollections < ActiveRecord::Migration[7.1]
  def change
    add_column :collections, :derived_work_attributes_present_cache, :text
  end
end
