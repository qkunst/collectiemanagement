# frozen_string_literal: true

class AddCollectionAccessibilitySerializationToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :collection_accessibility_serialization, :text
  end
end
