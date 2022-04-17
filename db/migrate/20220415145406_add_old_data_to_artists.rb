class AddOldDataToArtists < ActiveRecord::Migration[6.1]
  def change
    add_column :artists, :old_data, :text
  end
end
