class ArtistsController < ApplicationController
  before_action :set_collection
  before_action :authenticate_admin_user!, only: [:clean, :combine, :combine_prepare]
  before_action :authenticate_qkunst_user!, only: [:edit, :update, :destroy, :new, :create]
  before_action :authenticate_qkunst_user_if_no_collection!
  before_action :set_artist, only: [:show, :edit, :update, :destroy, :combine, :combine_prepare]
  skip_before_action :verify_authenticity_token, only: [:create]

  # GET /artists
  # GET /artists.json
  def index
    if @collection
      @artists = @collection.artists.order_by_name.uniq.all
      @title = "Vervaardigers in collectie #{@collection.name}"
    else
      @artists = Artist.order_by_name.all
      @title = "Alle vervaardigers"
    end
  end

  # POST
  def clean
    Artist.destroy_all_empty_artists!
    Artist.destroy_all_artists_with_no_name_that_have_works_that_already_belong_to_artists_with_a_name!
    Artist.collapse_by_name!({only_when_created_at_date_is_equal: true})
    redirect_to artists_path, notice: "De kunstenaarsdatabase is opgeschoond!"
  end

  # GET /artists/1
  # GET /artists/1.json
  def show
  end

  # GET
  def combine_prepare

  end

  # POST
  def combine
    combine_params = params.require(:artist).permit(artists_with_same_name:[])
    artist_ids_to_combine_with = combine_params[:artists_with_same_name].delete_if{|a| a == ""}
    count = @artist.combine_artists_with_ids(artist_ids_to_combine_with)

    redirect_to @artist, notice: "De kunstenaars zijn samengevoegd, er zijn #{count} werken opnieuw gekoppeld."
  end

  # GET /artists/new
  def new
    @artist = Artist.new
  end

  # GET /artists/1/edit
  def edit
  end

  # POST /artists
  # POST /artists.json
  def create
    @artist = Artist.new(artist_params)

    respond_to do |format|
      if @artist.save
        format.html { redirect_to @artist, notice: 'De vervaardiger is aangemaakt.' }
        format.json { render :show, status: :created, location: @artist }
      else
        format.html { render :new }
        format.json { render json: @artist.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /artists/1
  # PATCH/PUT /artists/1.json
  def update
    respond_to do |format|
      if @artist.update(artist_params)
        format.html { redirect_to @artist, notice: 'De vervaardiger is bijgewerkt' }
        format.json { render :show, status: :ok, location: @artist }
      else
        format.html { render :edit }
        format.json { render json: @artist.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /artists/1
  # DELETE /artists/1.json
  def destroy
    @artist.destroy
    respond_to do |format|
      format.html { redirect_to artists_url, notice: 'De vervaardiger is verwijderd.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_artist
      id = params[:artist_id] ? params[:artist_id] : params[:id]
      @artist = Artist.find(id)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def artist_params
      params.require(:artist).permit(:first_name, :last_name, :prefix, :place_of_birth, :place_of_death, :year_of_birth, :year_of_death, :description)
    end
end
