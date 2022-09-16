# frozen_string_literal: true

class Batch::WorkForm < Work
  BATCH_FIELDS = %w[purchase_price purchased_on purchase_year source_comments other_comments selling_price minimum_bid location location_floor location_detail cluster_id cluster_name subset_id technique_ids source_ids collection_id placeability_id theme_ids grade_within_collection tag_list work_status_id balance_category_id for_rent for_purchase highlight publish].sort_by(&:length).reverse.map(&:to_sym)
  UNAPPENDABLE_FIELDS = BATCH_FIELDS.select { |field_name| field_name.to_s.ends_with?("_id") || [:grade_within_collection, :for_rent, :for_purchase, :highlight].include?(field_name) }
  REMOVABLE_FIELDS = %w[tag_list].map(&:to_sym)

  before_validation :validate_appraisal

  include Batch::BaseForm

  attr_writer :cluster_name
  attr_reader :cluster_name

  def model_name
    Work.new.model_name
  end

  def appraisal
    @appraisal ||= Batch::AppraisalForm.new(appraised_on: Time.now, update_appraised_on_strategy: :replace)
  end

  def appraisals_attributes= options
    @appraisal = Batch::AppraisalForm.new(options["0"])
  end

  def update_work!(work)
    work.update!(object_update_parameters(work))
    unless appraisal.empty_params?
      Appraisal.create!(appraisal.appraisal_params.merge(appraisee: work))
    end
  end

  def ignore_validation_errors?
    false
  end

  def validate_appraisal
    appraisal.appraisee = Work.new(collection: Collection.new)
    errors.merge!(appraisal.errors) if !appraisal.ignore_validation_errors? && !appraisal.valid?
  end
end
