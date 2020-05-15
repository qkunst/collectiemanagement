# frozen_string_literal: true

require_relative "../uploaders/picture_uploader"
class Work < ApplicationRecord
  SORTING_FIELDS = [:inventoried_at, :stock_number, :created_at]
  GRADES_WITHIN_COLLECTION = %w[A B C D E F G W]

  include ActionView::Helpers::NumberHelper
  include FastAggregatable
  include MethodCache
  include Searchable

  include Work::Caching
  include Work::Export
  include Work::ParameterRerendering
  include Work::PreloadRelationsForDisplay
  include Work::Search

  has_paper_trail

  has_cache_for_method :tag_list
  has_cache_for_method :collection_locality_artist_involvements_texts

  before_save :set_empty_values_to_nil
  before_save :sync_purchase_year
  before_save :enforce_nil_or_true
  before_save :update_created_by_name
  before_save :convert_purchase_price_in_eur
  after_save :touch_collection!
  after_save :update_artist_name_rendered!
  before_save :cache_tag_list!
  before_save :cache_collection_locality_artist_involvements_texts!

  belongs_to :cluster, optional: true
  belongs_to :collection
  belongs_to :owner, optional: true
  belongs_to :condition_frame, class_name: "Condition", optional: true
  belongs_to :condition_work, class_name: "Condition", optional: true
  belongs_to :created_by, class_name: "User", optional: true
  belongs_to :frame_type, optional: true
  belongs_to :medium, optional: true
  belongs_to :placeability, optional: true
  belongs_to :purchase_price_currency, class_name: "Currency", optional: true
  belongs_to :style, optional: true
  belongs_to :subset, optional: true
  belongs_to :work_status, optional: true
  belongs_to :geoname_summary, foreign_key: :locality_geoname_id, primary_key: :geoname_id, optional: true
  has_and_belongs_to_many :artists, -> { distinct }, after_add: :touch_updated_at, after_remove: :touch_updated_at
  has_and_belongs_to_many :damage_types, -> { distinct }, after_add: :touch_updated_at, after_remove: :touch_updated_at
  has_and_belongs_to_many :frame_damage_types, -> { distinct }, after_add: :touch_updated_at, after_remove: :touch_updated_at
  has_and_belongs_to_many :object_categories, -> { distinct }, after_add: :touch_updated_at, after_remove: :touch_updated_at
  has_and_belongs_to_many :sources, -> { distinct }, after_add: :touch_updated_at, after_remove: :touch_updated_at
  has_and_belongs_to_many :techniques, -> { distinct }, after_add: :touch_updated_at, after_remove: :touch_updated_at
  has_and_belongs_to_many :themes, -> { distinct }, after_add: :touch_updated_at, after_remove: :touch_updated_at
  has_and_belongs_to_many :custom_reports
  has_and_belongs_to_many :attachments
  has_many :appraisals
  has_many :messages, as: :subject_object

  scope :artist, ->(artist) { joins("INNER JOIN artists_works ON works.id = artists_works.work_id").where(artists_works: {artist_id: artist.id}) }
  scope :has_number, ->(number) { number.blank? ? none : where(stock_number: number).or(where(alt_number_1: number)).or(where(alt_number_2: number)).or(where(alt_number_3: number)) }
  scope :id, ->(ids) { where(id: ids) }
  scope :no_photo_front, -> { where(photo_front: nil) }
  scope :order_by, ->(sort_key) do
    case sort_key.to_sym
    when :location
      order(:location, Arel.sql("works.location_floor = '-3' DESC, works.location_floor = '-2' DESC, works.location_floor = '-1' DESC, works.location_floor = '0' DESC, works.location_floor = 'BG' DESC"), :location_floor, :location_detail)
    when :created_at
      order(created_at: :desc)
    when :artist_name, :artist_name_rendered
      left_outer_joins(:artists).order(Arel.sql("artists.id IS NULL ASC, artists.last_name ASC, artists.first_name ASC"))
    when :stock_number
      order(:stock_number)
    end
  end
  scope :published, -> { where(publish: true) }

  accepts_nested_attributes_for :artists
  accepts_nested_attributes_for :appraisals

  validates_with Validators::CollectionScopeValidator

  acts_as_taggable

  normalize_attributes :location, :stock_number, :alt_number_1, :alt_number_2, :alt_number_3, :photo_front, :photo_back, :photo_detail_1, :photo_detail_2, :title, :print, :grade_within_collection, :entry_status, :abstract_or_figurative, :location_detail

  mount_uploader :photo_front, PictureUploader
  mount_uploader :photo_back, PictureUploader
  mount_uploader :photo_detail_1, PictureUploader
  mount_uploader :photo_detail_2, PictureUploader

  time_as_boolean :inventoried
  time_as_boolean :refound
  time_as_boolean :new_found

  attr_localized :frame_height, :frame_width, :frame_depth, :frame_diameter, :height, :width, :depth, :diameter

  accepts_nested_attributes_for :appraisals

  def photos?
    photo_front? || photo_back? || photo_detail_1? || photo_detail_2?
  end

  # This method is built to be fault tolerant and tries to make the best out of user given input.
  def purchased_on= date
    if date.is_a? String
      begin
        date = date.to_date
      rescue ArgumentError
      end
    end
    if date.is_a?(String) || date.is_a?(Numeric)
      date = date.to_i
      if (date > 1900) && (date < 2100)
        write_attribute(:purchase_year, date)
      end
    else
      if date.is_a?(Date) || date.is_a?(Time) || date.is_a?(DateTime)
        write_attribute(:purchased_on, date)
        write_attribute(:purchase_year, date.year)
      end
    end
  end

  def cluster_name= name
    stripped_name = name.to_s.strip
    if stripped_name == ""
      self.cluster = nil
    else
      clust = collection.available_clusters.find_by_case_insensitive_name(stripped_name).first
      self.cluster = clust
      if cluster.nil?
        self.cluster = collection.base_collection.clusters.create!(name: stripped_name)
      end
    end
  end

  def sync_purchase_year
    if purchased_on
      self.purchase_year = purchased_on.year
    end
  end

  def can_be_accessed_by_user?(user)
    user.admin? || collection.can_be_accessed_by_user?(user)
  end

  def geoname_ids
    ids = artists.flat_map(&:cached_geoname_ids)
    ids << locality_geoname_id if locality_geoname_id
    GeonameSummary.where(geoname_id: ids).with_parents.select(:geoname_id).collect { |a| a.geoname_id }
  end

  def alt_numbers
    nrs = [alt_number_1, alt_number_2, alt_number_3]
    nrs if nrs.count > 0
  end

  def purchase_price_symbol
    purchase_price_currency ? purchase_price_currency.symbol : "€"
  end

  def dimension_to_s value, nil_value = nil
    value ? number_with_precision(value, precision: 5, significant: true, strip_insignificant_zeros: true) : nil_value
  end

  def main_collection
    read_attribute(:main_collection) ? true : nil
  end

  def collection_external_reference_code
    collection&.external_reference_code
  end

  def all_work_ids_in_collection
    return @all_work_ids_in_collection if @all_work_ids_in_collection
    order = [collection.sort_works_by, collection.parent_collection.try(:sort_works_by), :stock_number, :id]

    relative_collection = !order[0] && order[1] ? collection.parent_collection : collection

    @all_work_ids_in_collection ||= relative_collection.works_including_child_works.select(:id).order(order.compact).collect { |a| a.id }
  end

  def work_index_in_collection
    @work_index_in_collection ||= all_work_ids_in_collection.index(id)
  end

  def next
    next_work_id = all_work_ids_in_collection[work_index_in_collection + 1]
    next_work_id ? Work.find(next_work_id) : Work.find(all_work_ids_in_collection.first)
  end

  def previous
    prev_work_id = all_work_ids_in_collection[work_index_in_collection - 1]
    prev_work_id ? Work.find(prev_work_id) : Work.find(all_work_ids_in_collection.last)
  end

  def set_empty_values_to_nil
    # especially important for elasticsearch filtering on empty values!
    if grade_within_collection.is_a?(String) && (grade_within_collection.strip == "")
      self.grade_within_collection = nil
    end

    if public_description == ""
      self.public_description = nil
    end
  end

  def report_val_sorted_artist_ids
    artists.order_by_name.distinct.collect { |a| a.id }.sort.join(",")
  end

  def report_val_sorted_object_category_ids
    object_categories.uniq.collect { |a| a.id }.sort.join(",")
  end

  def report_val_sorted_technique_ids
    techniques.uniq.collect { |a| a.id }.sort.join(",")
  end

  def report_val_sorted_theme_ids
    themes.uniq.collect { |a| a.id }.sort.join(",")
  end

  def location_history(skip_current: false, empty_locations: true)
    location_versions = []
    uniq_location_versions = []
    versions.each_with_index do |version, index|
      location_versions[index] = {created_at: version.created_at, event: version.event, user: User.where(id: version.whodunnit).first&.name}
      if version.object && (index > 0)
        reified_object = version.reify
        location_versions[index - 1][:location] = reified_object.location
        location_versions[index - 1][:location_floor] = reified_object.location_floor
        location_versions[index - 1][:location_detail] = reified_object.location_detail
      end
    end

    # complete with latest info
    index = location_versions.count

    if index > 0
      location_versions[index - 1][:location] = location
      location_versions[index - 1][:location_floor] = location_floor
      location_versions[index - 1][:location_detail] = location_detail

      # filter out irrelevant changes
      uniq_location_versions = [location_versions[0]]
      location_versions.each do |location_version|
        last_uniq_location_version = uniq_location_versions.last
        last_uniq_location_description = last_uniq_location_version.fetch_values(:location, :location_floor, :location_detail).join("")
        location_version_description = location_version.fetch_values(:location, :location_floor, :location_detail).join("")

        if (last_uniq_location_description != location_version_description) && (empty_locations || !location_version_description.blank?)
          uniq_location_versions << location_version
        end
      end
      if skip_current && (empty_locations == true || location_description)
        uniq_location_versions.pop
      end
      uniq_location_versions
    else
      []
    end
  end

  def restore_last_location_if_blank!
    unless location_description
      prev_location = location_history(skip_current: true, empty_locations: false).last
      if prev_location
        self.location = prev_location[:location]
        self.location_detail = prev_location[:location_detail]
        self.location_floor = prev_location[:location_floor]
        save!
      end
    end
  end

  def available_themes
    collection.available_themes
  end

  def add_lognoteline note
    self.lognotes = lognotes.to_s + "\n#{note}"
  end

  def title= titel
    if titel.to_s.strip == ""
      write_attribute(:title, nil)
    elsif ["zonder titel", "onbekend"].include? titel.to_s.strip.downcase
      write_attribute(:title_unknown, true)
    else
      write_attribute(:title, titel)
    end
  end

  def object_creation_year= year
    if year.to_i > 0
      write_attribute(:object_creation_year, year)
    elsif ["geen jaar", "zonder jaartal", "onbekend"].include? year.to_s
      write_attribute(:object_creation_year_unknown, true)
    end
  end

  def object_creation_year
    object_creation_year_unknown ? nil : read_attribute(:object_creation_year)
  end

  def signature_comments= sig
    if sig.to_s.strip == ""
      write_attribute(:signature_comments, nil)
    elsif sig.to_s.strip.downcase == "niet gesigneerd"
      write_attribute(:no_signature_present, true)
    else
      write_attribute(:signature_comments, sig)
    end
  end

  def enforce_nil_or_true
    self.main_collection = nil if main_collection == false
  end

  def touch_updated_at(*)
    touch if persisted?
  end

  def touch_collection!
    collection&.touch
  end

  def public_tag_list
    Array(cached_tag_list).select do |item|
      !item.match(/(^((.+)\d\d\d\d)$)|(vermist)|(bekijKen op)|(aangetroffen)|(naar fotograaf)|(selectie)|(^[hn]\d\s)|(ontzamelen)|(aankopen)|(herplaatsen)|(navragen)|(Herplaatsing)/i)
    end.compact
  end

  def convert_purchase_price_in_eur
    self.purchase_price_in_eur = purchase_price_currency.to_eur(purchase_price) if purchase_price && purchase_price_currency
  end

  class << self
    def collect_locations
      rv = {}
      group(:location).count.sort { |a, b| a[0].to_s.downcase <=> b[0].to_s.downcase }.each { |a| rv[a[0]] = {count: a[1], subs: []} }
      rv
    end

    def human_attribute_name_for_alt_number_field(field_name, collection)
      custom_label_name = collection ? collection.send("label_override_work_#{field_name}_with_inheritance".to_sym) : nil
      custom_label_name || Work.human_attribute_name(field_name)
    end

    def human_attribute_name_overridden(field_name, collection)
      if [:alt_number_1, :alt_number_2, :alt_number_3].include? field_name
        human_attribute_name_for_alt_number_field(field_name, collection)
      else
        Work.human_attribute_name(field_name)
      end
    end

    def column_types
      return @@column_types if defined?(@@column_types)
      @@column_types = Work.columns.collect { |a| [a.name, a.type] }.to_h
      @@column_types["inventoried"] = :boolean
      @@column_types["refound"] = :boolean
      @@column_types["new_found"] = :boolean
      @@column_types
    end
  end
end
