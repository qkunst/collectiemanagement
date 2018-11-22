class AddCachedGeonameIdsToArtists < ActiveRecord::Migration[5.2]
  def change
    add_column :artists, :geoname_ids_cache, :text
    Artist.all.each{|artist| artist.cache_geoname_ids!(true)}
  end
end
