# frozen_string_literal: true

class WorksBatchController < ApplicationController
  include BatchMethods

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

  private

  def set_works
    @works = @collection.works_including_child_works.where(id: params[:works] || params[:selected_works])
  end
end
