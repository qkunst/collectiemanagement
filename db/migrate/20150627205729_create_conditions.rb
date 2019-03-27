# frozen_string_literal: true

class CreateConditions < ActiveRecord::Migration
  def change
    create_table :conditions do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
