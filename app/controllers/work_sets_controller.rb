class WorkSetsController < ApplicationController
  before_action :set_collection
  before_action :set_work_set, only: [:show, :destroy, :update]

  def new
    authorize! :new, WorkSet
    @work_set = WorkSet.new

    if params[:works]
      work_ids = params[:works].map { |w| w.to_i }
      @works = current_user.accessible_works.where(id: work_ids)
      @work_set.works = @works
    end
  end

  def create
    @work_set = WorkSet.new(work_set_params)

    if @work_set.save
      redirect_to [@collection, @work_set].compact, notice: "De werken zijn gegroepeerd in de verzameling"
    else
      render :new
    end
  end

  def show
    @works = current_user.accessible_works.where(id: @work_set.work_ids)

    if @works.count < 20
      @selection = {display: :complete}
    end
    @title = [@work_set.work_set_type.name, @work_set.identification_number].compact.join(" - ")
  end

  def destroy
    @collection ||= @work_set.works.first&.collection&.base_collection

    @work_ids = @work_set.work_ids
    if @work_set.appraisals.count > 0
      redirect_to [@collection, @work_set].compact, alert: "De verzamling kon niet worden verwijderd omdat er waarderingen aan zijn gekoppeld."
    elsif @work_set.destroy
      if @collection
        redirect_to collection_works_path(@collection, ids: @work_ids), notice: "De verzamling is verwijderd"
      else
        redirect_to collections_path, notice: "De verzamling is verwijderd"
      end
    else
      redirect_to [@collection, @work_set].compact, alert: "De verzamling kon niet worden verwijderd"

    end

  end

  private

  def set_work_set
    @work_set = WorkSet.find(params[:id])
    @collection ||= @work_set.most_specific_shared_collection
  end

  def work_set_params
    rv = params.require(:work_set).permit(:work_set_type_id, :identification_number, :work_ids)
    rv[:work_ids] = current_user.accessible_works.where(id: rv[:work_ids].split(/[\s,]/)).pluck(:id)
    rv
  end
end