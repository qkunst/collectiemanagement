# frozen_string_literal: true

class StagesController < ApplicationController
  before_action :authenticate_admin_user!

  before_action :set_stage, only: [:show, :edit, :update, :destroy]

  # GET /stages
  # GET /stages.json
  def index
    # @stages = Stage.all
    # @tree = Stage.first.non_cyclic_graph_from_here
  end

  # GET /stages/1
  # GET /stages/1.json
  def show
    @collection = Collection.new(collections_stages: [CollectionsStage.new(stage: @stage, completed: true)])
  end

  # GET /stages/new
  def new
    @stage = Stage.new
  end

  # GET /stages/1/edit
  def edit
  end

  # POST /stages
  # POST /stages.json
  def create
    @stage = Stage.new(stage_params)

    respond_to do |format|
      if @stage.save
        format.html { redirect_to @stage, notice: "Fase is aangemaakt" }
        format.json { render :show, status: :created, location: @stage }
      else
        format.html { render :new }
        format.json { render json: @stage.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /stages/1
  # PATCH/PUT /stages/1.json
  def update
    respond_to do |format|
      if @stage.update(stage_params)
        format.html { redirect_to @stage, notice: "Fase is bijgewerkt" }
        format.json { render :show, status: :ok, location: @stage }
      else
        format.html { render :edit }
        format.json { render json: @stage.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /stages/1
  # DELETE /stages/1.json
  def destroy
    @stage.destroy
    respond_to do |format|
      format.html { redirect_to stages_url, notice: "Fase is verwijderd" }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_stage
    @stage = Stage.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def stage_params
    params.require(:stage).permit(:name, :actual_stage_id, :previous_stage_id)
  end
end
