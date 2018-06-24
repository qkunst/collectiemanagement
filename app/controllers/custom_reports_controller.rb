class CustomReportsController < ApplicationController
  before_action :set_collection
  before_action :set_custom_report, only: [:show, :edit, :update, :destroy]

  # GET /custom_reports
  # GET /custom_reports.json
  def index
    @custom_reports = CustomReport.all
  end

  # GET /custom_reports/1
  # GET /custom_reports/1.json
  def show
  end

  # GET /custom_reports/new
  def new
    @custom_report = CustomReport.new
    if params[:works]
      work_ids = params[:works].map{|w| w.to_i};
      @custom_report.works = @collection.works_including_child_works.where(id: work_ids)
    end
  end

  # GET /custom_reports/1/edit
  def edit
  end

  # POST /custom_reports
  # POST /custom_reports.json
  def create
    @custom_report = CustomReport.new(custom_report_params)
    @custom_report.collection = @collection
    respond_to do |format|
      if @custom_report.save
        format.html { redirect_to edit_collection_custom_report_path(@collection, @custom_report), notice: 'Rapport is gemaakt, vul de variabelen aan' }
        format.json { render :show, status: :created, location: @custom_report }
      else
        format.html { render :new }
        format.json { render json: @custom_report.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /custom_reports/1
  # PATCH/PUT /custom_reports/1.json
  def update
    respond_to do |format|
      puts custom_report_params
      if @custom_report.update(custom_report_params)
        format.html { redirect_to [@collection, @custom_report], notice: 'Custom report was successfully updated.' }
        format.json { render :show, status: :ok, location: @custom_report }
      else
        format.html { render :edit }
        format.json { render json: @custom_report.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /custom_reports/1
  # DELETE /custom_reports/1.json
  def destroy
    @custom_report.destroy
    respond_to do |format|
      format.html { redirect_to collection_custom_reports_url(@collection), notice: 'Custom report was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_custom_report
      @custom_report = CustomReport.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def custom_report_params
      allowed_variables = @custom_report ? @custom_report.template_fields : []

      params.require(:custom_report).permit(:custom_report_template_id, :title, work_ids: [], variables: allowed_variables)
    end
end
