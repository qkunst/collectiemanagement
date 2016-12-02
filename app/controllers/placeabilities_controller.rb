class PlaceabilitiesController < ApplicationController
  before_action :authenticate_admin_user!
  before_action :set_placeability, only: [:show, :edit, :update, :destroy]

  # GET /placeabilities
  # GET /placeabilities.json
  def index
    @placeabilities = Placeability.all
  end

  # GET /placeabilities/1
  # GET /placeabilities/1.json
  def show
  end

  # GET /placeabilities/new
  def new
    @placeability = Placeability.new
  end

  # GET /placeabilities/1/edit
  def edit
  end

  # POST /placeabilities
  # POST /placeabilities.json
  def create
    @placeability = Placeability.new(placeability_params)

    respond_to do |format|
      if @placeability.save
        format.html { redirect_to placeabilities_url, notice: 'Placeability was successfully created.' }
        format.json { render :show, status: :created, location: @placeability }
      else
        format.html { render :new }
        format.json { render json: @placeability.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /placeabilities/1
  # PATCH/PUT /placeabilities/1.json
  def update
    respond_to do |format|
      if @placeability.update(placeability_params)
        format.html { redirect_to placeabilities_url, notice: 'Placeability was successfully updated.' }
        format.json { render :show, status: :ok, location: @placeability }
      else
        format.html { render :edit }
        format.json { render json: @placeability.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /placeabilities/1
  # DELETE /placeabilities/1.json
  def destroy
    @placeability.destroy
    respond_to do |format|
      format.html { redirect_to placeabilities_url, notice: 'Placeability was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_placeability
      @placeability = Placeability.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def placeability_params
      params.require(:placeability).permit(:name, :order, :hide)
    end
end
