# frozen_string_literal: true

class AddImportFileSnippetToImportCollections < ActiveRecord::Migration[4.2]
  def change
    add_column :import_collections, :import_file_snippet, :text
  end
end
