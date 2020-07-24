# frozen_string_literal: true

# non AR model for db-less artist methods
class SimpleArtist
  include Artist::NameRenderer

  attr_accessor :first_name, :prefix, :last_name, :place_of_birth, :place_of_death, :year_of_birth, :year_of_death, :artist_name

  def id
    "-"
  end

  def initialize kvs = {}
    kvs.each do |k, v|
      send("#{k}=", v)
    end
  end

  def self.new_from_json json
    if json && (json.strip != "")
      obj = JSON.parse(json)
      if obj.is_a? Array
        obj.collect { |a| new(a) }
      else
        new(a)
      end
    else
      new
    end
  end
end
