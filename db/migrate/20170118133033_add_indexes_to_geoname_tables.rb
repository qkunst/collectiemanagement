class AddIndexesToGeonameTables < ActiveRecord::Migration[5.0]
  def change
    add_index :geoname_translations, :geoname_id
    add_index :geonames_admindivs, :admin_code
  end
end