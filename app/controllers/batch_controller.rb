# frozen_string_literal: true

class BatchController < ApplicationController
  before_action :set_collection
  before_action :set_works_by_numbers
  before_action :check_ability

  def show
    if params[:batch_process_property] == "create_report"
      redirect_to new_collection_custom_report_path(works: @works.map(&:id))
    else
      @selection = {display: :complete}

      @form.default_to_ignore!
    end
  end

  def update
    @form = Batch::WorkForm.new(work_params.to_h.deep_merge(work_batch_strategies_params))
    @form.collection = @collection if @form.collection.nil?
    if @form.valid?
      @works.map { |work| @form.update_work(work) }
      redirect_to_collection_works_return_url
    else
      render :show
    end
  end

  def set_works_by_numbers
    work_numbers = separate_by(params[:work_numbers_return_separated], /\n/)
    work_ids = separate_by(params[:work_ids_comma_separated], /,/) + Array(params[:selected_works])

    @form = Batch::WorkForm.new(collection: @collection)
    @works = @collection.works_including_child_works.has_number(work_numbers).or(@collection.works_including_child_works.where(id: work_ids))
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
    Array(params[:expose_fields]).select{|a| a.present?}.blank? || params[:expose_fields].include?(field_name.to_s)
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
    redirect_to collection_works_path(@collection, params: {ids: @works.map(&:id).join(",")}), notice: "De onderstaande #{@works.count} werken zijn bijgewerkt"
  end
end
