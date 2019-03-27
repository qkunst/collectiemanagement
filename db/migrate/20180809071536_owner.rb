# frozen_string_literal: true

class Owner < ActiveRecord::Migration[5.1]
  def change
    create_table "owners" do |t|
      t.string "name"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.boolean "hide", default: false
      t.integer "collection_id"
    end
  end
end
