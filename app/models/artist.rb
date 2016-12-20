class Artist < ApplicationRecord
  has_paper_trail
  has_many :artist_involvements
  has_and_belongs_to_many :works
  belongs_to :rdk_artist
  has_many :involvements, through: :artist_involvement
  after_save :touch_works
  belongs_to :import_collection

  scope :exclude_artist, ->(artist){where("artists.id != ?", artist.id)}
  scope :order_by_name, ->{order(:last_name, :prefix, :first_name)}
  # accepts_nested_attributes_for :artist_involvements

  def name
    last_name_part = [first_name,prefix].join(" ").strip
    namepart = [last_name,last_name_part].delete_if{|a| a==""}.compact.join(", ")
    birthpart = [year_of_birth, year_of_death].delete_if{|a| a==""}.compact.join("-")
    birthpart = "(#{birthpart})" if birthpart != ""
    rname = [namepart,birthpart].delete_if{|a| a==""}.join(" ")
    return rname == "" ? "-geen naam opgevoerd (#{id})-" : rname
  end

  def title
    name
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

  def combine_artists_with_ids(artist_ids_to_combine_with)
    artists = Artist.where(id: artist_ids_to_combine_with)

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

  def search_rkd
    require 'open-uri'
    json_response = nil
    search_name = name
    unless search_name.starts_with?("-geen naam opgevoerd")
      encoded_search_name = ERB::Util.url_encode(search_name)
      json_response = CachedApi.query("https://api.rkd.nl/api/search/artists?sa[kunstenaarsnaam]=#{encoded_search_name}")
      if json_response["response"]["docs"].count == 1
        # json_response =
      end
    end

    json_response
    # aantekening maarten: https://api.rkd.nl/api/search/artists?sa[kunstenaarsnaam]=sjoerd%20buisman&format=json -> https://api.rkd.nl/api/record/artists/13928?format=json
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

    def clean!
      self.empty_artists.each{|a| a.destroy}
    end

    def empty_artists
      _empty_artists = []
      self.select(:id).each do |a|
        _empty_artists << a if a.works.count == 0
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

    def collapse_by_name
      self.group_by_name.each do |name, ids|
        first = ids.delete_at(0)
        first_artist=Artist.find(first)
        first_artist.combine_artists_with_ids(ids)
      end
    end
  end
end
