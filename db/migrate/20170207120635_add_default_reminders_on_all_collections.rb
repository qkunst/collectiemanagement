# frozen_string_literal: true

class AddDefaultRemindersOnAllCollections < ActiveRecord::Migration[5.0]
  def change
    create_table :frame_types do |t|
      t.string :name
      t.boolean :hide

      t.timestamps
    end
    create_table "owners" do |t|
      t.string "name"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.boolean "hide", default: false
      t.integer "collection_id"
    end
    Collection.all.each do |c|
      c.copy_default_reminders!
    end
    drop_table :owners
    drop_table :frame_types
  end
end
