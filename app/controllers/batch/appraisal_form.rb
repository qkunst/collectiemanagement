# frozen_string_literal: true

class Batch::AppraisalForm < Appraisal
  BATCH_FIELDS = %w[appraised_by appraised_on replacement_value market_value replacement_value_range market_value_range reference notice].sort_by(&:length).reverse.map(&:to_sym)
  UNAPPENDABLE_FIELDS = BATCH_FIELDS # .select{|field_name| field_name.to_s.ends_with?("_id")}
  REMOVABLE_FIELDS = %w[]

  include Batch::BaseForm

  def market_value_range
    super_value = super

    (super_value.min.to_i..super_value.max.to_i).to_s if super_value
  end

  def replacement_value_range
    super_value = super

    (super_value.min.to_i..super_value.max.to_i).to_s if super_value
  end

  def model_name
    ActiveModel::Name.new(Appraisal, nil, "appraisals_attributes_0")
  end

  def appraisal_params
    object_update_parameters(Appraisal.new)
  end

  def empty_params?
    # TODO: should be appraisal_params.select { |k, v| ![:appraised_on, :appraised_by].include?(k) }.empty?

    appraisal_params.select { |k, v| k != :appraised_on }.empty?
  end
  alias_attribute :ignore_validation_errors?, :empty_params?
end
