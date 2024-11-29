# frozen_string_literal: true

class RKD::ArtistsController < ApplicationController
  # before_action :authenticate_admin_user!
  before_action :set_collection
  before_action :set_artist

  def index
    @q = params[:q]
    @rkd_artists = RKD::Artist.search(params[:q] || @artist.name)
  end

  def show
    @rkd_artist = RKD::Artist.find(params[:id])
    authorize! :show, @rkd_artist
    @new_artist = Artist.initialize_from_rkd_artist(@rkd_artist)
    @show_full_artists = true
  end

  def copy
    @rkd_artist = RKD::Artist.find_by_rkd_id!(params[:rkd_artist_id])
    authorize! :copy, @rkd_artist
    @new_artist = @rkd_artist.to_artist
    @artist.import!(@new_artist)
    redirect_to [@collection, @artist], notice: "De gegevens zijn bijgewerkt met de gegevens uit het RKD."
  end

  def update
    @rkd_artist = RKD::Artist.find_by_rkd_id!(params[:rkd_artist_id])
    @artist = Artist.find_by_id(params[:artist_id]) if params[:artist_id]
  end

  private

  def set_artist
    if params[:artist_id]
      @artist = Artist.find_by_id(params[:artist_id])
      authorize! :show, @artist
    end
  end
end
