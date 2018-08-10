require_relative "../uploaders/picture_uploader"
class Work < ApplicationRecord
  include ActionView::Helpers::NumberHelper
  include Work::Caching
  include Work::ParameterRerendering
  include FastAggregatable
  include Searchable

  has_paper_trail

  before_save :set_empty_values_to_nil
  before_save :sync_purchase_year
  before_save :enforce_nil_or_true
  before_save :update_created_by_name
  after_save :touch_collection!
  after_save :update_artist_name_rendered!


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
  has_and_belongs_to_many :artists, -> { distinct }, after_add: :touch_updated_at, after_remove: :touch_updated_at
  has_and_belongs_to_many :damage_types, -> { distinct }, after_add: :touch_updated_at, after_remove: :touch_updated_at
  has_and_belongs_to_many :frame_damage_types, -> { distinct }, after_add: :touch_updated_at, after_remove: :touch_updated_at
  has_and_belongs_to_many :object_categories, -> { distinct }, after_add: :touch_updated_at, after_remove: :touch_updated_at
  has_and_belongs_to_many :sources, -> { distinct }, after_add: :touch_updated_at, after_remove: :touch_updated_at
  has_and_belongs_to_many :techniques, -> { distinct }, after_add: :touch_updated_at, after_remove: :touch_updated_at
  has_and_belongs_to_many :themes, -> { distinct }, after_add: :touch_updated_at, after_remove: :touch_updated_at
  has_and_belongs_to_many :custom_reports
  has_many :appraisals
  has_many :attachments, as: :attache

  scope :no_photo_front, -> { where(photo_front: nil)}
  scope :artist, ->(artist){ joins("INNER JOIN artists_works ON works.id = artists_works.work_id").where(artists_works: {artist_id: artist.id})}
  scope :published, ->{ where(publish: true) }
  scope :has_number, ->(number){ where("works.stock_number = :number OR works.alt_number_1 = :number OR works.alt_number_2 = :number OR works.alt_number_3 = :number", {number: number})}

  accepts_nested_attributes_for :artists
  accepts_nested_attributes_for :appraisals

  acts_as_taggable

  normalize_attributes :location, :stock_number, :alt_number_1, :alt_number_2, :alt_number_3, :photo_front, :photo_back, :photo_detail_1, :photo_detail_2, :title, :print, :grade_within_collection, :entry_status, :abstract_or_figurative, :location_detail

  mount_uploader :photo_front, PictureUploader
  mount_uploader :photo_back, PictureUploader
  mount_uploader :photo_detail_1, PictureUploader
  mount_uploader :photo_detail_2, PictureUploader

  attr_localized :frame_height, :frame_width, :frame_depth, :frame_diameter, :height, :width, :depth, :diameter

  settings index: { number_of_shards: 5 } do
    mappings do
      indexes :abstract_or_figurative, type: 'keyword'
      indexes :tag_list, type: 'keyword'#, tokenizer: 'keyword'
      indexes :description, analyzer: 'dutch', index_options: 'offsets'
      indexes :grade_within_collection, type: 'keyword'
      indexes :location_raw, type: 'keyword'
      indexes :location_floor_raw, type: 'keyword'
      indexes :location_detail_raw, type: 'keyword'
      indexes :object_format_code, type: 'keyword'
      indexes :report_val_sorted_artist_ids, type: 'keyword'
      indexes :report_val_sorted_object_category_ids, type: 'keyword'
      indexes :report_val_sorted_technique_ids, type: 'keyword'
      indexes :title, analyzer: 'dutch'
    end
  end

  index_name "works-a"

  def photos?
    photo_front? or photo_back? or photo_detail_1? or photo_detail_2?
  end

  # This method is built to be fault tolerant and tries to make the best out of user given input.
  def purchased_on= date
    if date.is_a? String
      begin
        date = date.to_date
      rescue ArgumentError
      end
    end
    if date.is_a? String or date.is_a? Numeric
      date = date.to_i
      if date > 1900 and date < 2100
        self.write_attribute(:purchase_year, date)
      end
    else
      if date.is_a? Date or date.is_a? Time or date.is_a? DateTime
        self.write_attribute(:purchased_on, date)
        self.write_attribute(:purchase_year, date.year)
      end
    end
  end

  def cluster_name= name
    if name == "" or name == nil
      self.cluster = nil
    else
      clust = self.collection.clusters_including_parent_clusters.find_by_case_insensitive_name(name.strip).first
      self.cluster = clust
      if self.cluster.nil?
        self.cluster = self.collection.clusters.new(name: name.strip)
      end
    end
  end


  def sync_purchase_year
    if purchased_on
      self.purchase_year = purchased_on.year
    end
  end


  def geoname_ids
    ids = []
    artists.each do |artist|
      ids += artist.geoname_ids
    end
    ids << locality_geoname_id if locality_geoname_id
    GeonameSummary.where(geoname_id: ids).with_parents.select(:geoname_id).collect{|a| a.geoname_id}
  end


  def alt_numbers
    nrs = [alt_number_1, alt_number_2, alt_number_3]
    nrs if nrs.count > 0
  end

  def purchase_price_symbol
    purchase_price_currency ? purchase_price_currency.symbol : "€"
  end

  def dimension_to_s value, nil_value=nil
    value ? number_with_precision(value, precision: 5, significant: true, strip_insignificant_zeros: true) : nil_value
  end



  def main_collection
    read_attribute(:main_collection) ? true : nil
  end

  def collection_external_reference_code
    collection.external_reference_code if collection
  end

  def all_work_ids_in_collection
    order = [:stock_number, :id]
    @all_works ||= collection.works.select(:id).order(order).collect{|a| a.id}
  end
  def work_index_in_collection
    @work_index_in_collection ||= all_work_ids_in_collection.index(self.id)
  end
  def next
    next_work_id = all_work_ids_in_collection[work_index_in_collection+1]
    next_work_id ? Work.find(next_work_id) : Work.find(all_work_ids_in_collection.first)
  end
  def previous
    prev_work_id = all_work_ids_in_collection[work_index_in_collection-1]
    prev_work_id ? Work.find(prev_work_id) : Work.find(all_work_ids_in_collection.last)
  end

  def set_empty_values_to_nil
    #especially important for elasticsearch filtering on empty values!
    if grade_within_collection.is_a? String and grade_within_collection.strip == ""
      self.grade_within_collection=nil
    end
  end

  def as_indexed_json(*)
    self.as_json(
      include: {
        sources: { only: [:id, :name]},
        style: { only: [:id, :name]},
        owner: { only: [:id, :name]},
        artists: { only: [:id, :name], methods: [:name]},
        object_categories: { only: [:id, :name]},
        medium: { only: [:id, :name]},
        condition_work: { only: [:id, :name]},
        damage_types: { only: [:id, :name]},
        condition_frame: { only: [:id, :name]},
        frame_damage_types: { only: [:id, :name]},
        techniques: { only: [:id, :name]},
        themes: { only: [:id, :name]},
        subset: { only: [:id, :name]},
        placeability: { only: [:id, :name]},
        cluster: { only: [:id, :name]},
      },
      methods: [
        :tag_list, :geoname_ids, :title_rendered, :artist_name_rendered,
        :report_val_sorted_artist_ids, :report_val_sorted_object_category_ids, :report_val_sorted_technique_ids, :report_val_sorted_theme_ids,
        :location_raw, :location_floor_raw, :location_detail_raw,
        :object_format_code
      ]
    )
  end

  def report_val_sorted_artist_ids
    artists.order_by_name.distinct.collect{|a| a.id}.sort.join(",")
  end
  def report_val_sorted_object_category_ids
    object_categories.uniq.collect{|a| a.id}.sort.join(",")
  end
  def report_val_sorted_technique_ids
    techniques.uniq.collect{|a| a.id}.sort.join(",")
  end
  def report_val_sorted_theme_ids
    themes.uniq.collect{|a| a.id}.sort.join(",")
  end
  def available_themes
    collection.available_themes
  end

  def add_lognoteline note
    self.lognotes = self.lognotes.to_s + "\n#{note}"
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
    self.main_collection = nil if self.main_collection == false
  end

  def touch_updated_at(*)
    self.touch if persisted?
  end

  def touch_collection!
    collection.touch if collection
  end

  def collect_values_for_fields(fields)
    return fields.collect do |field|
      value = self.send(field)
      if value.class == PictureUploader
        value.file ? value.file.filename : nil
      elsif [Collection,::Collection,User,Currency,Source,Style,Medium,Condition,Subset,Placeability,Cluster,FrameType].include? value.class
        value.name
      elsif value.to_s === "Artist::ActiveRecord_Associations_CollectionProxy"
        artist_name_rendered_without_years_nor_locality_semicolon_separated
      elsif value.class.to_s.match(/ActiveRecord\_Associations\_CollectionProxy/)
        if value.first.is_a? PaperTrail::Version
          "Versie"
        elsif value.first.is_a? ActsAsTaggableOn::Tagging
          value.collect{|a| a.tag.name}.join(";")
        else
          value.collect{|a| a.name}.join(";")
        end
      elsif value.is_a? Hash
        value.to_s
      elsif value.is_a? Array
        value.join(";")
      else
        value
      end
    end
  end

  class << self
    def collect_locations
      rv = {}
      self.group(:location).count.sort{|a,b| a[0].to_s.downcase<=>b[0].to_s.downcase }.each{|a| rv[a[0]] = {count: a[1], subs:[]} }
      rv
    end
    def update_artist_name_rendered!
      self.all.each{|w| w.update_artist_name_rendered!; w.save if w.changes != {}}
    end
    def human_attribute_name_for_alt_number_field( field_name, collection )
      custom_label_name = collection ? collection.send("label_override_work_#{field_name}_with_inheritance".to_sym) : nil
      custom_label_name || Work.human_attribute_name(field_name)
    end
    def human_attribute_name_overridden( field_name, collection )
      if [:alt_number_1, :alt_number_2, :alt_number_3].include? field_name
        human_attribute_name_for_alt_number_field( field_name, collection )
      else
        Work.human_attribute_name(field_name)
      end
    end
    def to_workbook(fields=[:id,:title_rendered], collection = nil)
      w = Workbook::Book.new([fields.collect{|a| Work.human_attribute_name_overridden(a, collection)}])
      self.all.each do |work|
        w.sheet.table << work.collect_values_for_fields(fields)
      end
      return w
    end
  end
end
