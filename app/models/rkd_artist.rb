# frozen_string_literal: true

class RkdArtist < ApplicationRecord
  def end_user_link
    "https://rkd.nl/nl/explore/artists/#{rkd_id}"
  end


  def domains
    api_response["domein"]
  end

  def place_of_death
    api_response["sterfplaats"].first
  end

  def year_of_death
    begin
      if api_response["sterfdatum_eind"].match /\d\d\d\d/
        api_response["sterfdatum_eind"].to_i
      else
        api_response["sterfdatum_eind"].to_date.year if api_response["sterfdatum_eind"].length > 4
      end
    rescue
    end
  end

  def date_of_death
    begin
      api_response["sterfdatum_eind"].to_date if api_response["sterfdatum_eind"].length > 4
    rescue
    end
  end

  def place_of_birth
    api_response["geboorteplaats"].first
  end

  def place_of_death_geoname_id
    hit = GeonameSummary.search(place_of_death).first
    hit.id if hit
  end

  def place_of_birth_geoname_id
    hit = GeonameSummary.search(place_of_birth).first
    hit.geoname_id if hit
  end

  def year_of_birth
    begin
      if api_response["geboortedatum_eind"].match /\d\d\d\d/
        api_response["geboortedatum_eind"].to_i
      else
        api_response["geboortedatum_eind"].to_date.year if api_response["geboortedatum_eind"].length > 4
      end
    rescue
    end
  end

  def date_of_birth
    begin
      api_response["geboortedatum_eind"].to_date if api_response["geboortedatum_eind"].length > 4
    rescue
    end
  end

  def kunstenaarsnaam
    api_response["kunstenaarsnaam"].gsub(/\(.*\)/,'').strip
  end

  def last_name
    kunstenaarsnaam.split(",")[0]
  end

  def first_name
    kunstenaarsnaam.split(",")[1]
  end

  def to_artist_params
    {
      date_of_birth: date_of_birth,
      date_of_death: date_of_death,
      year_of_birth: year_of_birth,
      year_of_death: year_of_death,
      place_of_birth: place_of_birth,
      place_of_death: place_of_death,
      last_name: last_name,
      first_name: first_name,
      place_of_death_geoname_id: place_of_death_geoname_id,
      place_of_birth_geoname_id: place_of_birth_geoname_id,
      rkd_artist_id: rkd_id
      # first_name:
      # t.string   "place_of_birth"
      # t.string   "place_of_death"
      # t.integer  "year_of_birth"
      # t.integer  "year_of_death"
      # t.text     "description"
      # t.datetime "created_at",                null: false
      # t.datetime "updated_at",                null: false
      # t.string   "first_name"
      # t.string   "prefix"
      # t.string   "last_name"
      # t.integer  "import_collection_id"
      # t.integer  "rkd_artist_id"
      # t.integer  "place_of_death_geoname_id"
      # t.integer  "place_of_birth_geoname_id"
    }
  end

  def to_artist_involvement_params
    artist_involvements = []
    #=> ArtistInvolvement(id: integer, involvement_id: integer, artist_id: integer, start_year: integer, end_year: integer, created_at: datetime, updated_at: datetime, involvement_type: string)
    # t.integer  "involvement_id"
    # t.integer  "artist_id"
    # t.integer  "start_year"
    # t.integer  "end_year"
    # t.datetime "created_at",       null: false
    # t.datetime "updated_at",       null: false
    # t.string   "involvement_type"
    api_response["werkzaamheid"].each do | werkzaamheid |
      involvement = {
        involvement_type: :professional
      }
      involvement[:place] = werkzaamheid["plaats_van_werkzaamheid"]
      geoname = GeonameSummary.search(involvement[:place]).first
      involvement[:place_geoname_id] = geoname.geoname_id if geoname
      involvement[:start_year] = werkzaamheid["plaats_v_werkzh_begindatum"]
      involvement[:end_year] = werkzaamheid["plaats_v_werkzh_einddatum"]
      artist_involvements << involvement
    end
    api_response["academies"].each do | academie |
      involvement_id = Involvement.find_or_create_by(name: academie["academie"])
      involvement = {
        involvement_id: involvement_id.id,
        involvement_type: :educational
      }
      involvement[:place] = involvement_id.place
      involvement[:place_geoname_id] = involvement_id.place_geoname_id
      opmerkingen_academie = academie["opmerking_academie"]
      if opmerkingen_academie.to_s.strip.match(/\d\d\d\d-\d\d\d\d/)
        involvement[:start_year] = opmerkingen_academie.to_s.strip.split("-")[0]
        involvement[:end_year] = opmerkingen_academie.to_s.strip.split("-")[1]
      end

      artist_involvements << involvement
    end
    artist_involvements
  end

  def to_artist
    artist = Artist.new(to_artist_params)
    self.to_artist_involvement_params.each do |inv|
      artist.artist_involvements.new(inv)
    end
    artist
  end

  def substring
    rv = ""
    rv += "#{year_of_birth} (#{place_of_birth})" if year_of_birth
    rv += year_of_death ? " - #{year_of_death} (#{place_of_death})" : ""
  end

  def to_param
    rkd_id.to_s
  end

  class << self
    def search_rkd_by_artist artist
      self.search_rkd(artist.search_name)
    end
    def get_rkd_artist_by_rkd_id rkd_id
      rkd_id = rkd_id.to_i
      api_response_source_url = "https://api.rkd.nl/api/record/artists/#{rkd_id}?format=json"
      json_artist_response = CachedApi.query(api_response_source_url)["response"]["docs"]
      rkd_artist = nil
      if rkd_id > 0
        rkd_artist = self.find_or_initialize_by(rkd_id: rkd_id)
        rkd_artist.api_response_source_url = api_response_source_url
        rkd_artist.api_response = json_artist_response.first
        rkd_artist.name = json_artist_response.first["kunstenaarsnaam"]
        rkd_artist.save
        rkd_artist
      end
      rkd_artist
    end
    def search_rkd search
      search_rkd_by_artist(search) if search.is_a? Artist
      json_response = nil
      rkd_artists = []
      begin
        if !search.nil? and !search.empty?
          search = search.strip
          if search.strip.match(/\d*/).to_s == search.strip
            rkd_artists << get_rkd_artist_by_rkd_id(search)
          else
            encoded_search_name = ERB::Util.url_encode(search)
            json_search_response = CachedApi.query("https://api.rkd.nl/api/search/artists?sa[kunstenaarsnaam]=#{encoded_search_name}")
            rkd_artists = json_search_response["response"]["docs"].collect do | doc |
              rkd_id = doc['priref'].to_i
              get_rkd_artist_by_rkd_id(rkd_id)
            end.compact
            rkd_artists.delete_if{|a| a.api_response["voorkeursnaam_naam"]}
          end
        end
        rkd_artists.compact
      rescue OpenURI::HTTPError
        []
      end
    end
  end

end
