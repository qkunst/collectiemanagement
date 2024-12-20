# frozen_string_literal: true

# == Schema Information
#
# Table name: artists
#
#  id                        :bigint           not null, primary key
#  artist_name               :string
#  date_of_birth             :date
#  date_of_death             :date
#  description               :text
#  first_name                :string
#  gender                    :string
#  geoname_ids_cache         :text
#  last_name                 :string
#  name_variants             :string           default([]), is an Array
#  old_data                  :text
#  other_structured_data     :text
#  place_of_birth            :string
#  place_of_birth_lat        :float
#  place_of_birth_lon        :float
#  place_of_death            :string
#  place_of_death_lat        :float
#  place_of_death_lon        :float
#  prefix                    :string
#  year_of_birth             :integer
#  year_of_death             :integer
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  import_collection_id      :bigint
#  place_of_birth_geoname_id :bigint
#  place_of_death_geoname_id :bigint
#  replaced_by_artist_id     :bigint
#  rkd_artist_id             :bigint
#
class Artist < ApplicationRecord
  PREDEFINED_GENDER_VALUES = %w[woman man nonbinary transgender intersex genderqueer na].freeze

  include MethodCache
  include Artist::NameRenderer
  include HasCollectionAttributes

  has_paper_trail

  # belongs_to :rkd_artist, foreign_key: :rkd_artist_id, primary_key: :rkd_id, optional: true
  belongs_to :import_collection, optional: true

  has_and_belongs_to_many :works
  has_and_belongs_to_many :attachments
  has_and_belongs_to_many :library_items

  has_many :artist_involvements
  has_many :involvements, -> { distinct }, through: :artist_involvement
  has_many :subsets, through: :works
  has_many :techniques, through: :works

  has_cache_for_method :geoname_ids

  after_save :update_artist_name_rendered_async
  after_touch :update_artist_name_rendered_async

  before_save :sync_dates_and_years
  before_save :sync_places
  before_save :cache_geoname_ids

  scope :created_at_date, ->(date) { where("artists.created_at >= ? AND artists.created_at <= ?", date.to_time.beginning_of_day, date.to_time.end_of_day) }
  scope :exclude_artist, ->(artist) { where("artists.id != ?", artist.id) }
  scope :have_name, -> { where.not("(artists.last_name = '' OR artists.last_name IS NULL) AND (artists.prefix = '' OR artists.prefix IS NULL) AND (artists.first_name = '' OR artists.first_name IS NULL)") }
  scope :no_name, -> { where(last_name: [nil, ""], prefix: [nil, ""], first_name: [nil, ""]) }
  scope :order_by_name, -> { order(:last_name, :prefix, :first_name) }
  scope :works, ->(work) { joins("INNER JOIN artists_works ON artists.id = artists_works.artist_id").where(artists_works: {work_id: [work].flatten.map(&:id)}) }

  accepts_nested_attributes_for :artist_involvements

  default_scope -> { where(replaced_by_artist_id: nil) }

  store :other_structured_data, accessors: [:kids_heden_kunstenaars_nummer]
  store :old_data, coder: JSON

  def place_of_birth
    rv = read_attribute(:place_of_birth)
    rv if !rv.nil? && !rv.to_s.strip.empty?
  end

  def alt_number_1
    kids_heden_kunstenaars_nummer
  end

  def place_of_death
    rv = read_attribute(:place_of_death)
    rv if !rv.nil? && !rv.to_s.strip.empty?
  end

  def search_name
    if artist_name
      artist_name
    else
      first_name_part = [first_name, prefix].join(" ").strip
      [last_name, first_name_part].delete_if(&:blank?).compact.join(", ")
    end
  end

  def base_file_name
    search_name.downcase.gsub(/\s+/, "_").gsub(/[\#%&{}\\<>*?\/$!'":@+`|=,]/, "")
  end

  def geoname_ids
    ids = [place_of_birth_geoname_id, place_of_death_geoname_id]
    artist_involvements.each do |involvement|
      ids << involvement.place_geoname_id

      ids << involvement.involvement.place_geoname_id if involvement.involvement
    end
    ids.compact.uniq
  end

  def localities_to_find_by
    GeonameSummary.where(geoname_id: cached_geoname_ids).with_parents
  end

  def name?
    search_name != ""
  end

  def title
    name
  end

  def rkd_artist
    RKD::Artist.find(rkd_artist_id) if rkd_artist_id.to_i > 0
  end

  def rkd_artists
    return [rkd_artist] if rkd_artist
    begin
      ::RKD::Artist.search name
    rescue OpenSSL::SSL::SSLError
      []
    rescue SocketError
      []
    end
  end

  def prefix
    rv = read_attribute(:prefix)
    (rv.nil? || rv.empty?) ? nil : rv
  end

  def retrieve_rkd_artists!
    return [rkd_artist] if rkd_artist
    rkd_artists
  end

  def artists_with_same_name
    Artist.all
  end

  def sync_dates_and_years
    self.year_of_death = date_of_death.year if date_of_death
    self.year_of_birth = date_of_birth.year if date_of_birth
  end

  def sync_places
    self.place_of_death = place_of_death_geoname_name if place_of_death.nil?
    self.place_of_birth = place_of_birth_geoname_name if place_of_birth.nil?
  end

  def died?
    place_of_death? || year_of_death?
  end

  def born?
    place_of_birth? || year_of_birth?
  end

  def place_of_birth_geoname_name
    GeonameSummary.where(geoname_id: place_of_birth_geoname_id).first&.label
  end

  def place_of_death_geoname_name
    GeonameSummary.where(geoname_id: place_of_death_geoname_id).first&.label
  end

  def combine_artists_with_ids(artist_ids_to_combine_with, options = {})
    options = {only_when_created_at_date_is_equal: false}.merge(options)

    artists = Artist.where(id: artist_ids_to_combine_with)
    artists = artists.created_at_date(created_at) if options[:only_when_created_at_date_is_equal]
    count = 0
    artists.each do |artist|
      artist.works.each do |work|
        work.artists << self unless work.artists.include?(self)
        work.add_lognoteline "[combine_artists] adding artist #{id} [#{name}] to this work"
        work.add_lognoteline "[combine_artists] removing artist #{artist.id} [#{artist.name}] from this work"
        work.save
        count += 1
      end
      artist.collection_attributes.each do |collection_attribute|
        collection_attribute.update(attributed: self)
      end
      artist.update_columns(replaced_by_artist_id: id)
    end

    update_artist_name_rendered_async

    count
  end

  def to_parameters
    parameters = JSON.parse(to_json)
    parameters.delete("updated_at")
    parameters.delete("created_at")
    parameters
  end

  def import!(other)
    other.to_parameters.each do |k, v|
      skip_name_fields = prefix? || artist_name?
      empty_value = v.nil? || v.to_s.empty?
      name_fields = (k == "first_name") || (k == "last_name")

      if !empty_value && !(name_fields && skip_name_fields)
        send(:"#{k}=", v)
      end
    end
    educational_involvements = []
    professional_involvements = []
    other.artist_involvements.each do |involvement|
      if involvement.professional?
        professional_involvements << involvement
      else
        educational_involvements << involvement
      end
    end
    if educational_involvements.count > 0
      artist_involvements.educational.destroy_all
      educational_involvements.each do |inv|
        artist_involvements << inv.clone
      end
    end
    if professional_involvements.count > 0
      artist_involvements.professional.destroy_all
      professional_involvements.each do |inv|
        artist_involvements << inv.clone
      end
    end

    save
  end

  def rkd_artist_as_artist
    self.class.initialize_from_rkd_artist(rkd_artist)
  end

  def import_rkd_artist_as_artist
    import!(rkd_artist_as_artist)
  end

  private

  def update_artist_name_rendered_async
    Work.joins(:artists_works).where(artists_works: {artist_id: id}).pluck(:id).collect { |a| UpdateWorkCachesWorker.perform_async(a, "artist") }
  end

  class << self
    def names_hash
      unless defined?(@@artist_names)
        @@artist_names = {}
        Artist.all.each do |artist|
          @@artist_names[artist.id] = artist.name
        end
      end
      @@artist_names
    end

    def names ids
      if ids.is_a? String
        ids = [ids.to_i]
      elsif ids.is_a? Integer
        ids = [ids]
      end
      rv = {}
      ids.each do |id|
        rv[id] = names_hash[id]
      end
      rv
    end

    def destroy_all_empty_artists!
      empty_artists.collect { |a| a.destroy }
    end

    def empty_artists
      rv = []
      self.select(:id).each do |a|
        rv << a if a.works.count == 0
      end
      rv
    end

    def destroy_all_artists_with_no_name_that_have_works_that_already_belong_to_artists_with_a_name!
      artists_with_no_name_that_have_works_that_already_belong_to_artists_with_a_name.collect { |a| a.destroy }
    end

    def artists_with_no_name_that_have_works_that_already_belong_to_artists_with_a_name
      selected_empty_artists = []
      no_name.select(:id).each do |a|
        if a.works.count > 0
          artists_with_name = a.works.collect { |w|
            w.artists.have_name.count > 0
          }.compact.uniq
          if (artists_with_name.length == 1) && (artists_with_name.first == true)
            selected_empty_artists << a
          end
        end
      end
      selected_empty_artists
    end

    def group_by_name
      groups = {}
      all.each do |artist|
        groups[artist.name] = [] unless groups[artist.name]
        groups[artist.name] << artist.id
      end
      groups
    end

    def collapse_by_name!(options = {})
      options = {only_when_created_at_date_is_equal: true}.merge(options)
      group_by_name.each do |name, ids|
        first = ids.delete_at(0)
        first_artist = Artist.find(first)
        first_artist.combine_artists_with_ids(ids, options)
      end
    end

    def initialize_from_rkd_artist(rkd_artist)
      artist = new

      artist_name = (!rkd_artist.name.match(/\s/)) ? rkd_artist.name : nil
      if artist_name
        artist.artist_name = artist_name
      else
        parsed_name = Namae.parse(rkd_artist.name).first
        if parsed_name
          artist.first_name = parsed_name.given
          artist.last_name = parsed_name.family
          artist.prefix = parsed_name.particle
        else
          artist.artist_name = artist_name
        end
      end
      artist.date_of_birth = rkd_artist.birth_date
      artist.date_of_death = rkd_artist.death_date
      artist.year_of_birth = rkd_artist.birth_date&.year
      artist.year_of_death = rkd_artist.death_date&.year
      artist.gender = if rkd_artist.gender.to_s == "male"
        "man"
      elsif rkd_artist.gender.to_s == "female"
        "woman"
      end
      artist.place_of_birth = rkd_artist.birth_place_desc
      artist.place_of_death = rkd_artist.death_place_desc
      artist.place_of_birth_geoname_id = rkd_artist.birth_place&.geoname_id
      artist.place_of_birth_lat = rkd_artist.birth_place&.lat
      artist.place_of_birth_lon = rkd_artist.birth_place&.lon
      artist.place_of_death_geoname_id = rkd_artist.death_place&.geoname_id
      artist.place_of_death_lat = rkd_artist.death_place&.lat
      artist.place_of_death_lon = rkd_artist.death_place&.lon
      artist.rkd_artist_id = rkd_artist.identifier
      artist.name_variants = rkd_artist.name_variants

      artist.artist_involvements = rkd_artist.performances.map do |performance|
        artist_involvement = ArtistInvolvement.new
        artist_involvement.artist = artist
        artist_involvement.place = performance.place&.label
        artist_involvement.place_geoname_id = performance.place&.geoname_id
        if performance.institution
          artist_involvement.involvement = Involvement.find_or_initialize_by(external_reference: performance.institution.id)
          artist_involvement.involvement.place = performance.institution.place&.label
          artist_involvement.involvement.name = performance.institution.label
          artist_involvement.place ||= performance.institution.place&.label
          artist_involvement.place_geoname_id ||= performance.institution.place&.geoname_id
        end
        artist_involvement.end_year = performance.date_span&.end&.year
        artist_involvement.start_year = performance.date_span&.begin&.year
        artist_involvement.involvement_type = if performance.is_a?(RKD::Performance::Study)
          :educational
        elsif performance.is_a?(RKD::Performance::Work)
          :professional
        end

        artist_involvement
      end

      artist
    end
  end
end
