# frozen_string_literal: true

class CollectionsStagesController < ApplicationController
  before_action :authenticate_qkunst_user!
  before_action :set_collection
  before_action :set_collections_stage

  def update
    authorize! :update_status, @collection
    respond_to do |format|
      if @collections_stage.update(collections_stage_params)
        format.html { redirect_to @collection, notice: "De workflow voor deze collectie is bijgewerkt" }
        format.json { render :show, status: :ok, location: @collection }
      else
        format.html { render :edit }
        format.json { render json: @stage.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def collections_stage_params
    params.require(:collections_stage).permit(:completed)
  end

  def set_collections_stage
    @collections_stage = @collection.collections_stages.find(params[:id])
  end
end
