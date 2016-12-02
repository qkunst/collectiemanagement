class GeonameSummary < ActiveRecord::Base
  scope :selectable, -> { where(type_code: ["AREA","PPL", "PPLA", "PPLA2", "PPLC", "PPLG", "PPLH", "PPLL", "PPLQ", "PPLS", "PPLX", "COUNTRY", "ADM1", "ADM2-NL"]) }

  class << self
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
