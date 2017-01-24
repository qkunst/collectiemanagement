class Involvement < ApplicationRecord
  before_save :set_geoname_id_from_name!

  def place_geoname_name
    gs = GeonameSummary.where(geoname_id: place_geoname_id).first
    return "#{gs.name} (#{gs.parent_description})" if gs
  end

  def set_geoname_id_from_name!
    unless place
      match = name.to_s.match(/\((.*)\)/)
      self.place = match[1] if match
    end
    unless place_geoname_id
      potential = GeonameSummary.search(self.place)
      self.place_geoname_id = potential.first.geoname_id if potential.first
    end
  end

end
