# frozen_string_literal: true

class AddGeonameIdToArtists < ActiveRecord::Migration[5.0]
  def change
    add_column :artists, :place_of_death_geoname_id, :integer
    add_column :artists, :place_of_birth_geoname_id, :integer
  end
end
