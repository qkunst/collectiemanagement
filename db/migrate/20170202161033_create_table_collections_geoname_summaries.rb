# frozen_string_literal: true

class CreateTableCollectionsGeonameSummaries < ActiveRecord::Migration[5.0]
  def change
    create_table :collections_geoname_summaries do |t|
      t.integer :collection_id
      t.integer :geoname_id
    end
  end
end
