class DamageTypesController < ApplicationController
  before_action :authenticate_admin_user!
  before_action :set_damage_type, only: [:show, :edit, :update, :destroy]

  # GET /damage_types
  # GET /damage_types.json
  def index
    @damage_types = DamageType.all
  end

  # GET /damage_types/1
  # GET /damage_types/1.json
  def show
  end

  # GET /damage_types/new
  def new
    @damage_type = DamageType.new
  end

  # GET /damage_types/1/edit
  def edit
  end

  # POST /damage_types
  # POST /damage_types.json
  def create
    @damage_type = DamageType.new(damage_type_params)

    respond_to do |format|
      if @damage_type.save
        format.html { redirect_to damage_types_url, notice: 'Damage type was successfully created.' }
        format.json { render :show, status: :created, location: @damage_type }
      else
        format.html { render :new }
        format.json { render json: @damage_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /damage_types/1
  # PATCH/PUT /damage_types/1.json
  def update
    respond_to do |format|
      if @damage_type.update(damage_type_params)
        format.html { redirect_to damage_types_url, notice: 'Damage type was successfully updated.' }
        format.json { render :show, status: :ok, location: @damage_type }
      else
        format.html { render :edit }
        format.json { render json: @damage_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /damage_types/1
  # DELETE /damage_types/1.json
  def destroy
    @damage_type.destroy
    respond_to do |format|
      format.html { redirect_to damage_types_url, notice: 'Damage type was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_damage_type
      @damage_type = DamageType.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def damage_type_params
      params.require(:damage_type).permit(:name, :order, :hide)
    end
end
