# frozen_string_literal: true

class CreateLibraryItems < ActiveRecord::Migration[5.2]
  def change
    create_table :library_items do |t|
      t.string :item_type
      t.integer :collection_id
      t.string :title
      t.string :author
      t.string :ean
      t.string :stock_number
      t.string :location
      t.text :description
      t.string :thumbnail

      t.timestamps
    end

    create_join_table :library_items, :works
    create_join_table :library_items, :artists
  end
end
