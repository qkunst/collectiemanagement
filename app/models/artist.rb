class Artist < ApplicationRecord
  has_paper_trail
  has_many :artist_involvements
  has_and_belongs_to_many :works
  belongs_to :rkd_artist, foreign_key: :rkd_artist_id, primary_key: :rkd_id
  has_many :involvements, through: :artist_involvement
  after_save :touch_works
  belongs_to :import_collection

  scope :created_at_date, ->(date){where("artists.created_at >= ? AND artists.created_at <= ?", date.to_time.beginning_of_day, date.to_time.end_of_day )}
  scope :exclude_artist, ->(artist){where("artists.id != ?", artist.id)}
  scope :order_by_name, ->{order(:last_name, :prefix, :first_name)}
  scope :no_name, ->{where(last_name: [nil,""], prefix: [nil,""], first_name: [nil,""])}
  scope :have_name, ->{where.not("(artists.last_name = '' OR artists.last_name IS NULL) AND (artists.prefix = '' OR artists.prefix IS NULL) AND (artists.first_name = '' OR artists.first_name IS NULL)")}
  # accepts_nested_attributes_for :artist_involvements

  def name
    last_name_part = [first_name,prefix].join(" ").strip
    namepart = [last_name,last_name_part].delete_if{|a| a==""}.compact.join(", ")
    birthpart = [year_of_birth, year_of_death].delete_if{|a| a==""}.compact.join("-")
    birthpart = "(#{birthpart})" if birthpart != ""
    rname = [namepart,birthpart].delete_if{|a| a==""}.join(" ")
    return rname == "" ? "-geen naam opgevoerd (#{id})-" : rname
  end

  def search_name
    last_name_part = [first_name,prefix].join(" ").strip
    [last_name,last_name_part].delete_if{|a| a==""}.compact.join(", ")
  end

  def name?
    search_name != ""
  end

  def title
    name
  end

  def retrieve_rkd_artists!
    return [rkd_artist] if rkd_artist
    rkd_artists = RkdArtist.search_rkd_by_artist(self)
    if rkd_artists.count == 1
      self.rkd_artist = rkd_artists.first
      self.save unless self.changes == {}
    end
    rkd_artists
  end

  def artists_with_same_name
    Artist.all
  end

  def died?
    place_of_death? or year_of_death?
  end

  def born?
    place_of_birth? or year_of_birth?
  end

  def combine_artists_with_ids(artist_ids_to_combine_with, options = {})
    options = {only_when_created_at_date_is_equal: false}.merge(options)


    artists = Artist.where(id: artist_ids_to_combine_with)
    artists = artists.created_at_date(self.created_at) if options[:only_when_created_at_date_is_equal]
    count = 0
    artists.each do |artist|
      artist.works.each do |work|
        work.artists << self unless work.artists.include?(self)
        work.add_lognoteline "[combine_artists] adding artist #{self.id} [#{self.name}] to this work"
        work.add_lognoteline "[combine_artists] removing artist #{artist.id} [#{artist.name}] from this work"
        work.save
        count +=1
      end
      artist.destroy
    end
    count
  end

  def touch_works
    works.each{|work| work.touch}
  end



  class << self
    def names_hash
      unless defined?(@@artist_names)
        @@artist_names = {}
        Artist.select("id,first_name,prefix,last_name,place_of_birth,year_of_birth,year_of_death").each do |artist|
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
      return rv
    end

    def destroy_all_empty_artists!
      self.empty_artists.collect{|a| a.destroy}
    end

    def empty_artists
      _empty_artists = []
      self.select(:id).each do |a|
        _empty_artists << a if a.works.count == 0
      end
      _empty_artists
    end

    def destroy_all_artists_with_no_name_that_have_works_that_already_belong_to_artists_with_a_name!
      self.artists_with_no_name_that_have_works_that_already_belong_to_artists_with_a_name.collect{|a| a.destroy}

    end
    def artists_with_no_name_that_have_works_that_already_belong_to_artists_with_a_name
      _empty_artists = []
      self.no_name.select(:id).each do |a|
        if a.works.count > 0
          artists_with_name = a.works.collect do |w|
            w.artists.have_name.count > 0
          end.compact.uniq
          if artists_with_name.length == 1 and artists_with_name.first == true
            _empty_artists << a
          end
        end
      end
      _empty_artists
    end

    def group_by_name
      groups = {}
      self.all.each do | artist |
        groups[artist.name] = [] unless groups[artist.name]
        groups[artist.name] << artist.id
      end
      groups
    end

    def remove_artist_with_no_works

    end

    def collapse_by_name!(options = {})
      options = {only_when_created_at_date_is_equal: true}.merge(options)
      self.group_by_name.each do |name, ids|
        first = ids.delete_at(0)
        first_artist=Artist.find(first)
        first_artist.combine_artists_with_ids(ids, options)
      end
    end
  end
end
