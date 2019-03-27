# frozen_string_literal: true

class AddPlaceToArtistInvolvements < ActiveRecord::Migration[5.0]
  def change
    add_column :artist_involvements, :place, :string
    add_column :artist_involvements, :place_geoname_id, :integer
  end
end
