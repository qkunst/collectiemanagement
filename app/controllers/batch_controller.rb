# frozen_string_literal: true

class BatchAppraisalForm < Appraisal
  BATCH_FIELDS = %w{appraised_by appraised_on replacement_value market_value replacement_value_range market_value_range reference}.sort_by(&:length).reverse.map(&:to_sym)
  UNAPPENDABLE_FIELDS = BATCH_FIELDS #.select{|field_name| field_name.to_s.ends_with?("_id")}
  REMOVABLE_FIELDS = %w{}

  def self.batch_fields
    BATCH_FIELDS
  end

  def self.unappendable_fields
    UNAPPENDABLE_FIELDS
  end

  def self.removable_fields
    REMOVABLE_FIELDS
  end

  include BatchForm

  BATCH_FIELDS.each do |field_name|
    attribute strategy_attribute_for(field_name)
  end

  def market_value_range
    (super.min.to_i..super.max.to_i).to_s if super
  end
  def replacement_value_range
    (super.min.to_i..super.max.to_i).to_s if super
  end

  def model_name
    ActiveModel::Name.new(Appraisal, nil, "appraisals_attributes_0")
  end

  def appraisal_params
    self.object_update_parameters(Appraisal.new)
  end

  def empty_params?
    {} == appraisal_params
  end
  alias_attribute :ignore_validation_errors?, :empty_params?
end

class BatchWorkForm < Work
  BATCH_FIELDS = %w{ purchase_price purchased_on purchase_year source_comments other_comments selling_price minimum_bid location location_floor location_detail cluster_id cluster_name subset_id technique_ids source_ids collection_id placeability_id theme_ids grade_within_collection tag_list}.sort_by(&:length).reverse.map(&:to_sym)
  UNAPPENDABLE_FIELDS = BATCH_FIELDS.select{|field_name| field_name.to_s.ends_with?("_id") || [:grade_within_collection].include?(field_name)}
  REMOVABLE_FIELDS = %w{ tag_list }.map(&:to_sym)

  before_validation :validate_appraisal

  def self.batch_fields
    BATCH_FIELDS
  end

  def self.unappendable_fields
    UNAPPENDABLE_FIELDS
  end

  def self.removable_fields
    REMOVABLE_FIELDS
  end

  include BatchForm

  BATCH_FIELDS.each do |field_name|
    attribute strategy_attribute_for(field_name)
  end

  def cluster_name= cluster_name
    @cluster_name = cluster_name
  end

  def cluster_name
    @cluster_name
  end

  def model_name
    Work.new.model_name
  end

  def appraisal
    @appraisal ||= BatchAppraisalForm.new
  end

  def appraisals_attributes= options
    @appraisal = BatchAppraisalForm.new(options["0"])
  end

  def update_work(work)
    work.update(object_update_parameters(work))

    unless appraisal.empty_params?
      work.appraisals << Appraisal.new(appraisal.appraisal_params)
      work.save
    end
  end

  def ignore_validation_errors?
    false
  end

  def validate_appraisal
    appraisal.work = Work.new(collection: Collection.new)
    errors.merge!(appraisal.errors) if !appraisal.ignore_validation_errors?  and !appraisal.valid?
  end
end

class BatchController < ApplicationController
  before_action :set_collection
  before_action :set_works_by_numbers
  before_action :check_ability

  def show
    @selection = {display: :complete}

    @form.default_to_ignore!
  end

  def update
    @form = BatchWorkForm.new(work_params.to_h.deep_merge(work_batch_strategies_params))
    @form.collection = @collection if @form.collection.nil?
    if @form.valid?
      @works.map{|work| @form.update_work(work)}
      redirect_to_collection_works_return_url
    else
      render :show
    end
  end

  def set_works_by_numbers
    work_numbers = separate_by(params[:work_numbers_return_separated], /\n/)
    work_ids = separate_by(params[:work_ids_comma_separated], /,/)
    @form = BatchWorkForm.new(collection: @collection)
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
    return [] unless current_user.ability.editable_work_fields.last[:appraisals_attributes]
    current_user.ability.editable_work_fields.last[:appraisals_attributes].flat_map do |a|
      a.methods.include?(:keys) ? a.keys : a
    end
  end

  def should_expose_field?(field_name)
    params[:expose_fields].blank? || params[:expose_fields].include?(field_name.to_s)
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
      (editable_fields & BatchWorkForm::BATCH_FIELDS).map{|f| BatchWorkForm.strategy_attribute_for(f)}, {
        appraisals_attributes: (editable_appraisal_fields & BatchAppraisalForm::BATCH_FIELDS).map{|f| BatchAppraisalForm.strategy_attribute_for(f)}
      }

    )
  end

  def redirect_to_collection_works_return_url
    redirect_to collection_works_path(@collection, params: {ids: @works.map(&:id).join(",") }), notice: "De onderstaande #{@works.count} werken zijn bijgewerkt"
  end

end
