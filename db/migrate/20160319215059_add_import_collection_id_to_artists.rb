# frozen_string_literal: true

class AddImportCollectionIdToArtists < ActiveRecord::Migration[4.2]
  def change
    add_column :artists, :import_collection_id, :integer
  end
end
