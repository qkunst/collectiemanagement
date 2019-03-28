# frozen_string_literal: true

class CreateGeonamesAdmindivs < ActiveRecord::Migration[4.2]
  def change
    create_table :geonames_admindivs do |t|
      t.string :admin_code
      t.string :name
      t.string :asciiname
      t.integer :geonameid
      t.integer :admin_type

      t.timestamps null: false
    end
  end
end
