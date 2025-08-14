# frozen_string_literal: true

class ArtistsController < ApplicationController
  before_action :set_collection
  before_action :authenticate_qkunst_user_if_no_collection!
  before_action :set_new_artist, only: [:new]
  before_action :set_artist, only: [:show, :edit, :update, :destroy, :combine, :combine_prepare, :collectie_nederland_summary, :collectie_nederland_summary_update]
  before_action :retrieve_rkd_artists, only: [:show]
  before_action :authenticate_admin_user_when_no_collection
  before_action :populate_collection_attributes_for_artist, only: [:edit, :new]

  # GET /artists
  # GET /artists.json
  def index
    authorize! :read, Artist
    @advanced = !!params.dig(:display, :advanced)

    if @collection
      @artists = @collection.artists(works_filter).ransack(params[:filter]).result.order_by_name.distinct.all
      @title = "Vervaardigers in collectie #{@collection.name}"
    else
      authorize! :manage, Artist
      @artists = Artist.ransack(params[:filter]).result.order_by_name.distinct.all
      @title = "Alle vervaardigers"
    end
  end

  # POST
  def clean
    authorize! :clean, Artist

    artist_count_before = Artist.count
    Artist.destroy_all_empty_artists!
    Artist.destroy_all_artists_with_no_name_that_have_works_that_already_belong_to_artists_with_a_name!
    Artist.collapse_by_name!({only_when_created_at_date_is_equal: true})
    artist_count_after = Artist.count

    redirect_to artists_path, notice: ((artist_count_after < artist_count_before) ? "De vervaardigersdatabase is opgeschoond (van #{artist_count_before} vervaardigers naar #{artist_count_after} vervaardigers)!" : "Schoner kunnen we het niet maken. Verder opschonen zal helaas handmatig moeten gebeuren")
  end

  # GET /artists/1
  # GET /artists/1.json
  def show
    authorize! :show, @artist

    @title = @artist.name

    if @collection
      @attachments = @artist.attachments.for_me(current_user).where(collection: @collection.expand_with_child_collections)
      @works = @collection.works_including_child_works.artist(@artist).distinct
    else
      authorize! :manage, Artist
      @attachments = @artist.attachments.for_me(current_user).where(collection: @collection)
      @works = @artist.works.distinct
    end
  end

  # GET
  def combine_prepare
    authorize! :combine, @artist
  end

  # POST
  def combine
    authorize! :combine, @artist

    combine_params = params.require(:artist).permit(artists_with_same_name: [])
    artist_ids_to_combine_with = combine_params[:artists_with_same_name].delete_if(&:blank?)
    count = @artist.combine_artists_with_ids(artist_ids_to_combine_with)

    redirect_to @artist, notice: "De vervaardigers zijn samengevoegd, er zijn #{count} werken opnieuw gekoppeld."
  end

  # GET /artists/new
  def new
    authorize! :create, Artist
  end

  # GET /artists/1/edit
  def edit
    authorize! :update, @artist
  end

  # POST /artists
  # POST /artists.json
  def create
    @artist = Artist.new(artist_params)
    authorize! :create, @artist

    if @artist.save
      redirect_to @artist, notice: "De vervaardiger is aangemaakt."
    else
      render :new
    end
  end

  # PATCH/PUT /artists/1
  # PATCH/PUT /artists/1.json
  def update
    authorize! :update, @artist

    if @artist.update(artist_params)
      if artist_params["rkd_artist_id"] && (artist_params["rkd_artist_id"].to_i > 0) && (artist_params.keys.count == 1)
        notice = if params["copy_rkd_artist"] && can?(:copy, RKD::Artist) && @artist.import_rkd_artist_as_artist
          "De vervaardiger is gekoppeld & de gegevens zijn overgenomen."
        else
          "De vervaardiger is gekoppeld"
        end
        redirect_to [@collection, @artist].compact, notice: notice

        # redirect_to @collection ? collection_rkd_artist_path(@collection, @artist.rkd_artist, params: {artist_id: @artist.id}) : rkd_artist_path(@artist.rkd_artist, params: {artist_id: @artist.id}), notice: "De vervaardiger is gekoppeld met een RKD artist"
      else
        redirect_to [@collection, @artist].compact, notice: "De vervaardiger is bijgewerkt"
      end
    else
      render :edit
    end
  end

  # DELETE /artists/1
  # DELETE /artists/1.json
  def destroy
    authorize! :destroy, @artist

    @artist.destroy
    redirect_to artists_url, notice: "De vervaardiger is verwijderd."
  end

  def collectie_nederland_summary
  end

  def collectie_nederland_summary_update
    authorize! :collectie_nederland_summary_update, @artist

    @artist.store_collectie_nederland_summary
    if @artist.save
      redirect_to artist_collectie_nederland_summary_path(@artist), notice: "Bijgewerkt"
    else
      redirect_to artist_collectie_nederland_summary_path(@artist), notice: "Bijwerken lukte niet"
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_artist
    @artist = if @collection
      @collection.artists.find(params[:artist_id] || params[:id])
    else
      begin
        Artist.find(params[:artist_id] || params[:id])
      rescue ActiveRecord::RecordNotFound
        artist = Artist.unscoped.find(params[:artist_id] || params[:id])
        redirect_to artist, notice: "Gekoppelde vervaardiger"
      end
    end
  end

  def set_new_artist
    @artist = Artist.new
  end

  def populate_collection_attributes_for_artist
    @artist.populate_collection_attributes(collection: @collection) if @collection
  end

  def authenticate_admin_user_when_no_collection
    authorize! :manage, Artist if @collection.nil?
  end

  def retrieve_rkd_artists
    @rkd_artists = @artist.retrieve_rkd_artists!
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def artist_params
    a_params = params.require(:artist).permit(:first_name, :last_name, :prefix, :place_of_birth, :place_of_birth_geoname_id, :place_of_death, :place_of_death_geoname_id, :artist_name, :year_of_birth, :year_of_death, :date_of_birth, :date_of_death, :description, :rkd_artist_id, :gender, collection_attributes_attributes: HasCollectionAttributes::COLLECTION_ATTRIBUTES_PARAMS)
    a_params[:collection_attributes_attributes] = a_params[:collection_attributes_attributes].to_h.map { |k, v| [k, v.merge({collection_id: @collection.base_collection.id})] }.to_h if a_params[:collection_attributes_attributes]
    a_params
  end

  # this method is used to filter the works that are used to retrieve the artists
  def works_filter
    # binding.irb
    if params.dig(:filter, :works_tag_not)
      work_tag = ActsAsTaggableOn::Tag.find_by_name!(params.dig(:filter, :works_tag_not)).name
      ["works.tag_list_cache NOT LIKE ?", "%#{work_tag}%"]
    else
      {}
    end
  end
end
