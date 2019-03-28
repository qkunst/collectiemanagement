# frozen_string_literal: true

class AddParentCollectionIdToCollection < ActiveRecord::Migration[4.2]
  def change
    add_column :collections, :parent_collection_id, :integer
  end
end
