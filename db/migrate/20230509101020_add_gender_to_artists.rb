class AddGenderToArtists < ActiveRecord::Migration[7.0]
  def change
    add_column :artists, :gender, :string
  end
end
