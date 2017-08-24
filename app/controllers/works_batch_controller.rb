class WorksBatchController < ApplicationController
  before_action :authenticate_qkunst_user!
  before_action :set_collection # set_collection includes authentication
  before_action :set_works


  def edit
    @selection = {display: :complete}
    @edit_property = (params[:property] || params[:batch_edit_property])
    if @edit_property
      @edit_property = @edit_property.to_sym
    end
  end

  def update
    work_parameters = work_params
    if params[:update_unless_empty]
      work_parameters = {}
      work_params.each do |k, v|
        work_parameters[k] = v unless v == nil or v.to_s.strip.empty?
      end
      if @works.update(work_parameters)
        redirect_to collection_works_path(@collection), notice: "De geselecteerde werken zijn bijgewerkt"
      else
        render :edit
      end
    elsif params[:update_and_add]
      save_results = []
      @works.each do |work|
        combined_work_parameters = {}
        work_parameters.each do | parameter, values |
          if values.is_a? Array and parameter.to_s.match(/_ids$/)
            new_values = (work.send(parameter.gsub(/_ids$/,"s").to_sym).collect{|a| a.id} + values).uniq
            combined_work_parameters[parameter] = new_values
          else
            combined_work_parameters[parameter] = values
          end
        end
        save_results << work.update(combined_work_parameters)
      end
      if !save_results.include?(false)
        redirect_to collection_works_path(@collection), notice: "De geselecteerde werken zijn bijgewerkt"
      else
        render :edit
      end
    else
      if @works.update(work_parameters)
        redirect_to collection_works_path(@collection), notice: "De geselecteerde werken zijn bijgewerkt"
      else
        render :edit
      end
    end

  end

  def index
  end

  # private

  def work_params
    WorksController.new.send(:reusable_work_params, params, current_user)
  end
  def set_works
    @works = @collection.works_including_child_works.where(id: params[:works] || params[:selected_works])
  end
end
