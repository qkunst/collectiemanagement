# frozen_string_literal: true

module BatchForm
  extend ActiveSupport::Concern

  module UpdateStrategies
    IGNORE = [:ignore, :replace, :append]
    REPLACE = nil
    APPEND = nil

    ALL = constants(false) #.map { |c| const_get(c) }.freeze
  end

  class_methods do
    def strategy_attribute_for(field_name)
      "update_#{field_name}_strategy".to_sym
    end

    def strategies_for(field_name)
      if unappendable_fields.include? field_name
        BatchForm::UpdateStrategies::ALL - [:APPEND]
      else
        BatchForm::UpdateStrategies::ALL
      end
    end
  end

  included do
    after_initialize :default_to_ignore!

    def default_to_ignore!
      self.class.batch_fields.each do |field_name|
        self.send("#{self.class.strategy_attribute_for(field_name)}=", :IGNORE) if self.send(self.class.strategy_attribute_for(field_name)) == nil

      end
    end

    def object_update_parameters(current_work)
      own_parameters = self.class.batch_fields.map do |field_name|
        new_value = self.send(field_name)
        strategy = self.send(self.class.strategy_attribute_for(field_name))&.to_sym

        if strategy == :IGNORE
          # well ignore :)
        elsif strategy == :REPLACE
          [field_name, new_value]
        elsif strategy == :APPEND
          current_value = current_work.send(field_name)
          if current_value.nil? || self.class.unappendable_fields.include?(field_name)
            [field_name, new_value]
          else
            [field_name, [current_value,new_value].join(" ")]
          end
        end
      end.compact.to_h
      if self.is_a? Work
        own_parameters[:appraisals_attributes] = {"0"=>appraisal.object_update_parameters(Appraisal.new)}
      end
      own_parameters
    end

    def not_to_ignore_paramaters
      self.attributes
      @parameters.keys
    end
  end
end


class BatchAppraisalForm < Appraisal
  BATCH_FIELDS = %w{appraised_by appraised_on replacement_value market_value replacement_value_range market_value_range reference}.sort_by(&:length).reverse.map(&:to_sym)
  UNAPPENDABLE_FIELDS = BATCH_FIELDS.select{|field_name| field_name.to_s.ends_with?("_id")}

  def self.batch_fields
    BATCH_FIELDS
  end

  def self.unappendable_fields
    UNAPPENDABLE_FIELDS
  end

  include BatchForm

  BATCH_FIELDS.each do |field_name|
    attribute strategy_attribute_for(field_name)
  end

  def model_name
    ActiveModel::Name.new(Appraisal, nil, "appraisals_attributes_0")
  end
end

class BatchWorkForm < Work
  BATCH_FIELDS = %w{location location_floor location_detail cluster_id cluster_name subset_id technique_ids source_ids collection_id placeability_id theme_ids grade_within_collection tag_list}.sort_by(&:length).reverse.map(&:to_sym)
  UNAPPENDABLE_FIELDS = BATCH_FIELDS.select{|field_name| field_name.to_s.ends_with?("_id") || [:grade_within_collection].include?(field_name)}

  def self.batch_fields
    BATCH_FIELDS
  end

  def self.unappendable_fields
    UNAPPENDABLE_FIELDS
  end

  include BatchForm

  BATCH_FIELDS.each do |field_name|
    attribute strategy_attribute_for(field_name)
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
  end
end

class BatchController < ApplicationController
  before_action :set_collection
  before_action :set_works_by_numbers

  include BatchMethods

  def show
    @form.default_to_ignore!
  end

  def update
    @form = BatchWorkForm.new(work_params.to_h.deep_merge(work_batch_strategies_params))
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

  def can_edit_field?(field_name)
    editable_fields.include? field_name
  end
  helper_method :can_edit_field?

  private

  def separate_by parameter, by
    parameter.to_s.split(by).map(&:strip).select(&:present?)
  end

  def work_batch_strategies_params
    params.require(:work).permit(
      (editable_fields & BatchWorkForm::BATCH_FIELDS).map{|f| BatchWorkForm.strategy_attribute_for(f)}, {
        appraisals_attributes: (editable_appraisal_fields & BatchAppraisalForm::BATCH_FIELDS).map{|f| BatchAppraisalForm.strategy_attribute_for(f)}
      }

    )
  end
end
