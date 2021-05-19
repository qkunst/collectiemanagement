# frozen_string_literal: true

class BatchController < ApplicationController
  include Works::Filtering

  before_action :set_collection
  before_action :set_works_by_numbers
  before_action :check_ability

  def show
    if params[:batch_process_property] == "create_report"
      redirect_to new_collection_custom_report_path(works: @works.map(&:id))
    elsif params[:batch_process_property] == "create_work_set"
      redirect_to new_work_set_path(works: @works.map(&:id))
    else
      @selection = {display: :complete}

      @form.default_to_ignore!
    end
  end

  def update
    @form = Batch::WorkForm.new(work_params.to_h.deep_merge(work_batch_strategies_params))
    @form.collection = @collection if @form.collection.nil?

    if @form.valid?
      Work.transaction do
        @works.map { |work| @form.update_work!(work) }
      end
      redirect_to_collection_works_return_url
    else
      render :show
    end
  rescue ActiveRecord::RecordInvalid => invalid
    if invalid.record.is_a? Appraisal
      @form.errors.add(:appraisals, invalid.record.errors.full_messages.to_sentence)
    else
      @form.errors.merge!(invalid.record.errors)
    end
    render :show
  end

  def set_works_by_numbers
    work_numbers = separate_by(params[:work_numbers_return_separated], /\n/)
    work_ids = separate_by(params[:work_ids_comma_separated], /,/) + Array(params[:selected_works])

    selected_work_group_type = :skip
    selected_work_group_ids = []

    if params[:selected_work_groups]
      selected_work_group_type = params[:selected_work_groups].keys.first
      selected_work_group_ids = params[:selected_work_groups][selected_work_group_type]
    end

    set_selection_filter

    @form = Batch::WorkForm.new(collection: @collection)
    filtered_works = @collection.search_works("", @selection_filter, {force_elastic: false, return_records: true, no_child_works: false})

    @works = filtered_works.by_group(selected_work_group_type, selected_work_group_ids).or(filtered_works.has_number(work_numbers)).or(filtered_works.where(id: work_ids))
    @work_count = @works.count
    @work_ids = @works.pluck(:id)
  end

  def editable_fields
    current_user.ability.editable_work_fields.flat_map do |a|
      a.methods.include?(:keys) ? a.keys : a
    end
  end

  def editable_appraisal_fields
    return [] unless current_user.ability.editable_work_fields.last.is_a?(Hash) && current_user.ability.editable_work_fields.last[:appraisals_attributes]
    current_user.ability.editable_work_fields.last[:appraisals_attributes].flat_map do |a|
      a.methods.include?(:keys) ? a.keys : a
    end
  end

  def should_expose_field?(field_name)
    Array(params[:expose_fields]).select { |a| a.present? }.blank? || params[:expose_fields].include?(field_name.to_s)
  end

  def can_edit_field?(field_name)
    editable_fields.include?(field_name) && should_expose_field?(field_name)
  end
  helper_method :can_edit_field?

  private

  def separate_by parameter, by
    parameter.to_s.split(by).map(&:strip).select(&:present?)
  end

  def work_params
    WorksController.new.send(:reusable_work_params, params, current_user)
  end

  def check_ability
    authorize! :batch_edit, @collection
  end

  def work_batch_strategies_params
    params.require(:work).permit(
      (editable_fields & Batch::WorkForm::BATCH_FIELDS).map { |f| Batch::WorkForm.strategy_attribute_for(f) }, {
        appraisals_attributes: (editable_appraisal_fields & Batch::AppraisalForm::BATCH_FIELDS).map { |f| Batch::AppraisalForm.strategy_attribute_for(f) }
      }
    )
  end

  def redirect_to_collection_works_return_url
    ids = @works.pluck(:id)
    if ids.count > Works::Filtering::DEFAULT_GROUPED_WORK_COUNT
      redirect_to collection_works_path(@collection, params: {ids: ids[0..WorksController::DEFAULT_GROUPED_WORK_COUNT - 1].join(",")}), notice: "Er zijn #{ids.count} werken bijgewerkt, een selectie daarvan wordt hieronder getoond."
    else
      redirect_to collection_works_path(@collection, params: {ids: ids.join(",")}), notice: "De onderstaande #{ids.count} werken zijn bijgewerkt"
    end
  end
end
