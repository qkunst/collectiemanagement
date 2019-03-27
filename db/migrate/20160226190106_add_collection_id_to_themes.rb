# frozen_string_literal: true

class AddCollectionIdToThemes < ActiveRecord::Migration
  def change
    add_column :themes, :collection_id, :integer
  end
end
