# frozen_string_literal: true

# == Schema Information
#
# Table name: work_sets
#
#  id                    :bigint           not null, primary key
#  appraisal_notice      :text
#  comment               :text
#  deactivated_at        :datetime
#  identification_number :string
#  uuid                  :string
#  works_filter_params   :json
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  work_set_type_id      :bigint
#
class WorkSet < ApplicationRecord
  include Uuid
  include Works::Filtering # Controller concern

  has_and_belongs_to_many :works, touch: true

  has_many :appraisals, as: :appraisee
  has_many :time_spans, as: :subject

  belongs_to :work_set_type

  scope :accepts_appraisals, -> { joins(:work_set_type).where(work_set_types: {appraise_as_one: true}) }
  scope :count_as_one, -> { joins(:work_set_type).where(work_set_types: {count_as_one: true}) }
  scope :for_unexpanded_collections, ->(collections) { WorkSet.where(id: joins(:works).where(works: {collection_id: collections}).pluck(:id).uniq) }
  scope :for_collection, ->(collection) { for_unexpanded_collections(collection.self_and_parent_collections_flattened + collection.child_collections_flattened) }
  scope :not_deactivated, -> { where(deactivated_at: nil) }
  scope :not_dynamic, -> { where(works_filter_params: nil) }
  scope :dynamic, -> { where.not(works_filter_params: nil) }

  alias_attribute :stock_number, :identification_number

  validate :works_are_not_appraisable_in_another_set, if: :work_set_type
  validate :works_are_not_countable_as_one_in_another_set, if: :work_set_type

  before_validation :add_works_to_active_time_span

  after_save :significantly_update_works!

  time_as_boolean :deactivated

  class << self
    def names_hash
      unless defined?(@@names_hash) && @@names_hash[to_s]
        @@names_hash = {} unless defined?(@@names_hash)
        @@names_hash[to_s] = {}
        self.select("id,identification_number,work_set_type_id").each do |objekt|
          @@names_hash[to_s][objekt.id] = objekt.name
        end
      end
      @@names_hash[to_s]
    end

    def names ids
      if ids.is_a? String
        ids = [ids.to_i]
      elsif ids.is_a? Integer
        ids = [ids]
      end
      rv = {}
      ids.each do |id|
        rv[id] = names_hash[id] || "Naamloos"
      end
      rv
    end

    def find_by_uuid_or_id(uuid_or_id)
      find_by_uuid_or_id!(uuid_or_id)
    rescue ActiveRecord::RecordNotFound
    end

    def find_by_uuid_or_id!(uuid_or_id)
      if uuid_or_id.nil?
        raise ActiveRecord::RecordNotFound
      elsif uuid_or_id.is_a?(Integer) || uuid_or_id.match?(/\A\d+\z/)
        find(uuid_or_id)
      else
        find_by!(uuid: uuid_or_id)
      end
    end
  end

  def appraisable?
    work_set_type.appraise_as_one? && works.length > 0
  end

  def available?
    !works.map(&:available?).include?(false)
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

  def replacement_value_min
    appraisals.last&.replacement_value_min
  end

  def market_value_min
    appraisals.last&.market_value_min
  end

  def replacement_value_max
    appraisals.last&.replacement_value_max
  end

  def market_value_max
    appraisals.last&.market_value_max
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

  def current_active_time_span
    @current_active_time_span ||= time_spans.order(starts_at: :desc).find(&:current_and_active?)
  end

  def can_be_accessed_by_user?(user)
    !!(user.admin? || most_specific_shared_collection&.can_be_accessed_by_user?(user))
  end

  # returns the collection that most specific to the user
  def most_specific_shared_collection
    paths = works.map { |w| w.collection.expand_with_parent_collections.not_system.pluck(:id) }
    shortest_path = paths.min_by(&:length)
    if shortest_path
      shortest_path_index = shortest_path.length - 1
      while shortest_path_index >= 0
        search_id = shortest_path[shortest_path_index]
        paths_include_search_id = paths.map { |a| a.include?(search_id) }
        all_paths_include_search_id = !paths_include_search_id.include?(false)
        return Collection.find(search_id) if all_paths_include_search_id

        shortest_path_index -= 1
      end
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
        errors.add(:base, "#{work.name} wordt reeds geteld vanuit een groepering die het als 1 werk telt.") if work.countable_set && work.appraisable_set != self
      end
    end
  end

  def significantly_update_works!
    works.significantly_updated!
  end
  alias_method :significantly_updated!, :significantly_update_works!

  def add_works_to_active_time_span
    current_active_time_span&.save
  end

  def current_user
    User.new(admin: true)
  end

  def dynamic= bool
    bool = ActiveRecord::Type::Boolean.new.cast(bool)
    if bool == false
      self.works_filter_params = nil
    end
  end

  def dynamic
    !works_filter_params.blank? && (works_filter_params[:collection_id].present? || works_filter_params["collection_id"].present?)
  end
  alias_method :dynamic?, :dynamic

  attr_reader :params, :collection

  def update_with_works_filter_params(last_run: nil)
    return nil if !dynamic?

    @params = ActiveSupport::HashWithIndifferentAccess.new(works_filter_params)
    @collection = Collection.find(@params[:collection_id])

    return nil if @collection.works_including_child_works.where(significantly_updated_at: ((last_run - 1.minute)...)).empty?

    set_all_filters

    set_works

    self.works = @works
  end
end
