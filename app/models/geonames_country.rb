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
    def import!
      self.delete_all
      puts "Importing countries..."
      self.transaction do
        File.open('data/countryInfo.txt').read.split(/\n/).collect{|a| a.split(/\t/) }.each{|a| GeonamesCountry.create(
          iso: a[0],
          iso3: a[1],
          iso_num: a[2],
          fips: a[3],
          country_name: a[4],
          capital_name: a[5],
          area: a[6],
          population: a[7],
          continent: a[8],
          tld: a[9],
          currency_code: a[10],
          currency_name: a[11],
          phone: a[12],
          postal_code_format: a[13],
          postal_code_regex: a[14],
          languages: a[15],
          geoname_id: a[16],
          neighbours: a[17],
          equivalent_fips_code: a[18]) }
      end
      self.find_or_create_corresponding_geoname_summary
    end

  end

end
