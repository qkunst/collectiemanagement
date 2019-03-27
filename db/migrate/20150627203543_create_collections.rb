# frozen_string_literal: true

class CreateCollections < ActiveRecord::Migration
  def change
    create_table :collections do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
