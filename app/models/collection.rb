# frozen_string_literal: true

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

class CollectionBaseError < StandardError
end

class Collection < ApplicationRecord
  include MethodCache
  include Collection::Hierarchy

  belongs_to :parent_collection, class_name: "Collection", optional: true

  has_and_belongs_to_many :users
  has_and_belongs_to_many :stages

  has_many :attachments, as: :attache
  has_many :batch_photo_uploads
  has_many :child_collections, class_name: "Collection", foreign_key: "parent_collection_id"
  has_many :clusters
  has_many :collections, class_name: "Collection", foreign_key: "parent_collection_id"
  has_many :collections_geoname_summaries
  has_many :collection_attributes
  has_many :custom_reports
  has_many :geoname_summaries, through: :collections_geoname_summaries
  has_many :import_collections
  has_many :themes
  has_many :works
  has_many :owners
  has_many :messages, as: :subject_object
  has_many :collections_stages
  has_many :reminders
  has_many :library_items

  has_cache_for_method :geoname_ids
  has_cache_for_method :collection_name_extended

  has_paper_trail # only enabled in may 2020

  default_scope -> { order(Arel.sql("REPLACE(collections.collection_name_extended_cache, '\"', '') ASC")) }

  scope :without_parent, -> { where(parent_collection_id: nil) }
  scope :not_hidden, -> { where("1=1") }
  scope :not_system, -> { not_root }
  scope :qkunst_managed, -> { where(qkunst_managed:true) }

  before_save :cache_geoname_ids!
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
    "work_status" => "WorkStatus"
  }

  def find_state_of_stage(stage)
    collections_stages.to_a.each do |cs|
      return cs if cs.stage == stage
    end
    nil
  end

  def base_collection
    if base
      self
    else
      base_collections.last || self
    end
  end

  def base_collections
    expand_with_parent_collections(:desc).not_system.where(base: true)
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

  def artists
    Artist.works(works_including_child_works)
  end

  def works_including_child_works
    Work.where(collection: expand_with_child_collections)
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

  def touch_parent
    parent_collection&.touch
  end

  def touch_works_including_child_works!
    if previous_changes.key? "geoname_ids_cache"
      works_including_child_works.each { |a| a.save }
    else
      works_including_child_works.each { |a| a.touch }
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
    when :public
      forbidden_words = ["value", "price", "location", "condition", "information_back", "internal", "damage", "placeability", "other_comments", "source", "purchase", "grade_within_collection", "created_by", "appraisal", "valuation", "lognotes"]

      Work.possible_exposable_fields.select do |field_name|
        !forbidden_words.collect{|forbidden_word| !!field_name.match(forbidden_word) }.include?(true)
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

  def report
    return @report if @report
    Report::Parser.key_model_relations = KEY_MODEL_RELATIONS.map { |k, v| [k, v.constantize] }.to_h
    if elastic_aggragations
      @report = Report::Parser.parse(elastic_aggragations)
    else
      false
    end
  end

  def search_works(search = "", filter = {}, options = {})
    Work.search_and_filter(self, search, filter, options)
  end

  def can_be_accessed_by_user user
    users_including_parent_users.include?(user) || user.super_admin? || (user.admin? && qkunst_managed?)
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

      Attachment.where(attache_type: "Collection", attache_id: child_collection_ids).each do |instance|
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
    UpdateCacheWorker.perform_async(self.class.name, :collection_name_extended)
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
  end
end
