# frozen_string_literal: true

class AddCollectionNameExtendedCacheToCollections < ActiveRecord::Migration[5.2]
  def change
    add_column :collections, :collection_name_extended_cache, :text
    Collection.all.each { |c| c.cache_collection_name_extended!(true) }
  end
end
