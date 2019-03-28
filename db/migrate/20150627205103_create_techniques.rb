# frozen_string_literal: true

class CreateTechniques < ActiveRecord::Migration[4.2]
  def change
    create_table :techniques do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
