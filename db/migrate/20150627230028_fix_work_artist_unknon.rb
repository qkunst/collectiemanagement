# frozen_string_literal: true

class FixWorkArtistUnknon < ActiveRecord::Migration[4.2]
  def change
    remove_column :works, :artist_unknown
    add_column :works, :artist_unknown, :boolean
  end
end
