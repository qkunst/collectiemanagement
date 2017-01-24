class GeonameSummary < ApplicationRecord
  scope :selectable, -> { where(type_code: ["AREA","PPL", "PPLA", "PPLA2", "PPLC", "PPLG", "PPLH", "PPLL", "PPLQ", "PPLS", "PPLX", "COUNTRY", "ADM1", "ADM2-NL"]) }

  def to_s
    "#<GeonameSummary id=#{id} name=\"#{name}\" type_code=#{type_code} desc=\"#{parent_description[0..30]}\">"
  end

  def priority
    base = 0
    base += 1 if parent_description[0..1] == "NL"
    base += 1 if ["PPLC", "PPLG"].include? type_code
    base
  end

  def <=> other
    other.priority <=> self.priority
  end

  class << self
    def search name
      if name.nil? or name.to_s.empty?
        return []
      end
      results = self.selectable.where(arel_table[:name].matches(name))
      if results.count > 0
        return results.sort
      end

      if name.match(/\((.*)\)/)
        description = name.match(/\((.*)\)/)[1]
        name = name.gsub(/\((.*)\)/, '').strip
        results = self.selectable.where(arel_table[:name].matches(name))
        return results.select{|a| a.parent_description.match(description)}
      end

      # results = self.selectable.where(arel_table[:name].matches("%#{name}%"))
      # return results.sort if results.count > 1
      # return []
    end
    def to_array
      self.all.collect{|a|  {id: a.geoname_id, name: a.name, desc: a.parent_description }}
    end

    def to_hash
      h = {}
      self.all.each do |summ|
        h[summ.geoname_id] = {name: summ.name, desc: summ.parent_description }
      end
      h
    end
  end
end
