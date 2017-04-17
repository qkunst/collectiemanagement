class FrameTypesController < ApplicationController
  before_action :authenticate_admin_user!
  before_action :set_frame_type, only: [:show, :edit, :update, :destroy]

  # GET /frame_types
  # GET /frame_types.json
  def index
    @frame_types = FrameType.all
  end

  # GET /frame_types/1
  # GET /frame_types/1.json
  def show
  end

  # GET /frame_types/new
  def new
    @frame_type = FrameType.new
  end

  # GET /frame_types/1/edit
  def edit
  end

  # POST /frame_types
  # POST /frame_types.json
  def create
    @frame_type = FrameType.new(frame_type_params)

    respond_to do |format|
      if @frame_type.save
        format.html { redirect_to frame_types_url, notice: 'Frame type was successfully created.' }
        format.json { render :show, status: :created, location: @frame_type }
      else
        format.html { render :new }
        format.json { render json: @frame_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /frame_types/1
  # PATCH/PUT /frame_types/1.json
  def update
    respond_to do |format|
      if @frame_type.update(frame_type_params)
        format.html { redirect_to frame_types_url, notice: 'Frame type was successfully updated.' }
        format.json { render :show, status: :ok, location: @frame_type }
      else
        format.html { render :edit }
        format.json { render json: @frame_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /frame_types/1
  # DELETE /frame_types/1.json
  def destroy
    @frame_type.destroy
    respond_to do |format|
      format.html { redirect_to frame_types_url, notice: 'Frame type was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_frame_type
      @frame_type = FrameType.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def frame_type_params
      params.require(:frame_type).permit(:name, :hide)
    end
end
