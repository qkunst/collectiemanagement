class Involvement < ApplicationRecord

  def locality_geoname_name
    gs = GeonameSummary.where(geoname_id: locality_geoname_id).first
    return "#{gs.name} (#{gs.parent_description})" if gs
  end
end
