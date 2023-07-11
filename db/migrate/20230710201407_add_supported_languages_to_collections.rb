class AddSupportedLanguagesToCollections < ActiveRecord::Migration[7.0]
  def change
    add_column :collections, :supported_languages, :text, array: true, default: [:nl]
    add_column :collections, :default_collection_attributes_for_artists, :text, array: true, default: [:website, :email, :telephone_number, :description]
    add_column :collections, :default_collection_attributes_for_works, :text, array: true, default: []
  end
end
