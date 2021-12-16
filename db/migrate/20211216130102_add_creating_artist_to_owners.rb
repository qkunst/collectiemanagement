class AddCreatingArtistToOwners < ActiveRecord::Migration[6.1]
  def change
    add_column :owners, :creating_artist, :boolean, default: false
    add_column :owners, :description, :text
  end
end
