# frozen_string_literal: true

class CreateGeonameSummaries < ActiveRecord::Migration
  def change
    create_table :geoname_summaries do |t|
      t.integer :geoname_id
      t.string :name
      t.string :language
      t.string :parent_description
      t.string :type_code

      t.timestamps null: false
    end
  end
end
