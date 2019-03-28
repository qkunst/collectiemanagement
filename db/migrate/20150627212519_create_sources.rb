# frozen_string_literal: true

class CreateSources < ActiveRecord::Migration[4.2]
  def change
    create_table :sources do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
