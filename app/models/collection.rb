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

class Collection < ApplicationRecord
  include ColumnCache

  belongs_to :parent_collection, class_name: 'Collection', optional: true
  has_and_belongs_to_many :users
  has_many :attachments, as: :attache
  has_many :batch_photo_uploads
  has_many :child_collections, class_name: 'Collection', foreign_key: 'parent_collection_id'
  has_many :clusters
  has_many :collections, class_name: 'Collection', foreign_key: 'parent_collection_id'
  has_many :collections_geoname_summaries
  has_many :custom_reports
  has_many :geoname_summaries, through: :collections_geoname_summaries
  has_many :import_collections
  has_many :themes
  has_many :works

  has_cache_for_column :geoname_ids
  has_cache_for_column :collection_name_extended

  default_scope ->{order(:name)}

  scope :without_parent, ->{where(parent_collection_id: nil)}
  scope :not_hidden, ->{ where("1=1")}
  has_and_belongs_to_many :stages
  has_many :collections_stages
  has_many :reminders

  before_save :cache_geoname_ids!
  before_save :cache_collection_name_extended!

  after_create :copy_default_reminders!
  after_save :touch_works_including_child_works!
  after_commit :touch_parent

  KEY_MODEL_RELATIONS={
    "artists"=>Artist,
    "themes"=>Theme,
    "object_categories"=>ObjectCategory,
    "object_categories_split"=>ObjectCategory,
    "techniques"=>Technique,
    "condition_frame"=>Condition,
    "techniques_split"=>Technique,
    "condition_work"=>Condition,
    "frame_damage_types"=>FrameDamageType,
    "damage_types"=>DamageType,
    "placeability"=>Placeability,
    "style"=>Style,
    "subset"=>Subset,
    "source"=>Source,
    "sources"=>Source,
    "cluster"=>Cluster,
    "owner"=>Owner,
    "frame_type"=>FrameType
  }

  def find_state_of_stage(stage)
    collections_stages.to_a.each do |cs|
      return cs if cs.stage == stage
    end
    return nil
  end

  def collections_stages?
    collections_stages.count > 0
  end

  def parent_collection_with_stages
    unless collections_stages?
      parent_collections_flattened.reverse.each do |coll|
        return coll if coll.collections_stages?
      end
    end
    return nil
  end

  def geoname_ids
    geoname_summaries.collect{|a| a.geoname_id}
  end

  def geoname_summaries?
    cached_geoname_ids && cached_geoname_ids.count > 0
  end

  def to_label
    self_and_parent_collections_flattened.select(&:name).collect(&:name).reverse.join(" > ")
  end

  def self_or_parent_collection_with_geoname_summaries
    if geoname_summaries?
      return self
    else
      parent_collections_flattened.reverse.each do |coll|
        return coll if coll.geoname_summaries?
      end
    end
    return nil
  end

  def collections_stage_delivery_on
    if collections_stages.delivery.count > 0
      rv = collections_stages.delivery.first.completed_at
      rv.to_date if rv
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
    Work.where(collection_id: id_plus_child_ids)
  end

  def touch_parent
    parent_collection.touch if parent_collection
  end

  def touch_works_including_child_works!
    works_including_child_works.each{|a| a.touch}
  end

  def available_clusters
    Cluster.for_collection(self)
  end

  def available_owners
    Owner.for_collection(self)
  end

  def available_themes
    Theme.for_collection_including_generic(self).not_hidden
  end

  def not_hidden_themes
    themes.not_hidden
  end

  def users_including_parent_users
    (users + parent_collections_flattened.collect{|a| a.users_including_parent_users}).flatten.uniq
  end

  def id_plus_child_ids
    child_collections_flattened.map(&:id) + [self.id]
  end

  def id_plus_parent_ids
     (self.parent_collections_flattened.map(&:id) + [self.id]).flatten.uniq.compact
  end

  def exposable_fields= array
    write_attribute(:exposable_fields,array.collect{|a| a.to_s.strip if a and a.to_s.strip != ""}.compact.join(","))
  end

  def possible_parent_collections
    Collection.all - [self] - child_collections_flattened
  end

  def child_collections_flattened
    self.id ? Collection.find(self.id).child_collections.expand_with_child_collections : []
  end

  def parent_collections_flattened
    ([parent_collection] + [parent_collection].compact.collect{|a| a.parent_collection}.flatten).compact.reverse
  end

  def self_and_parent_collections_flattened
    @self_and_parent_collections_flattened ||= Collection.where(id: id_plus_parent_ids)
  end

  def collection_name_extended
    # inefficient... but needed for proper order
    ids = parent_collections_flattened + [self.id]
    names = []
    ids.each do | collection_id |
      c = Collection.where(id:collection_id).select(:name).first
      names << c.name if c
    end
    names.join(" » ")
  end

  def exposable_fields
    read_attribute(:exposable_fields).to_s.split(",")
  end

  def fields_to_expose(audience=:default)
    if audience == :default
      return exposable_fields.count == 0 ? Work.possible_exposable_fields.collect{|k,v| v} : exposable_fields
    elsif audience == :hpd
      return ["stock_number","title_rendered","description","artist_name_rendered","hpd_height","hpd_width","hpd_depth","hpd_diameter","hpd_keywords","hpd_materials","hpd_condition","hpd_photo_file_name","hpd_comments","hpd_contact"]
    elsif audience == :erfgoed_gelderland
      return ["stock_number_file_safe","artist_name_rendered_without_years_nor_locality_semicolon_separated","title_rendered","object_categories","techniques","hpd_height","hpd_width","hpd_depth", "hpd_photo_file_name", "publish", "description", "object_creation_year", "tags"]
    end
  end

  def elastic_aggragations
    elastic_report = search_works("",{},{force_elastic: true, return_records: false, limit: 1, aggregations: Report::Builder.aggregations})
    return elastic_report.aggregations
  end

  def label_override_work_alt_number_1_with_inheritance
    self_and_parent_collections_flattened.collect{|a| a.label_override_work_alt_number_1 unless a.label_override_work_alt_number_1.to_s.strip == ""}.compact.last
  end

  def label_override_work_alt_number_2_with_inheritance
    self_and_parent_collections_flattened.collect{|a| a.label_override_work_alt_number_2 unless a.label_override_work_alt_number_2.to_s.strip == ""}.compact.last
  end

  def label_override_work_alt_number_3_with_inheritance
    self_and_parent_collections_flattened.collect{|a| a.label_override_work_alt_number_3 unless a.label_override_work_alt_number_3.to_s.strip == ""}.compact.last
  end

  def geoname_summary_values
    rv = {}
    geoname_summaries.each do |gs|
      rv[gs.name]=gs.geoname_id
    end
    rv
  end

  def report
    return @report if @report
    Report::Parser.key_model_relations= KEY_MODEL_RELATIONS
    @report = Report::Parser.parse(elastic_aggragations)
  end

  def search_works(search="", filter={}, options={})
    options = {force_elastic: false, return_records: true, limit: 10000}.merge(options)
    if ((search == "" or search == nil) and (filter == nil or filter == {} or (
      filter.is_a? Hash and filter.sum{|k,v| v.count} == 0
      )) and options[:force_elastic] == false)
      return options[:no_child_works] ? works.limit(options[:limit]) : works_including_child_works.limit(options[:limit])
    end

    query = {
      _source: [:id], #major speedup!
      size: options[:limit],
      query:{
        bool: {
          must: [
            terms:{
              "collection_id"=> options[:no_child_works] ? [id] : id_plus_child_ids
            }
          ]
        }
      }
    }

    if (search and !search.to_s.strip.empty?)
      # search.split("/\s/").each do |search_t
      search = search.match(/[\"\(\~\'\*\?]|AND|OR/) ? search : search.split(" ").collect{|a| "#{a}~" }.join(" ")
      query[:query][:bool][:must] << {
        query_string: {
          default_field: :_all,
          query: search,
          # analyzer: :dutch,
          default_operator: :and,
          fuzziness: 3
        }
      }
    end

    filter.each do |key, values|
      new_bool = {bool: {should: []}}
      if key == "locality_geoname_id" or key == "geoname_ids" or key == "tag_list.keyword"
        values = values.compact
        if values.count == 0
          new_bool[:bool]= {mustNot: {exists: {field: key}}}
        else
          new_bool[:bool][:should] << {terms: {key=> values}}

          # new_bool = {terms: {key=> values}}
        end
      else
        values.each do |value|
          if value != nil
            new_bool[:bool][:should] << {term: {key=>value}}
          else
            if key.ends_with?(".id")
              new_bool[:bool][:should] << {mustNot: {exists: {field: key}}}
            else
              new_bool[:bool][:should] << {bool:{must_not: {exists: {field: key }}}}
            end
          end
        end
      end
      query[:query][:bool][:must] << new_bool
    end

    query[:aggs] = options[:aggregations] if options[:aggregations]

    Rails.logger.debug query.inspect

    if options[:return_records]
      return Work.search(query).records
    else
      return Work.search(query)
    end
  end

  def can_be_accessed_by_user user
    users_including_parent_users.include? user or user.admin?
  end
  alias_method :can_be_accessed_by_user?, :can_be_accessed_by_user

  def copy_default_reminders!
    if reminders.count == 0
      Reminder.prototypes.each do |a|
        self.reminders << Reminder.new(a.to_hash)
      end
    end
  end

  class << Collection
    def all_plus_a_fake_super_collection
      [FakeSuperCollection.new] + self.all
    end

    def for_user user
      return self.without_parent if user.admin? and !user.admin_with_favorites?
      self.joins(:users).where(users: {id: user.id})
    end

    def last_updated
      order(:updated_at).last
    end

    def expand_with_child_collections(depth = 5)
      raise ArgumentError, "depth can't be < 1" if depth < 1
      join_sql = "LEFT OUTER JOIN collections c1_cs ON collections.id = c1_cs.parent_collection_id "
      select_sql = "collections.id AS _child_level0, c1_cs.id AS _child_level1"
      depth -= 1 # we already have depth = 1
      depth.times do |dept|
        join_sql += "LEFT OUTER JOIN collections c#{(2+dept).to_i}_cs ON c#{(1+dept).to_i}_cs.id = c#{(2+dept).to_i}_cs.parent_collection_id "
        select_sql += ", c#{(2+dept).to_i}_cs.id AS _child_level#{(2+dept).to_i}"
      end
      ids = []
      self.
        joins(join_sql).
        select(select_sql).
        each do | intermediate_result |
          (depth + 1).times { |a| ids << intermediate_result.send("_child_level#{a}".to_sym) }
        end
      ::Collection.unscoped.where(id: ids.compact.uniq)
    end
  end
end
