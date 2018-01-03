class Involvement < ApplicationRecord
  before_save :set_geoname_id_from_name!

  belongs_to :geoname_summary, foreign_key: :place_geoname_id, primary_key: :geoname_id, optional: true

  scope :related_to_geoname_id, ->(geoname_id){ (geoname_id > 9999) ? joins(:geoname_summary).where(GeonameSummary.arel_table[:geoname_ids].matches("%#{geoname_id}%")) : where("true = false") }

  def place_geoname_name
    return geoname_summary.label if geoname_summary
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
