class AddGeonameIdsToGeonameSummaries < ActiveRecord::Migration[5.0]
  def change
    add_column :geoname_summaries, :geoname_ids, :string
    GeonameSummary.all.each do |gs|
      gs.geoname_ids = (gs.parent_geoname_ids + [gs.geoname_id])
      gs.save
    end
  end
end
