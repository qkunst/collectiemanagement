# frozen_string_literal: true

class RKD::ArtistsController < ApplicationController
  before_action :set_collection
  before_action :set_artist

  def index
    authorize! :index, RKD::Artist
    @q = params[:q]
    @rkd_artists = RKD::Artist.search(params[:q] || @artist&.name)
  end

  def show
    authorize! :show, @rkd_artist
    @new_artist = ::Artist.initialize_from_rkd_artist(@rkd_artist)
    @show_full_artists = true
  end

  def copy
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
    if (rkd_artist_id = params[:rkd_artist_id] || params[:id])
      @rkd_artist = RKD::Artist.find(rkd_artist_id)
    end

    if params[:artist_id]
      @artist = Artist.find_by_id(params[:artist_id])
      authorize! :show, @artist
    end
  rescue RKD::Artist::NotFoundError => e
    raise ActiveRecord::RecordNotFound.new("rkd artist with  not found (#{e.message})")
  end
end
