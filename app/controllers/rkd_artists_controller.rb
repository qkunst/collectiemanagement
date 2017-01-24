class RkdArtistsController < ApplicationController
  before_action :authenticate_admin_user!
  def show
    @rkd_artist = RkdArtist.find_by_rkd_id!(params[:id])
    @artist = Artist.find_by_id(params[:artist_id]) if params[:artist_id]
    @new_artist = @rkd_artist.to_artist
    @show_full_artists = true
  end
  def copy
    @rkd_artist = RkdArtist.find_by_rkd_id!(params[:rkd_artist_id])
    @new_artist = @rkd_artist.to_artist
    @artist = Artist.find_by_id(params[:artist_id]) if params[:artist_id]
    @artist.import!(@new_artist)
    redirect_to @artist, notice: "De gegevens zijn bijgewerkt met de gegevens uit het RKD."
  end
end
