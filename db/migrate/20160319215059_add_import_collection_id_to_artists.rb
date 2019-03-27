# frozen_string_literal: true

class AddImportCollectionIdToArtists < ActiveRecord::Migration
  def change
    add_column :artists, :import_collection_id, :integer
  end
end
