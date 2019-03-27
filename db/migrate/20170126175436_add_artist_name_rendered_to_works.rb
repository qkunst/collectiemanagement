# frozen_string_literal: true

class AddArtistNameRenderedToWorks < ActiveRecord::Migration[5.0]
  def change
    add_column :works, :artist_name_rendered, :string
    add_index :artists_works, :work_id
  end
end
