class RenameTableRkdArtistsToRkdArtists < ActiveRecord::Migration[5.0]
  def change
    rename_table :rdk_artists, :rkd_artists
    rename_column :artists, :rdk_artist_id, :rkd_artist_id
    add_index :rkd_artists, :rkd_id
  end
end