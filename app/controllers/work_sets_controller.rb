# frozen_string_literal: true

class WorkSetsController < ApplicationController
  include Works::WorkIds
  include Works::Filtering

  before_action :set_collection
  before_action :set_work_set, only: [:show, :edit, :destroy, :update]
  before_action :set_all_filters, only: [:show, :edit, :update, :create]

  def new
    @work_set = WorkSet.new
    authorize! :new, @work_set

    if params[:works] || params[:work_ids]
      work_ids = (params[:works] || params[:work_ids]).map { |w| w.to_i }
      @works = current_user.accessible_works.where(id: work_ids)
    elsif params[:work_ids_hash]
      work_ids = IdsHash.find_by_hashed(params[:work_ids_hash]).ids
      @works = current_user.accessible_works.where(id: work_ids)
    elsif params[:filter]
      set_all_filters
      @work_set.works_filter_params = {time_filter: @time_filter.to_parameters, filter: @selection_filter, no_child_works: @no_child_works, q: @search_text, collection_id: @collection.id}
      set_works
    end

    @work_set.works = @works || []
  end

  def create
    if append_to_work_set?
      @work_set = WorkSet.find(params.dig(:work_set, :id))
      ids_to_append = params.dig(:work_set, :work_ids).split(" ").map(&:to_i)
      authorize! :update, @work_set
      @work_set.work_ids = (@work_set.work_ids + ids_to_append).uniq
    elsif params[:filter]
      @work_set = WorkSet.new(work_set_params)
      @work_set.works_filter_params = {time_filter: @time_filter.to_parameters, filter: @selection_filter, no_child_works: @no_child_works, q: @search_text, collection_id: @collection.id}
      authorize! :create, @work_set
    else
      @work_set = WorkSet.new(work_set_params)

      authorize! :create, @work_set
    end

    if @work_set.save
      redirect_to [@collection, @work_set].compact, notice: "De werken zijn gegroepeerd in de verzameling"
    else
      @works = @work_set.works
      render :new
    end
  end

  def show
    if params[:collection_id].blank? && @collection
      redirect_to collection_work_set_path(@collection, @work_set) and return
    elsif params[:collection_id].blank? && !@collection && @work_set.works.empty?
      redirect_to root_path(@collection, @work_set), notice: "Geen werken in deze werkgroepering, noch gekoppeld aan collectie" and return
    elsif params[:collection_id].blank? && !@collection
      authorize! :read_without_collection, @work_set
    else
      authorize! :show, @work_set
    end

    @no_work_cache = true
    @works = current_user.accessible_works.where(id: @work_set.work_ids).order(:stock_number)
    @current_active_time_span = @work_set&.current_active_time_span

    if @current_active_time_span
      @works_outside_current_collection = @works.where.not(collection_id: @current_active_time_span.collection.expand_with_child_collections).pluck(:id)
      @works_not_for_current_time_span_contact = @works.joins(:time_spans).where(time_spans: TimeSpan.joins(:contact).active.where.not(contacts: {url: @current_active_time_span.contact_url})).uniq

    end

    @hidden_title_add = "(verborgen)" if @work_set.deactivated?

    @title = [@work_set.work_set_type.name, @work_set.identification_number].compact.join(" - ")
    @title = [@title, @hidden_title_add].compact.join(" ")
  end

  def index
    authorize! :show, WorkSet

    @work_sets_filter = WorkSetsFilter.new(work_set_filter_params)
    @work_sets = @collection.work_sets.order(created_at: :desc, work_set_type_id: :desc, identification_number: :desc)
    @work_sets = @work_sets.not_deactivated if !@work_sets_filter.deactivated?
  end

  def edit
    authorize! :edit, @work_set
  end

  def update
    authorize! :update, @work_set

    if @work_set.update(work_set_params)
      redirect_to [@collection, @work_set].compact, notice: "De werken zijn gegroepeerd in de verzameling"
    else
      render :edit
    end
  end

  def destroy
    authorize! :destroy, @work_set
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

  def append_to_work_set?
    params.dig(:work_set, :id).present?
  end

  def set_work_set
    @work_set = WorkSet.find_by_uuid_or_id!(params[:id])
    @collection ||= @work_set.most_specific_shared_collection
    work_ids = @work_set.work_ids
    @works = current_user.accessible_works.where(id: work_ids).order(:stock_number)
  end

  def work_set_filter_params
    params.require("work_sets_filter").permit("deactivated")
  rescue ActionController::ParameterMissing
    {}
  end

  def work_set_params
    rv = params.require(:work_set).permit(:work_set_type_id, :identification_number, :work_ids, :comment, :deactivated, :dynamic)
    rv[:work_ids] = current_user.accessible_works.where(id: rv[:work_ids].split(/[\s,]/)).pluck(:id) if rv[:work_ids]
    rv
  end
end
