class AddIndexToGeonamesSummary < ActiveRecord::Migration[5.0]
  def change
    add_index :geoname_summaries, [:geoname_id, :language]
    add_index :geoname_summaries, :geoname_id
  end
end