# frozen_string_literal: true

class WorksBatchController < ApplicationController
  before_action :set_collection # set_collection includes authentication
  before_action :set_works

  def edit
    @selection = {display: :complete}
    @edit_property = (params[:property] || params[:batch_edit_property])
    @process_property = params[:batch_process_property]
    work_ids = @works.pluck(:id)

    if @edit_property
      redirect_to collection_batch_path(work_ids_comma_separated: work_ids.join(","), expose_fields: [@edit_property])
    elsif @process_property
      if @process_property == "create_report"
        redirect_to new_collection_custom_report_path(works: work_ids)
      elsif @process_property == "batch_editor"
        redirect_to collection_batch_path(work_ids_comma_separated: work_ids.join(","))
      end
    end
  end

  private

  def set_works
    @works = @collection.works_including_child_works.where(id: params[:works] || params[:selected_works])
  end
end
