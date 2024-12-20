class AddAlternativeNamesToArtists < ActiveRecord::Migration[7.2]
  def change
    add_column :artists, :name_variants, :string, array: true, default: []
  end
end
