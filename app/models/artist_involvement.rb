class ArtistInvolvement < ApplicationRecord
  belongs_to :artist
  belongs_to :involvement
  belongs_to :geoname_summary, foreign_key: :place_geoname_id, primary_key: :geoname_id

  accepts_nested_attributes_for :involvement

  validates_presence_of :involvement_type

  scope :educational, -> {where(involvement_type: [:educational, :education])}
  scope :professional, -> {where(involvement_type: :professional)}
  scope :related_to_geoname_ids, ->(geoname_ids) do
    geoname_ids = [geoname_ids].flatten.collect{|a| a if a.to_i > 9999}.compact
    (geoname_ids.length > 0) ? joins(:geoname_summary).where(GeonameSummary.arel_table[:geoname_ids].matches_any(geoname_ids.collect{|a| "%#{a}%" })) : where("true = false")
  end

  def professional?
    involvement_type.to_s == "professional"
  end
  def educational?
    involvement_type.to_s == "educational"
  end

  def to_s(options={})
    if options[:format] == :short
      if start_year or end_year
        return "#{name} (#{start_year}-#{end_year})"
      else
        return name
      end
    end
    pgn = place_geoname_name == name ? nil : place_geoname_name
    "#{name} (#{[pgn, "#{start_year}-#{end_year}"].delete_if{|a| a == "-"}.compact.join(", ")})".gsub("()","").strip
  end

  def place_geoname_name
    gs = geoname_summary
    gs ||= GeonameSummary.where(geoname_id: involvement.place_geoname_id).first if involvement
    return gs.label if gs
  end

  def name
    return involvement.name if involvement
    return place if place
    return place_geoname_name
  end
end
