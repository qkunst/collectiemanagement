class AddReplacedByArtistIdAndOtherStructuredDataToArtists < ActiveRecord::Migration[5.2]
  def change
    add_column :artists, :replaced_by_artist_id, :integer
    add_column :artists, :other_structured_data, :text
  end
end
