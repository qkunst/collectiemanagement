# frozen_string_literal: true

class AddCollectionIdToThemes < ActiveRecord::Migration[4.2]
  def change
    add_column :themes, :collection_id, :integer
  end
end
