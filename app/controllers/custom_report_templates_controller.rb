# frozen_string_literal: true

class CustomReportTemplatesController < ApplicationController
  before_action :authenticate_admin_user!

  before_action :set_custom_report_template, only: [:show, :edit, :update, :destroy]

  def index
    @custom_report_templates = CustomReportTemplate.all
  end

  def new
    @custom_report_template = CustomReportTemplate.new
  end

  def edit
  end

  def show
  end

  def create
    @custom_report_template = CustomReportTemplate.new(custom_report_template_params)
    if @custom_report_template.save
      redirect_to custom_report_templates_path, notice: "Template aangemaakt"
    else
      render :new
    end
  end

  def update
    if @custom_report_template.update(custom_report_template_params)
      redirect_to custom_report_templates_path, notice: "Template bijgewerkt."
    else
      render :edit
    end
  end

  # DELETE /custom_report_templates/1
  # DELETE /custom_report_templates/1.json
  def destroy
    @custom_report_template.destroy
    respond_to do |format|
      format.html { redirect_to custom_report_templates_url, notice: "Custom report template was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_custom_report_template
    @custom_report_template = CustomReportTemplate.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def custom_report_template_params
    params.require(:custom_report_template).permit(:title, :text, :collection_id, :work_fields)
  end
end
