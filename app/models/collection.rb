# frozen_string_literal: true

# == Schema Information
#
# Table name: collections
#
#  id                                        :bigint           not null, primary key
#  api_setting_expose_only_published_works   :boolean
#  appraise_with_ranges                      :boolean          default(FALSE)
#  base                                      :boolean
#  collection_name_extended_cache            :text
#  commercial                                :boolean
#  default_collection_attributes_for_artists :text             default(["\"website\"", "\"email\"", "\"telephone_number\"", "\"description\""]), is an Array
#  default_collection_attributes_for_works   :text             default([]), is an Array
#  derived_work_attributes_present_cache     :text
#  description                               :text
#  exposable_fields                          :text
#  external_reference_code                   :string
#  geoname_ids_cache                         :text
#  internal_comments                         :text
#  label_override_work_alt_number_1          :string
#  label_override_work_alt_number_2          :string
#  label_override_work_alt_number_3          :string
#  name                                      :string
#  pdf_title_export_variants_text            :text
#  qkunst_managed                            :boolean          default(TRUE)
#  root                                      :boolean          default(FALSE)
#  show_availability_status                  :boolean
#  show_library                              :boolean
#  sort_works_by                             :string
#  supported_languages                       :text             default(["\"nl\""]), is an Array
#  unique_short_code                         :string
#  work_attributes_present_cache             :text
#  created_at                                :datetime         not null
#  updated_at                                :datetime         not null
#  parent_collection_id                      :bigint           default(1)
#
# Indexes
#
#  index_collections_on_unique_short_code  (unique_short_code) UNIQUE
#

class Collection < ApplicationRecord
  include MethodCache
  include Collection::Hierarchy

  DEFAULT_PDF_TITLE_CONFIGURATION = {
    show_logo: true,
    resource_variant: "public",
    foreground_color: "000000"
  }

  class CollectionBaseError < StandardError
  end

  class FakeSuperCollection
    def name
      "Algemeen"
    end

    def themes
      Theme.general
    end

    def not_hidden_themes
      themes.not_hidden
    end
  end

  belongs_to :parent_collection, class_name: "Collection", optional: true

  has_and_belongs_to_many :users
  has_and_belongs_to_many :stages

  has_many :attachments
  has_many :batch_photo_uploads
  has_many :child_collections, class_name: "Collection", foreign_key: "parent_collection_id"
  has_many :clusters
  has_many :collections, class_name: "Collection", foreign_key: "parent_collection_id"
  has_many :collections_geoname_summaries
  has_many :collection_attributes
  has_many :custom_reports
  has_many :geoname_summaries, through: :collections_geoname_summaries
  has_many :import_collections
  has_many :simple_import_collections
  has_many :themes
  has_many :works
  has_many :owners
  has_many :messages, as: :subject_object
  has_many :collections_stages
  has_many :reminders
  has_many :library_items
  has_many :locations
  has_many :time_spans
  has_many :contacts

  validates_uniqueness_of :unique_short_code, allow_nil: true
  validate :pdf_title_export_variants_text_valid?

  has_cache_for_method :geoname_ids, trigger: :before_save
  has_cache_for_method :collection_name_extended
  has_cache_for_methods :work_attributes_present, :derived_work_attributes_present, as: :symbols, trigger: :before_save

  has_paper_trail # only enabled in may 2020

  default_scope -> { order(Arel.sql("REPLACE(collections.collection_name_extended_cache, '\"', '') ASC")) }

  scope :without_parent, -> { where(parent_collection_id: nil) }
  scope :not_hidden, -> { where("1=1") }
  scope :not_system, -> { not_root }
  scope :qkunst_managed, -> { where(qkunst_managed: true) }

  before_save :attach_sub_collection_ownables_when_base

  after_create :copy_default_reminders!
  after_save :touch_works_including_child_works!
  after_save :cache_all_collection_name_extended!

  after_commit :touch_parent

  KEY_MODEL_RELATIONS = {
    "artists" => "Artist",
    "themes" => "Theme",
    "object_categories" => "ObjectCategory",
    "object_categories_split" => "ObjectCategory",
    "techniques" => "Technique",
    "condition_frame" => "Condition",
    "techniques_split" => "Technique",
    "condition_work" => "Condition",
    "frame_damage_types" => "FrameDamageType",
    "damage_types" => "DamageType",
    "placeability" => "Placeability",
    "balance_category" => "BalanceCategory",
    "style" => "Style",
    "subset" => "Subset",
    "source" => "Source",
    "sources" => "Source",
    "cluster" => "Cluster",
    "owner" => "Owner",
    "frame_type" => "FrameType",
    "work_status" => "WorkStatus",
    "work_sets" => "WorkSet",
    "collection_attributes" => "CollectionAttribute"
  }

  def find_state_of_stage(stage)
    collections_stages.to_a.each do |cs|
      return cs if cs.stage == stage
    end
    nil
  end

  def work_sets
    WorkSet.for_collection(self)
  end

  def base_collection
    @base_collection ||= if base
      self
    else
      base_collections.last || self
    end
  end

  def base_collections
    expand_with_parent_collections(:asc).not_system.where(base: true)
  end

  def super_base_collection
    base_collections.first || self
  end

  def base_collection?
    base_collection == self
  end

  def collections_stages?
    collections_stages.count > 0
  end

  def parent_collection_with_stages
    unless collections_stages?
      parent_collections_flattened.reverse_each do |coll|
        return coll if coll.collections_stages?
      end
    end
    nil
  end

  def appraise_with_ranges
    read_attribute(:appraise_with_ranges) || (self_and_parent_collections_flattened.where(appraise_with_ranges: true).count > 0)
  end
  alias_method :appraise_with_ranges?, :appraise_with_ranges

  def show_availability_status
    @show_availability_status ||= read_attribute(:show_availability_status) || (self_and_parent_collections_flattened.where(show_availability_status: true).count > 0)
  end
  alias_method :show_availability_status?, :show_availability_status

  def sort_works_by= value
    write_attribute(:sort_works_by, (Work::SORTING_FIELDS & [value.to_sym]).first)
  end

  def sort_works_by
    read_attribute(:sort_works_by).try(:to_sym)
  end

  def geoname_ids
    geoname_summaries.collect { |a| a.geoname_id }
  end

  def geoname_summaries?
    cached_geoname_ids && cached_geoname_ids.count > 0
  end

  def unique_short_code_from_self_or_base
    unique_short_code || base_collection.unique_short_code
  end

  def self_or_parent_collection_with_geoname_summaries
    if geoname_summaries?
      return self
    else
      parent_collections_flattened.reverse_each do |coll|
        return coll if coll.geoname_summaries?
      end
    end

    nil
  end

  def collections_stage_delivery_on
    if collections_stages.delivery.count > 0
      rv = collections_stages.delivery.first.completed_at
      rv&.to_date
    end
  end

  def collections_stage_delivery_on= date
    if collections_stages.delivery.count > 0
      collections_stage = collections_stages.delivery.first
      collections_stage.completed_at = date
      collections_stage.save
    end
  end

  def artists(works_where_clause = {})
    Artist.works(works_including_child_works.where(works_where_clause))
  end

  def works_including_child_works
    Work.where(collection: expand_with_child_collections)
  end

  def attachments_including_child_attachments
    Attachment.where(collection: expand_with_child_collections)
  end

  def attachments_including_parent_attachments
    Attachment.where(collection: expand_with_parent_collections)
  end

  def library_items_including_child_library_items
    LibraryItem.where(collection: expand_with_child_collections)
  end

  def library_items_including_parent_library_items
    LibraryItem.where(collection: expand_with_parent_collections)
  end

  def work_attributes_present
    direct_work_attributes = Work.attributes_present
    relations = (Work.has_manies + Work.has_and_belongs_to_manies).select { |a| works.joins(a).any? }
    relations + direct_work_attributes
  end

  def derived_work_attributes_present
    direct_attributes = cached_work_attributes_present
    {
      work_status: -> { direct_attributes.include?(:work_status_id) },
      highlight: -> { direct_attributes.include?(:highlight_priority) },
      for_purchase: -> { direct_attributes.include?(:for_purchase_at) },
      for_rent: -> { direct_attributes.include?(:for_rent) },
      alt_number_4: -> { false },
      alt_number_5: -> { false },
      alt_number_6: -> { false },
      medium: -> { direct_attributes.include?(:medium_id) },
      frame_type: -> { direct_attributes.include?(:frame_type_id) },
      signature_rendered: -> { direct_attributes.include?(:signature_comments) },
      object_format_code: -> { true },
      work_size: -> { direct_attributes.include?(:height) || direct_attributes.include?(:width) },
      frame_size: -> { direct_attributes.include?(:frame_height) || direct_attributes.include?(:frame_width) },
      floor_surface: -> { direct_attributes.include?(:frame_depth) || direct_attributes.include?(:frame_width) || direct_attributes.include?(:depth) || direct_attributes.include?(:width) },
      wall_surface: -> { direct_attributes.include?(:frame_height) || direct_attributes.include?(:frame_width) || direct_attributes.include?(:height) || direct_attributes.include?(:width) },
      abstract_or_figurative_rendered: -> { direct_attributes.include?(:abstract_or_figurative) },
      style: -> { direct_attributes.include?(:style_id) },
      subset: -> { direct_attributes.include?(:subset_id) },
      collection_name_extended: -> { true },
      locality_geoname_name: -> { direct_attributes.include?(:locality_geoname_id) },
      cluster: -> { direct_attributes.include?(:cluster_id) },
      print_rendered: -> { direct_attributes.include?(:print) || direct_attributes.include?(:print_unknown) },
      cached_tag_list: -> { direct_attributes.include?(:tag_list_cache) },
      condition_work_rendered: -> { direct_attributes.include?(:condition_work_id) },
      condition_frame_rendered: -> { direct_attributes.include?(:condition_frame_id) },
      placeability: -> { direct_attributes.include?(:placeability_id) },
      owner: -> { direct_attributes.include?(:owner_id) },
      purchased_on_with_fallback: -> { direct_attributes.include?(:purchased_on) || direct_attributes.include?(:purchase_year) },
      market_value_complete: -> { direct_attributes.include?(:market_value) },
      replacement_value_complete: -> { direct_attributes.include?(:replacement_value) },
      market_value_range_complete: -> { direct_attributes.include?(:market_value_max) || direct_attributes.include?(:market_value_min) },
      replacement_value_range_complete: -> { direct_attributes.include?(:replacement_value_max) || direct_attributes.include?(:replacement_value_min) },
      default_rent_price: -> { direct_attributes.include?(:selling_price) },
      business_rent_price_ex_vat: -> { direct_attributes.include?(:selling_price) },
      balance_category: -> { direct_attributes.include?(:balance_category_id) }
    }.select { |k, v| k if v.call }.keys
  end

  def displayable_work_attributes_present
    Work::ParameterRendering::DISPLAYED_PROPERTIES & (cached_derived_work_attributes_present + cached_work_attributes_present)
  end

  def touch_parent
    parent_collection&.touch unless parent_collection == self
  end

  def touch_works_including_child_works!
    if previous_changes.key? "geoname_ids_cache"
      works_including_child_works.each { |a| a.save } # TODO: Turn into a worker
    elsif (["name", "parent_collection_id"] & previous_changes.keys).any?
      works_including_child_works.touch_all
    end
  end

  def available_clusters
    Cluster.for_collection(self)
  end

  def system?
    root?
  end

  def available_owners
    Owner.for_collection(self)
  end

  def available_themes(not_hidden: true)
    themes = Theme.for_collection_including_generic(self)
    themes = themes.not_hidden if not_hidden
    themes
  end

  def not_hidden_themes
    themes.not_hidden
  end

  def users_including_child_collection_users
    (users + expand_with_child_collections.flat_map { |c| c.users }).uniq
  end

  def users_including_parent_users
    (users + parent_collections_flattened.flat_map { |a| a.users_including_parent_users }).uniq
  end

  def exposable_fields= array
    write_attribute(:exposable_fields, array.collect { |a| a.to_s.strip if a && (a.to_s.strip != "") }.compact.join(","))
  end

  def collection_name_extended
    @collection_name_extended ||= self_and_parent_collections_flattened.map(&:name).join(" » ")
  end

  def pdf_title_export_variants
    parsed = YAML.load(pdf_title_export_variants_text.to_s, symbolize_names: true) || {}
    parsed = parsed.map { |k, v| [k, DEFAULT_PDF_TITLE_CONFIGURATION.merge(v)] }.to_h
    parsed[:default] = DEFAULT_PDF_TITLE_CONFIGURATION.merge(parsed[:default] || {})
    parsed
  end

  def cached_collection_name_extended_with_fallback
    cached_collection_name_extended || collection_name_extended
  end
  alias_method :to_label, :cached_collection_name_extended_with_fallback

  def exposable_fields
    read_attribute(:exposable_fields).to_s.split(",")
  end

  def fields_to_expose(audience = :default)
    case audience
    when :default
      if exposable_fields.count == 0
        Work.possible_exposable_fields
      else
        exposable_fields
      end
    when :simple
      ["stock_number", "alt_number_1", "alt_number_2", "alt_number_3", "id", "artists", "artist_unknown", "title", "title_unknown", "description", "object_creation_year", "object_creation_year_unknown", "object_categories", "techniques", "medium", "print", "print_unknown", "frame_width", "frame_height", "frame_depth", "frame_diameter", "width", "height", "depth", "diameter", "condition_work"]
    when :public
      forbidden_words = ["value", "price", "location", "condition", "information_back", "internal", "damage", "placeability", "other_comments", "source", "purchase", "grade_within_collection", "created_by", "appraisal", "valuation", "lognotes"]

      Work.possible_exposable_fields.select do |field_name|
        !forbidden_words.collect { |forbidden_word| !!field_name.match(forbidden_word) }.include?(true)
      end
    end
  end

  def elastic_aggragations
    return @elastic_aggragations if @elastic_aggragations

    elastic_report = search_works("", {}, {force_elastic: true, return_records: false, limit: 1, aggregations: Report::Builder.aggregations})
    @elastic_aggragations = elastic_report.aggregations
  rescue Faraday::ConnectionFailed => e
    SystemMailer.error_message(e).deliver_now
    false
  end

  def label_override_work_alt_number_1_with_inheritance
    self_and_parent_collections_flattened.collect { |a| a.label_override_work_alt_number_1 unless a.label_override_work_alt_number_1.to_s.strip == "" }.compact.last
  end

  def label_override_work_alt_number_2_with_inheritance
    self_and_parent_collections_flattened.collect { |a| a.label_override_work_alt_number_2 unless a.label_override_work_alt_number_2.to_s.strip == "" }.compact.last
  end

  def label_override_work_alt_number_3_with_inheritance
    self_and_parent_collections_flattened.collect { |a| a.label_override_work_alt_number_3 unless a.label_override_work_alt_number_3.to_s.strip == "" }.compact.last
  end

  def geoname_summary_values
    rv = {}
    geoname_summaries.each do |gs|
      rv[gs.name] = gs.geoname_id
    end
    rv
  end

  def search_works(search = "", filter = {}, options = {})
    Work.search_and_filter(search, filter.merge({collection: self}), options)
  end

  def can_be_accessed_by_user user
    !!(users_including_parent_users.include?(user) || user.super_admin? || (user.admin? && qkunst_managed?))
  end
  alias_method :can_be_accessed_by_user?, :can_be_accessed_by_user

  def copy_default_reminders!
    if reminders.count == 0
      Reminder.prototypes.each do |a|
        reminders << Reminder.new(a.to_hash)
      end
    end
  end

  def purge_old_indexed_works!
    skope = self
    elastic_ids = skope.search_works("", {}, {return_records: false, force_elastic: true}).collect { |a| a.id.to_i }
    db_ids = skope.works_including_child_works.select(:id).collect(&:id)

    elastic_ids_to_remove = elastic_ids - db_ids

    elastic_search = skope.works.__elasticsearch__
    index_name = elastic_search.index_name
    document_type = elastic_search.document_type

    elastic_ids_to_remove.collect do |elastic_id_to_remove|
      elastic_search.client.delete({
        index: index_name,
        type: document_type,
        id: elastic_id_to_remove
      })
    end
  end

  def attach_sub_collection_ownables_when_base
    if persisted? && changes.key?("base")
      child_collection_ids = expand_with_child_collections.select { |c| c.id unless c.base? || c == self }.compact

      Theme.where(collection_id: child_collection_ids).each do |instance|
        instance.collection = self
        unless instance.save
          if instance.errors.details[:name] && instance.errors.details[:name][0][:error] == :taken
            existing_instance = instance.class.where(name: instance.name, collection_id: id).first
            existing_instance.works += instance.works
            existing_instance.save

            instance.hide = true
            instance.save
          else
            raise CollectionBaseError.new("Base transition cannot be performed for collection with id #{id}")
          end
        end
      end

      Cluster.where(collection_id: child_collection_ids).each do |instance|
        instance.collection = self
        unless instance.save
          if instance.errors.details[:name] && instance.errors.details[:name][0][:error] == :taken
            existing_instance = instance.class.where(name: instance.name, collection_id: id).first

            instance.works.update_all(cluster_id: existing_instance.id)
            instance.destroy
          else
            raise CollectionBaseError.new("Base transition cannot be performed for collection with id #{id}")
          end
        end
      end

      Attachment.where(collection_id: child_collection_ids).each do |instance|
        instance.collection = self
        unless instance.save
          raise CollectionBaseError.new("Base transition cannot be performed for collection with id #{id}, #{instance.errors.messages}")
        end
      end

      CollectionAttribute.where(collection_id: child_collection_ids).each do |instance|
        instance.collection = self
        unless instance.save
          raise CollectionBaseError.new("Base transition cannot be performed for collection with id #{id}, #{instance.errors.messages}")
        end
      end
    end
  end

  private

  def cache_all_collection_name_extended!
    UpdateCacheWorker.perform_async(self.class.name, "collection_name_extended")
  end

  def pdf_title_export_variants_text_valid?
    pdf_title_export_variants
    true
  rescue
    errors.add(:pdf_title_export_variants_text, :invalid_configuration)
    false
  end

  class << Collection
    def all_plus_a_fake_super_collection
      [FakeSuperCollection.new] + all
    end

    def for_user user
      if user.super_admin? && !user.admin_with_favorites?
        not_system.with_root_parent
      elsif user.admin? && !user.admin_with_favorites?
        not_system.with_root_parent.where(qkunst_managed: true)
      else
        joins(:users).where(users: {id: user.id}).not_system
      end
    end

    def for_user_expanded user
      if user.super_admin? && !user.admin_with_favorites?
        not_system.with_root_parent.expand_with_child_collections
      elsif user.admin? && !user.admin_with_favorites?
        not_system.with_root_parent.where(qkunst_managed: true).expand_with_child_collections
      else
        joins(:users).where(users: {id: user.id}).not_system.expand_with_child_collections
      end
    end

    def for_user_or_if_no_user_all user = nil
      user ? for_user(user) : where.not(root: true)
    end

    def last_updated
      order(:updated_at).last
    end

    def root
      where(root: true).first
    end
  end
end
