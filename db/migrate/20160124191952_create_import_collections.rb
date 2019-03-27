# frozen_string_literal: true

class CreateImportCollections < ActiveRecord::Migration
  def change
    create_table :import_collections do |t|
      t.integer :collection_id
      t.string :file
      t.text :settings

      t.timestamps null: false
    end
    # to enable rollbacks
    add_column :works, :imported_at, :datetime
    add_column :works, :import_collection_id, :integer
  end
end
