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
      api_response["sterfdatum_eind"].to_date.year
    rescue
    end
  end

  def place_of_birth
    api_response["geboorteplaats"].first
  end

  def year_of_birth
    begin
      api_response["geboortedatum_eind"].to_date.year
    rescue
    end
  end

  def substring
    rv = ""
    rv += "#{year_of_birth} (#{place_of_birth})" if year_of_birth
    rv += year_of_death ? " - #{year_of_death} (#{place_of_death})" : " - heden(?)"
  end

  def to_param
    rkd_id.to_s
  end

  class << self
    def search_rkd_by_artist artist
      self.search_rkd(artist.search_name)
    end
    def search_rkd search
      search_rkd_by_artist(search) if search.is_a? Artist
      json_response = nil
      rkd_artists = []
      if !search.nil? and !search.empty?
        encoded_search_name = ERB::Util.url_encode(search)
        json_search_response = CachedApi.query("https://api.rkd.nl/api/search/artists?sa[kunstenaarsnaam]=#{encoded_search_name}")
        rkd_artists = json_search_response["response"]["docs"].collect do | doc |
          rkd_id = doc['priref'].to_i
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
        end.compact
        rkd_artists.delete_if{|a| a.api_response["voorkeursnaam_naam"]}
      end

      rkd_artists.compact
    end
  end

end
