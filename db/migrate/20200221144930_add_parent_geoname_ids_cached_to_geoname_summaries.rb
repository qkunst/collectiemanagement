class AddParentGeonameIdsCachedToGeonameSummaries < ActiveRecord::Migration[5.2]
  def change
    add_column :geoname_summaries, :parent_geoname_ids_cache, :text
    GeonameSummary.find_each{|gs| gs.cache_parent_geoname_ids!(true)}
  end
end
