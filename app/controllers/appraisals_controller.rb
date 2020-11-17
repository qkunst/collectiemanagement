# frozen_string_literal: true

class AppraisalsController < ApplicationController
  before_action :set_collection # set_collection includes authentication
  before_action :set_work
  before_action :set_appraisal, only: [:edit, :update, :destroy]

  # GET /appraisals/new
  def new
    @appraisal = Appraisal.new(appraised_by: current_user.name, appraised_on: Time.now.to_date, work: @work)
    @latest_appraisal = @work.appraisals.descending_appraisal_on.first
  end

  # GET /appraisals/1/edit
  def edit
  end

  def index
  end

  # POST /appraisals
  # POST /appraisals.json
  def create
    @work.update(appraisal_params[:work_attributes])
    params = appraisal_params
    params.delete(:work_attributes)
    @appraisal = Appraisal.new(params)
    @appraisal.user = current_user
    @appraisal.work = @work
    respond_to do |format|
      if @appraisal.save
        format.html { redirect_to collection_work_path(@collection, @work), notice: "De waardering is toegevoegd." }
        format.json { render :show, status: :created, location: @appraisal }
      else
        format.html { render :new }
        format.json { render json: @appraisal.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /appraisals/1
  # PATCH/PUT /appraisals/1.json
  def update
    respond_to do |format|
      if @appraisal.update(appraisal_params)
        format.html { redirect_to collection_work_path(@collection, @work), notice: "De waardering is bijgewerkt" }
        format.json { render :show, status: :ok, location: @appraisal }
      else
        format.html { render :edit }
        format.json { render json: @appraisal.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /appraisals/1
  # DELETE /appraisals/1.json
  def destroy
    @appraisal.destroy

    respond_to do |format|
      format.html { redirect_to collection_work_path(@collection, @work), notice: "De waardering is verwijderd" }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_appraisal
    @appraisal = @work.appraisals.find(params[:id])
  rescue
    redirect_to root_path, alert: "U heeft ook geen toegang tot deze waardering via dit werk!" unless @appraisal.work == @work
  end

  def set_work
    @work = Work.find(params[:work_id])
    redirect_to root_path, alert: "U heeft ook geen toegang tot dit werk via deze collectie!" unless @work.collection == @collection
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def appraisal_params
    params.require(:appraisal).permit(:appraised_on, :market_value, :replacement_value, :market_value_range, :replacement_value_range, :appraised_by, :reference, work_attributes: [
      :id, :purchased_on, :purchase_year, :purchase_price, :purchase_price_currency_id, :print, :print_unknown, :source_comments, :balance_category_id,
      :grade_within_collection, :main_collection, :owner_id, :other_comments, source_ids: []
    ])
  end
end
