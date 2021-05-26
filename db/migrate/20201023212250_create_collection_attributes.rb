# frozen_string_literal: true

class CreateCollectionAttributes < ActiveRecord::Migration[5.2]
  def change
    create_table :collection_attributes do |t|
      t.string :value_ciphertext
      t.integer :collection_id
      t.string :attributed_type
      t.string :attributed_id
      t.string :label

      t.timestamps
    end
  end
end
