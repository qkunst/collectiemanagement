# frozen_string_literal: true

class AddExposableFieldsToCollection < ActiveRecord::Migration[4.2]
  def change
    add_column :collections, :exposable_fields, :text
    add_column :collections, :description, :text
  end
end
