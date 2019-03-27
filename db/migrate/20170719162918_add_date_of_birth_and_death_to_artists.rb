# frozen_string_literal: true

class AddDateOfBirthAndDeathToArtists < ActiveRecord::Migration[5.0]
  def change
    add_column :artists, :date_of_birth, :date
    add_column :artists, :date_of_death, :date
  end
end
