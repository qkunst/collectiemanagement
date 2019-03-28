# frozen_string_literal: true

class CreateWorks < ActiveRecord::Migration[4.2]
  def change
    create_table :works do |t|
      t.integer :collection_id
      t.string :created_by
      t.string :location
      t.string :stock_number
      t.string :alt_number_1
      t.string :alt_number_2
      t.string :alt_number_3
      t.string :photo_front
      t.string :photo_back
      t.string :photo_detail_1
      t.string :photo_detail_2
      t.string :artist_unknown
      t.string :title
      t.boolean :title_unknown
      t.text :description
      t.integer :object_creation_year
      t.boolean :object_creation_year_unknown
      t.integer :medium_id
      t.text :signature_comments
      t.boolean :no_signature_present
      t.string :print
      t.float :frame_height
      t.float :frame_width
      t.float :frame_depth
      t.float :frame_diameter
      t.float :height
      t.float :width
      t.float :depth
      t.float :diameter
      t.integer :condition_work_id
      t.text :condition_work_comments
      t.integer :condition_frame_id
      t.text :condition_frame_comments
      t.text :information_back
      t.text :other_comments
      t.integer :source_id
      t.text :source_comments
      t.integer :style_id
      t.integer :subset_id
      t.float :market_value
      t.float :replacement_value
      t.float :purchase_price
      t.text :price_reference
      t.string :grade_within_collection

      t.timestamps null: false
    end
  end
end
