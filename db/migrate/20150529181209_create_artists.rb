# frozen_string_literal: true

class CreateArtists < ActiveRecord::Migration[4.2]
  def change
    create_table :artists do |t|
      t.string :name
      t.string :place_of_birth
      t.string :place_of_death
      t.integer :year_of_birth
      t.integer :year_of_death
      t.text :description
      t.timestamps null: false
    end
  end
end
