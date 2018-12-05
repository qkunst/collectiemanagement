class UpdateArtistNameRenderedNowAsJson < ActiveRecord::Migration[5.2]
  def change
    Work.update_artist_name_rendered!
  end
end
