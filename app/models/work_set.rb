class WorkSet < ApplicationRecord
  has_and_belongs_to_many :works

  has_many :appraisals, as: :appraisee

  belongs_to :work_set_type

  scope :accepts_appraisals, ->{ joins(:work_set_type).where(work_set_types: {appraise_as_one: true})}
  scope :count_as_one, ->{ joins(:work_set_type).where(work_set_types: {count_as_one: true})}

  alias_attribute :stock_number, :identification_number

  validate :works_are_not_appraisable_in_another_set, if: :work_set_type
  validate :works_are_not_countable_as_one_in_another_set, if: :work_set_type

  def appraisable?
    work_set_type.appraise_as_one? && works.length > 0
  end

  def count_as_one?
    work_set_type.count_as_one? && works.length > 0
  end

  def work_set_type_name
    work_set_type.name
  end

  def name
    [work_set_type_name, identification_number].join(" - ")
  end

  def replacement_value
    appraisals.last&.replacement_value
  end
  def market_value
    appraisals.last&.market_value
  end
  def market_value_range
    appraisals.last&.market_value_range
  end
  def replacement_value_range
    appraisals.last&.replacement_value_range
  end


  def update_latest_appraisal_data!
    latest_appraisal = appraisals.descending_appraisal_on.first
    works_count = works.count
    if appraisable?
      works.each do |work|
        if latest_appraisal
          work.market_value = latest_appraisal.market_value ? (latest_appraisal.market_value / works_count).round : nil
          work.replacement_value = latest_appraisal.replacement_value ? (latest_appraisal.replacement_value / works_count).round : nil
          work.replacement_value_min = latest_appraisal.replacement_value_min ? (latest_appraisal.replacement_value_min / works_count).round : nil
          work.replacement_value_max = latest_appraisal.replacement_value_max ? (latest_appraisal.replacement_value_max / works_count).round : nil
          work.market_value_min = latest_appraisal.market_value_min ? (latest_appraisal.market_value_min / works_count).round : nil
          work.market_value_max = latest_appraisal.market_value_max ? (latest_appraisal.market_value_max / works_count).round : nil
          work.price_reference = latest_appraisal.reference
          work.valuation_on = latest_appraisal.appraised_on
          work.appraisal_notice = latest_appraisal.notice
        else
          work.market_value = nil
          work.replacement_value = nil
          work.replacement_value_min = nil
          work.replacement_value_max = nil
          work.market_value_min = nil
          work.market_value_max = nil
          work.price_reference = nil
          work.valuation_on = nil
          work.appraisal_notice = nil
        end
        work.save

      end
    end
  end


  def can_be_accessed_by_user?(user)
    !!(user.admin? || most_specific_shared_collection&.can_be_accessed_by_user?(user))
  end

  # returns the collection that most specific to the user
  def most_specific_shared_collection
    paths = works.map{|w| w.collection.expand_with_parent_collections.not_system.pluck(:id) }
    shortest_path = paths.sort{|a,b| a.length <=> b.length}.first
    shortest_path_index = shortest_path.length - 1
    while shortest_path_index >= 0
      search_id = shortest_path[shortest_path_index]
      paths_include_search_id = paths.map{|a| a.include?(search_id)}
      all_paths_include_search_id = !paths_include_search_id.include?(false)
      return Collection.find(search_id) if all_paths_include_search_id
      shortest_path_index -= 1
    end
  end

  def works_are_not_appraisable_in_another_set
    if appraisable?
      works.each do |work|
        errors.add(:base, "#{work.name} wordt reeds gewaardeerd vanuit een andere groepering.") if work.appraisable_set && work.appraisable_set != self
      end
    end
  end

  def works_are_not_countable_as_one_in_another_set
    if count_as_one?
      works.each do |work|
        errors.add(:base, "#{work.name} wordt reeds uniek geteld vanuit een andere groepering.") if work.countable_set && work.appraisable_set != self
      end
    end
  end
end
