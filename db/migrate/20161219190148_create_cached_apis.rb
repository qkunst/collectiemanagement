# frozen_string_literal: true

class CreateCachedApis < ActiveRecord::Migration[5.0]
  def change
    create_table :cached_apis do |t|
      t.string :query
      t.text :response

      t.timestamps
    end
  end
end
