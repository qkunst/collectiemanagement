# frozen_string_literal: true

# non AR model for db-less artist methods
class SimpleArtist
  include Artist::NameRenderer

  attr_accessor :first_name, :prefix, :last_name, :place_of_birth, :place_of_death, :year_of_birth, :year_of_death

  def id
    "-"
  end

  def initialize kvs={}
    kvs.each do |k,v|
      self.send("#{k}=", v)
    end
  end

  def self.new_from_json json
    if json and json.strip != ""
      obj = JSON.parse(json)
      if obj.is_a? Array
        return obj.collect{|a| self.new(a)}
      else
        return self.new(a)
      end
    else
      self.new
    end
  end


end
