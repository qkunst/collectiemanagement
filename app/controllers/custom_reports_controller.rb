# frozen_string_literal: true

class CustomReportsController < ApplicationController
  include Works::WorkIds

  before_action :set_collection
  before_action :set_custom_report, only: [:show, :edit, :update, :destroy]

  # GET /custom_reports
  # GET /custom_reports.json
  def index
    authorize! :index, CustomReport
    @custom_reports = @collection.custom_reports.all
  end

  # GET /custom_reports/1
  # GET /custom_reports/1.json
  def show
    authorize! :show, CustomReport
  end

  # GET /custom_reports/new
  def new
    authorize! :new, CustomReport
    @custom_report = @collection.custom_reports.new
    @works = set_works_by_work_ids_or_work_ids_hash
    @custom_report.works = @collection.works_including_child_works.where(id: @works)
  end

  # GET /custom_reports/1/edit
  def edit
    authorize! :edit, CustomReport
  end

  # POST /custom_reports
  # POST /custom_reports.json
  def create
    authorize! :create, CustomReport

    @custom_report = CustomReport.new(custom_report_params)
    @custom_report.collection = @collection
    respond_to do |format|
      if @custom_report.save
        format.html { redirect_to edit_collection_custom_report_path(@collection, @custom_report), notice: "Rapport is gemaakt, vul de variabelen aan" }
        format.json { render :show, status: :created, location: @custom_report }
      else
        format.html { render :new }
        format.json { render json: @custom_report.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /custom_reports/1
  # PATCH/PUT /custom_reports/1.json
  def update
    authorize! :update, CustomReport

    respond_to do |format|
      if @custom_report.update(custom_report_params)
        format.html { redirect_to [@collection, @custom_report], notice: "Custom report was successfully updated." }
        format.json { render :show, status: :ok, location: @custom_report }
      else
        format.html { render :edit }
        format.json { render json: @custom_report.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /custom_reports/1
  # DELETE /custom_reports/1.json
  def destroy
    authorize! :destroy, CustomReport

    @custom_report.destroy
    respond_to do |format|
      format.html { redirect_to collection_custom_reports_url(@collection), notice: "Custom report was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_custom_report
    @custom_report = @collection.custom_reports.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def custom_report_params
    allowed_variables = @custom_report ? @custom_report.template_fields : []

    params.require(:custom_report).permit(:custom_report_template_id, :title, work_ids: [], variables: allowed_variables)
  end
end
