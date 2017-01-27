require_relative "../uploaders/picture_uploader"
class Work < ApplicationRecord
  has_paper_trail
  before_save :set_empty_values_to_nil
  before_save :update_artist_name_rendered!

  include Elasticsearch::Model

  include ActionView::Helpers::NumberHelper

  belongs_to :collection
  belongs_to :created_by, :class_name=>User
  has_and_belongs_to_many :sources
  belongs_to :style
  belongs_to :cluster
  has_and_belongs_to_many :artists
  has_and_belongs_to_many :object_categories
  has_and_belongs_to_many :techniques
  belongs_to :medium
  belongs_to :condition_work, :class_name=>Condition
  has_and_belongs_to_many :damage_types
  belongs_to :condition_frame, :class_name=>Condition
  has_and_belongs_to_many :frame_damage_types
  has_and_belongs_to_many :themes

  belongs_to :subset
  belongs_to :placeability
  belongs_to :purchase_price_currency, :class_name=>Currency

  scope :no_photo_front, -> { where(photo_front: nil)}

  normalize_attributes :location, :stock_number, :alt_number_1, :alt_number_2, :alt_number_3, :photo_front, :photo_back, :photo_detail_1, :photo_detail_2, :title, :print, :grade_within_collection, :entry_status, :abstract_or_figurative, :location_detail

  after_commit on: [:create] do
    __elasticsearch__.index_document #if self.published?
  end

  after_commit on: [:update] do
    self.reindex! #if self.published?
  end

  after_commit on: [:destroy] do
    begin
      __elasticsearch__.delete_document
    rescue Elasticsearch::Transport::Transport::Errors::NotFound
      # document already deleted :)
    end
  end

  mount_uploader :photo_front, PictureUploader
  mount_uploader :photo_back, PictureUploader
  mount_uploader :photo_detail_1, PictureUploader
  mount_uploader :photo_detail_2, PictureUploader

  def photos?
    photo_front? or photo_back? or photo_detail_1? or photo_detail_2?
  end

  accepts_nested_attributes_for :artists

  settings index: { number_of_shards: 1 } do
    mappings do
      indexes :title, analyzer: 'dutch', index_options: 'offsets'
      indexes :description, analyzer: 'dutch', index_options: 'offsets'
      indexes :location_raw, type: 'string', index: "not_analyzed"
    end
  end

  after_touch() { __elasticsearch__.index_document }

  def title_rendered
    title_nil = title.nil? or title.to_s.strip.empty?
    if title_unknown and title_nil
      return "Zonder titel"
    elsif title_nil
      return "Nog geen titel"
    else
      return read_attribute(:title)
    end
  end

  def name(options={})
    "#{artist_name_rendered} - #{title_rendered}"
  end

  def location_raw
    location if location && location.to_s.strip != ""
  end

  def abstract_or_figurative_rendered
    if abstract_or_figurative?
      return abstract_or_figurative == "abstract" ? "Abstract" : "Figuratief"
    end
  end

  def locality_geoname_name
    gs = GeonameSummary.where(geoname_id: locality_geoname_id).first
    return gs.label if gs
  end

  def geoname_ids
    ids = []
    artists.each do |artist|
      ids += artist.geoname_ids
    end
    ids << locality_geoname_id if locality_geoname_id
    GeonameSummary.where(geoname_id: ids).with_parents.select(:geoname_id).collect{|a| a.geoname_id}
  end

  def artist_name_rendered(options={})
    if options[:rebuild]
      artist_name_rendered = artists.order_by_name.distinct.collect{|a| a.name(options) if a.name(options).to_s.strip != ""}.compact.to_sentence
      if artist_unknown and (artist_name_rendered.nil? or artist_name_rendered.empty?)
        artist_name_rendered = "Onbekend"
      end
      return artist_name_rendered
    else
      rv = read_attribute(:artist_name_rendered)
      rv = rv.to_s.gsub(/\s\(([\d\-]*)\)/,"") if options[:include_years] == false
      rv
    end
  end

  def update_artist_name_rendered!
    self.artist_name_rendered = artist_name_rendered({rebuild:true})
  end

  def signature_rendered
    if no_signature_present and signature_comments.to_s.strip.empty?
      "Niet gesigneerd"
    else
      signature_comments unless signature_comments.to_s.strip.empty?
    end
  end

  def object_creation_year_rendered
    if object_creation_year_unknown and object_creation_year.nil?
      "Onbekend"
    else
      object_creation_year
    end
  end

  def alt_numbers
    nrs = []
    nrs << alt_number_1 if alt_number_1?
    nrs << alt_number_2 if alt_number_2?
    nrs << alt_number_3 if alt_number_3?
    nrs if nrs.count > 0
  end

  def condition_work_rendered
    rv = []
    rv.push(condition_work.name) if condition_work
    rv.push(damage_types.collect{|a| a.name}.join(", ")) if damage_types.count > 0
    rv.push(condition_work_comments) if condition_work_comments?
    rv = rv.join("; ")
    return rv if rv != ""
  end

  def condition_frame_rendered
    rv = []
    rv.push(condition_frame.name) if condition_frame
    rv.push(frame_damage_types.collect{|a| a.name}.join(", ")) if frame_damage_types.count > 0
    rv.push(condition_frame_comments) if condition_frame_comments?
    rv = rv.join("; ")
    return rv if rv != ""
  end
  def purchase_price_symbol
    purchase_price_currency ? purchase_price_currency.symbol : "€"
  end

  def frame_size
    if frame_height or frame_width or frame_depth or frame_diameter
      "#{frame_height ? number_with_precision(frame_height, precision: 5, significant: true, strip_insignificant_zeros: true) : '?'}#{frame_width ? " x #{number_with_precision(frame_width, precision: 5, significant: true, strip_insignificant_zeros: true)}" : ''}#{frame_depth ? " x #{number_with_precision(frame_depth, precision: 5, significant: true, strip_insignificant_zeros: true)}#{"(D)" if !frame_width}" : ''}#{frame_diameter ? "; ⌀ #{number_with_precision(frame_diameter, precision: 5, significant: true, strip_insignificant_zeros: true)}" : ''}"
    end
  end

  def work_size
    if height or width or depth or diameter
      "#{height ? number_with_precision(height, precision: 5, significant: true, strip_insignificant_zeros: true) : '?'}#{width ? " x #{number_with_precision(width, precision: 5, significant: true, strip_insignificant_zeros: true)}" : ''}#{depth ? " x #{number_with_precision(depth, precision: 5, significant: true, strip_insignificant_zeros: true)}#{"(d)" if !width}" : ''}#{diameter ? "; ⌀ #{number_with_precision(diameter, precision: 5, significant: true, strip_insignificant_zeros: true)}" : ''}"
    end

  end

  def hpd_height
    frame_height? ? frame_height : height
  end
  def hpd_width
    frame_width? ? frame_width : width
  end
  def hpd_depth
     frame_depth? ? frame_depth : depth
  end
  def hpd_diameter
    frame_diameter? ? frame_diameter : diameter
  end
  def hpd_keywords
     object_categories.collect{|a| a.name}.join(",")
  end
  def hpd_materials
     techniques.collect{|a| a.name}.join(",")
  end
  def hpd_condition
    condition_work_rendered
  end
  def base_file_name
    stock_number? ? stock_number : "AUTO_DB_ID_#{id}"
  end
  def hpd_photo_file_name
    "#{base_file_name}_front.jpg"
  end
  def hpd_comments
  end
  def hpd_contact
  end

  def next
    all_works = collection.works.select(:id).order([:stock_number,:id]).collect{|a| a.id}
    next_work_id = all_works[all_works.index(self.id)+1]
    next_work_id ? Work.find(next_work_id) : Work.find(all_works[0])
  end

  def set_empty_values_to_nil
    #especially important for elasticsearch filtering on empty values!
    if grade_within_collection.is_a? String and grade_within_collection.strip == ""
      self.grade_within_collection=nil
    end
  end

  # TODO: in future versions make more stable, this might break cluster-functionality!
  # def collection= collection
  #
  # end

  def collection_name_extended
    self.collection.collection_name_extended
  end

  def as_indexed_json(options={})
    self.as_json(
      include: {
        sources: { only: [:id, :name]},
        style: { only: :name},
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
        :geoname_ids,
        :title_rendered,
        :artist_name_rendered,
        :report_val_sorted_artist_ids,
        :report_val_sorted_object_category_ids,
        :report_val_sorted_technique_ids,
        :report_val_sorted_theme_ids,
        :location_raw,
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
  def object_format_code
    size = [hpd_height,hpd_width,hpd_depth,hpd_diameter].compact.max
    ofc = nil
    if size
      if size < 30
        ofc = :xs
      elsif size < 50
        ofc = :s
      elsif size < 80
        ofc = :m
      elsif size < 120
        ofc = :l
      else
        ofc = :xl
      end
    end
    return ofc
  end

  def add_lognoteline note
    self.lognotes = self.lognotes.to_s + "\n#{note}"
  end

  def reindex!
    begin
      __elasticsearch__.update_document
    rescue Elasticsearch::Transport::Transport::Errors::NotFound
      __elasticsearch__.index_document
    end
  end

  def title= titel
    if titel.to_s.strip == ""
      write_attribute(:title, nil)
    elsif titel.to_s.strip.downcase == "zonder titel"
      write_attribute(:title_unknown, true)
    else
      write_attribute(:title, titel)
    end
  end

  def object_creation_year= year
    if year.to_i > 0
      write_attribute(:object_creation_year, year)
    elsif ["geen jaar", "zonder jaartal"].include? year.to_s
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

  class << self
    def fast_aggregations attributes
      rv = {}
      attributes.each do |attribute|
        rv[attribute] ||= {}
        if column_names.include? attribute.to_s
          self.select(attribute).group(attribute).collect{|a| a.send(attribute)}.each do |a|
            value = (a ? a : :not_set)
            if value.is_a? String
              if attribute == :grade_within_collection
                value = value[0]
              end
              value = value.downcase.to_sym
            end
            rv[attribute][value] ||= {count: 999999, name: value }
          end
        elsif column_names.include? "#{attribute}_id"
          ids = self.group("#{attribute}_id").select("#{attribute}_id").collect{|a| a.send("#{attribute}_id")}
          if ids.include?(nil)
            rv[attribute][:not_set] ||= {count: 999999, name: :not_set }
          end
          attribute.to_s.classify.constantize.where(id: [ids]).each do |a|
            rv[attribute][a] ||= {count: 10000, name: a.name }
          end
        elsif attribute == :geoname_ids
          ids = self.group(:locality_geoname_id).select(:locality_geoname_id).collect{|a| a.locality_geoname_id}.compact.uniq
          artists = Artist.where(id: self.joins(:artists).select("artist_id AS id").collect{|a| a.id}).distinct
          # TODO: \/\/ This might become too expensive \/\/
          artists.each do |artist|
            ids += artist.geoname_ids
          end
          ids = ids.compact.uniq
          GeonameSummary.where(geoname_id: ids).with_parents.each do |geoname|
            rv[attribute][geoname] = {count: 10000, name: geoname.name}
          end
        else
          ids = self.left_outer_joins(attribute).select("#{attribute}.id AS id").distinct.collect(&:id)
          if ids.include?(nil)
            rv[attribute][:not_set] ||= {count: 999999, name: :not_set }
          end
          attribute.to_s.classify.constantize.where(id: [ids]).each do |a|
            rv[attribute][a] ||= {count: 999999, name: a.name }
          end
        # self.joins(attribute).select("themes.id AS id").distinct.collect(&:id)
        end
      end
      rv
    end

    def aggregations attributes
      rv = {}
      self.all.each do |work|
        attributes.each do |attribute|
          rv[attribute] ||= {}
          values = work.send(attribute)
          if values.is_a? ActiveRecord::Associations::CollectionProxy
            values.each do |value|
              rv[attribute][value] ||= {count: 0, name: value.name}
              rv[attribute][value][:count] += 1
            end
            if values.empty?
              rv[attribute][:not_set] ||= {count: 0, name: :not_set }
              rv[attribute][:not_set][:count] += 1
            end
          else
            value = values
            if value.is_a? String
              if attribute == :grade_within_collection
                value = value[0]
              end
              value = value.downcase.to_sym
            end
            value = :not_set if value.nil?
            rv[attribute][value] ||= {count: 0, name: value }
            rv[attribute][value][:count] += 1
          end
        end
      end
      rv
    end

    def reindex!(recreate_index=false)
      if recreate_index
        Work.__elasticsearch__.create_index! force: true
        Work.__elasticsearch__.refresh_index!
      end
      self.all.each{|a| a.reindex!}
    end
    def collect_locations
      rv = {}
      self.group(:location).count.sort{|a,b| a[0].to_s.downcase<=>b[0].to_s.downcase }.each{|a| rv[a[0]] = {count: a[1], subs:[]} }
      rv
    end

    def human_attribute_name_overridden(field, collection)
      if collection
        return collection.label_override_work_alt_number_1_with_inheritance if collection.label_override_work_alt_number_1_with_inheritance and field.to_sym == :alt_number_1
        return collection.label_override_work_alt_number_2_with_inheritance if collection.label_override_work_alt_number_2_with_inheritance and field.to_sym == :alt_number_2
        return collection.label_override_work_alt_number_3_with_inheritance if collection.label_override_work_alt_number_3_with_inheritance and field.to_sym == :alt_number_3
      end
      Work.human_attribute_name(field)
    end
    def to_workbook(fields=[:id,:title_rendered], collection = nil)
      w = Workbook::Book.new([fields.collect{|a| Work.human_attribute_name_overridden(a, collection)}])
      self.all.each do |work|
        values = fields.collect do |field|
          value = work.send(field)
          if value.class == PictureUploader
            value = value.file ? value.file.filename : nil
          end
          if [Collection,User,Currency,Source,Style,Medium,Condition,Subset,Placeability,Cluster].include? value.class
            value = value.name
          end
          if value.is_a? Artist::ActiveRecord_Associations_CollectionProxy
            value = work.artist_name_rendered
          end
          if value.class.to_s.match(/ActiveRecord\_Associations\_CollectionProxy/)
            if value.first.is_a? PaperTrail::Version
              value = "Versie"
            else
              value = value.collect{|a| a.name}.join(", ")
            end
          end
          if value.is_a? Hash
            value = value.to_s
          end

          value
        end
        w.sheet.table << values
      end
      return w
    end
  end
end
