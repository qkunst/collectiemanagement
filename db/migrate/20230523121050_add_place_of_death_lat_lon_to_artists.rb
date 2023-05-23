class AddPlaceOfDeathLatLonToArtists < ActiveRecord::Migration[7.0]
  def change
    add_column :artists, :place_of_death_lat, :float
    add_column :artists, :place_of_death_lon, :float
    add_column :artists, :place_of_birth_lat, :float
    add_column :artists, :place_of_birth_lon, :float
  end
end
