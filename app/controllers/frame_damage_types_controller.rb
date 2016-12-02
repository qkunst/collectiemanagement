class FrameDamageTypesController < ApplicationController
  before_action :authenticate_admin_user!
  before_action :set_frame_damage_type, only: [:show, :edit, :update, :destroy]

  # GET /frame_damage_types
  # GET /frame_damage_types.json
  def index
    @frame_damage_types = FrameDamageType.all
  end

  # GET /frame_damage_types/1
  # GET /frame_damage_types/1.json
  def show
  end

  # GET /frame_damage_types/new
  def new
    @frame_damage_type = FrameDamageType.new
  end

  # GET /frame_damage_types/1/edit
  def edit
  end

  # POST /frame_damage_types
  # POST /frame_damage_types.json
  def create
    @frame_damage_type = FrameDamageType.new(frame_damage_type_params)

    respond_to do |format|
      if @frame_damage_type.save
        format.html { redirect_to frame_damage_types_url, notice: 'Frame damage type was successfully created.' }
        format.json { render :show, status: :created, location: @frame_damage_type }
      else
        format.html { render :new }
        format.json { render json: @frame_damage_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /frame_damage_types/1
  # PATCH/PUT /frame_damage_types/1.json
  def update
    respond_to do |format|
      if @frame_damage_type.update(frame_damage_type_params)
        format.html { redirect_to frame_damage_types_url, notice: 'Frame damage type was successfully updated.' }
        format.json { render :show, status: :ok, location: @frame_damage_type }
      else
        format.html { render :edit }
        format.json { render json: @frame_damage_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /frame_damage_types/1
  # DELETE /frame_damage_types/1.json
  def destroy
    @frame_damage_type.destroy
    respond_to do |format|
      format.html { redirect_to frame_damage_types_url, notice: 'Frame damage type was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_frame_damage_type
      @frame_damage_type = FrameDamageType.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def frame_damage_type_params
      params.require(:frame_damage_type).permit(:name, :order, :hide)
    end
end
