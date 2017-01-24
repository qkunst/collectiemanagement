class ArtistInvolvement < ApplicationRecord
  belongs_to :artist
  belongs_to :involvement

  accepts_nested_attributes_for :involvement

  validates_presence_of :involvement_type

  scope :educational, -> {where(involvement_type: :educational)}
  scope :professional, -> {where(involvement_type: :professional)}

  def professional?
    involvement_type.to_s == "professional"
  end
  def educational?
    involvement_type.to_s == "educational"
  end

  def place_geoname_name
    gs = GeonameSummary.where(geoname_id: place_geoname_id).first
    gs ||= GeonameSummary.where(geoname_id: involvement.place_geoname_id).first if involvement
    return gs.label if gs
  end

  def name
    return involvement.name if involvement
    return place
  end
end
