# frozen_string_literal: true

class WorkSets::WorksController < ApplicationController
  # before_action :set_collection
  before_action :set_work_set
  before_action :set_work

  def destroy
    @work_set.work_ids = @work_set.work_ids - [@work.id]
    if @work_set.save
      ReindexWorkWorker.perform_async(@work.id)
      redirect_to work_set_path(@work_set), notice: "Het werk #{@work.title} is verwijderd uit deze groepering."
    else
      redirect_to  work_set_path(@work_set), alert: "Het werk #{@work.title} kon niet worden verwijderd uit deze groepering, probeer het opnieuw."
    end
  end

  private

  def set_work_set
    @work_set = WorkSet.find(params[:work_set_id])
    if @work_set.works.any?
      @collection ||= @work_set.most_specific_shared_collection
    end
    work_ids = @work_set.work_ids
    @works = current_user.accessible_works.where(id: work_ids).order(:stock_number)
  end

  def set_work
    @work = @works.find{|a| a.id == params[:id].to_i}
  end

end