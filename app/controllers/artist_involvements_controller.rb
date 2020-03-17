# frozen_string_literal: true

class ArtistInvolvementsController < ApplicationController
  load_and_authorize_resource :artist_involvement
  before_action :set_artist
  before_action :set_collection

  # GET /artist_involvements/new
  def new
    @artist_involvement = ArtistInvolvement.new(involvement_type: params[:type])
    @artist_involvement.involvement = Involvement.new
  end

  # GET /artist_involvements/1/edit
  def edit
  end

  # POST /artist_involvements
  # POST /artist_involvements.json
  def create
    @artist_involvement = ArtistInvolvement.new(artist_involvement_params)
    @artist_involvement.artist = @artist
    respond_to do |format|
      if @artist_involvement.save
        format.html { redirect_to [@collection, @artist].compact, notice: "Betrekking toegevoegd." }
        format.json { render :show, status: :created, location: @artist_involvement }
      else
        format.html { render :new }
        format.json { render json: @artist_involvement.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /artist_involvements/1
  # PATCH/PUT /artist_involvements/1.json
  def update
    respond_to do |format|
      if @artist_involvement.update(artist_involvement_params)
        format.html { redirect_to [@collection, @artist].compact, notice: "Betrekking bijgewerkt." }
        format.json { render :show, status: :ok, location: @artist_involvement }
      else
        format.html { render :edit }
        format.json { render json: @artist_involvement.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /artist_involvements/1
  # DELETE /artist_involvements/1.json
  def destroy
    @artist_involvement.destroy
    respond_to do |format|
      format.html { redirect_to @artist, notice: "Artist involvement was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.

  def set_artist
    @artist = Artist.find(params[:artist_id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def artist_involvement_params
    pms = params.require(:artist_involvement).permit(:involvement_id, :involvement_type, :start_year, :end_year, :place, :place_geoname_id)
    if pms[:involvement_attributes] && pms[:involvement_attributes][:id]
      if pms[:involvement_id] && (pms[:involvement_attributes][:id] != pms[:involvement_id])
        pms.delete(:involvement_attributes)
      end
    end
    if pms[:involvement_attributes] && !pms[:involvement_attributes][:name]
      pms.delete(:involvement_attributes)
    end
    pms
  end
end
