# frozen_string_literal: true

class AddCachedGeonameIdsToCollections < ActiveRecord::Migration[5.2]
  def change
    add_column :collections, :geoname_ids_cache, :text
    Collection.unscoped.all.each { |c| c.cache_geoname_ids!(true) }
  end
end
