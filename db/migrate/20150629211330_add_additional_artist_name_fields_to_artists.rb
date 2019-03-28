# frozen_string_literal: true

class AddAdditionalArtistNameFieldsToArtists < ActiveRecord::Migration[4.2]
  def change
    add_column :artists, :first_name, :string
    add_column :artists, :prefix, :string
    add_column :artists, :last_name, :string
    remove_column :artists, :name, :string
  end
end
