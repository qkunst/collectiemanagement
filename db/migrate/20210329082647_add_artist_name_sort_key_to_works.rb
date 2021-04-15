# frozen_string_literal: true

class AddArtistNameSortKeyToWorks < ActiveRecord::Migration[6.1]
  def change
    add_column :works, :artist_name_for_sorting, :string
  end
end
