# frozen_string_literal: true

class AddCollectionLocalityArtistInvolvementsTextsCacheToWorks < ActiveRecord::Migration[5.2]
  def change
    add_column :works, :collection_locality_artist_involvements_texts_cache, :text
    Work.all.each{|c| c.cache_collection_locality_artist_involvements_texts!(true)}

  end
end
