class WorksBatchController < ApplicationController
  before_action :authenticate_qkunst_user!
  before_action :set_collection # set_collection includes authentication
  before_action :set_works


  def edit
    @selection = {display: :complete}
    @edit_property = (params[:property] || params[:batch_edit_property])
    @process_property = (params[:batch_process_property])
    if @edit_property
      @edit_property = @edit_property.to_sym
    elsif @process_property
      redirect_to new_collection_custom_report_path(works: @works.map(&:id))
    end
  end

  def update
    if params[:update_unless_empty]
      update_unless_empty
    elsif params[:update_and_add]
      update_and_add
    elsif params[:update_and_delete]
      update_and_delete
    else
      update_and_replace
    end

  end

  def index
  end

  private

  def work_params
    WorksController.new.send(:reusable_work_params, params, current_user)
  end
  def set_works
    @works = @collection.works_including_child_works.where(id: params[:works] || params[:selected_works])
  end
  def update_unless_empty
    work_parameters = work_params.to_hash.select{|k,v| !(v == nil or v.to_s.strip.empty?)}
    if @works.update(work_parameters)
      redirect_to collection_works_path(@collection), notice: "De geselecteerde werken zijn bijgewerkt"
    else
      render :edit
    end
  end

  def update_and_add
    save_results = []
    @works.each do |work|
      combined_work_parameters = {}
      work_params.each do | parameter, values |
        if values.is_a? Array and parameter.to_s.match(/_ids$/)
          new_values = (work.send(parameter.gsub(/_ids$/,"s").to_sym).collect{|a| a.id} + values).uniq
          combined_work_parameters[parameter] = new_values
        else
          new_values = (work.send(parameter.to_sym).to_a + values).uniq
          combined_work_parameters[parameter] = new_values
        end
      end
      save_results << work.update(combined_work_parameters)
    end
    if !save_results.include?(false)
      redirect_to collection_works_path(@collection), notice: "De geselecteerde werken zijn bijgewerkt"
    else
      render :edit
    end
  end

  def update_and_delete
    save_results = []
    @works.each do |work|
      combined_work_parameters = {}
      work_params.each do | parameter, values |
        if values.is_a? Array and parameter.to_s.match(/_ids$/)
          new_values = (work.send(parameter.gsub(/_ids$/,"s").to_sym).collect{|a| a.id} - values).uniq
          combined_work_parameters[parameter] = new_values
        else
          new_values = (work.send(parameter.to_sym).to_a - values).uniq
          combined_work_parameters[parameter] = new_values
        end
      end
      save_results << work.update(combined_work_parameters)
    end
    if !save_results.include?(false)
      redirect_to collection_works_path(@collection), notice: "De geselecteerde werken zijn bijgewerkt"
    else
      render :edit
    end
  end

  def update_and_replace
    if @works.update(work_params)
      redirect_to collection_works_path(@collection), notice: "De geselecteerde werken zijn bijgewerkt"
    else
      render :edit
    end
  end
end
