class CreateRdkArtists < ActiveRecord::Migration[5.0]
  def change
    create_table :rdk_artists do |t|
      t.integer :rkd_id
      t.string :name
      t.string :api_response
      t.string :api_response_source_url

      t.timestamps
    end
    add_column :artists, :rdk_artist_id, :integer
  end
end