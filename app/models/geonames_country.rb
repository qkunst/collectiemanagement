class GeonamesCountry < ApplicationRecord
  has_many :translations, foreign_key: :geoname_id, primary_key: :geoname_id, class_name: 'GeonameTranslation'

  def localized_name locale=:nl
    lname = translations.locale(locale).first
    lname ? lname.label : name
  end

  def admin_divisions
    GeonamesAdmindiv.where("geonames_admindivs.admin_code LIKE ?", "#{iso.to_s.upcase}%")
  end

  def localized_name locale=:nl
    lname = translations.locale(locale).first
    lname ? lname.label : country_name
  end

  def parent_description
    "Land"
  end

  def find_or_create_corresponding_geoname_summary locale=:nl
    gs = GeonameSummary.find_or_initialize_by(geoname_id: geoname_id, language: locale)
    gs.name = localized_name(locale)
    gs.parent_description = parent_description
    gs.type_code = "COUNTRY"
    gs.save
  end

  class << self
    def find_or_create_corresponding_geoname_summary
      self.all.each{|a| a.find_or_create_corresponding_geoname_summary}
    end
  end

end
