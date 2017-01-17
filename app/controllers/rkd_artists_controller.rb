class RkdArtistsController < ApplicationController
  before_action :authenticate_admin_user!
  def show
    @rkd_artist = RkdArtist.find_by_rkd_id!(params[:id])
    @artist = Artist.find_by_id(params[:artist_id]) if params[:artist_id]
  end
end
