# frozen_string_literal: true

class WorkSets::WorksController < ApplicationController
  # before_action :set_collection
  before_action :set_work_set
  before_action :set_work

  def destroy
    @work_set.work_ids = @work_set.work_ids - [@work.id]
    work_set_time_span = @work_set.current_active_time_span

    if @work_set.save
      ReindexWorkWorker.perform_async(@work.id)

      if @work.current_active_time_span && @work.current_active_time_span.time_span == work_set_time_span
        @work.current_active_time_span.time_span = nil

        if @work.current_active_time_span.finished? && @work.current_active_time_span.save
          redirect_to work_set_path(@work_set), notice: "Het werk #{@work.title} is verwijderd uit deze groepering."
        elsif @work.current_active_time_span.save
          redirect_to collection_work_path(@work.collection, @work), alert: "Het werk #{@work.title} is verwijderd uit de groepering #{@work_set.name}. Let op: de actieve gebeurtenis is niet beëindigd."
        else
          redirect_to collection_work_path(@work.collection, @work), alert: "Het werk kon niet worden losgekoppeld van de actieve gebeurtenis. Doe dit handmatig."
        end
      else
        redirect_to work_set_path(@work_set), notice: "Het werk #{@work.title} is verwijderd uit deze groepering."
      end
    else
      redirect_to work_set_path(@work_set), alert: "Het werk #{@work.title} kon niet worden verwijderd uit deze groepering, probeer het opnieuw."
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
    @work = @works.find { |a| a.id == params[:id].to_i }
  end
end
