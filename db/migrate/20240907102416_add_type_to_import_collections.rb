class AddTypeToImportCollections < ActiveRecord::Migration[7.1]
  def change
    add_column :import_collections, :type, :string, default: "ImportCollection"
  end
end
