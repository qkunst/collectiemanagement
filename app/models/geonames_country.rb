# frozen_string_literal: true

# == Schema Information
#
# Table name: geonames_countries
#
#  id                   :bigint           not null, primary key
#  area                 :integer
#  capital_name         :string
#  continent            :string
#  country_name         :string
#  currency_code        :string
#  currency_name        :string
#  equivalent_fips_code :string
#  fips                 :string
#  iso                  :string
#  iso3                 :string
#  iso_num              :string
#  languages            :string
#  neighbours           :string
#  phone                :string
#  population           :integer
#  postal_code_format   :string
#  postal_code_regex    :string
#  tld                  :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  geoname_id           :bigint
#
class GeonamesCountry < ApplicationRecord
  has_many :translations, foreign_key: :geoname_id, primary_key: :geoname_id, class_name: "GeonameTranslation"

  def localized_name locale = :nl
    localized_names.last
  end

  def localized_names locale = :nl
    names = translations.locale(locale).order(:priority).collect { |a| a.label }
    names = [country_name] if names.count == 0
    names
  end

  def admin_divisions
    GeonamesAdmindiv.where("geonames_admindivs.admin_code LIKE ?", "#{iso.to_s.upcase}%")
  end

  def geonames_continent
    GeonamesCountry.find_by(iso3: continent, iso: continent)
  end

  def parent_geoname_ids
    if geonames_continent
      [geonames_continent.geoname_id]
    else
      []
    end
  end

  def geonameid
    geoname_id
  end

  def parent_description
    "Land"
  end

  def find_or_create_corresponding_geoname_summary locale = :nl
    gs = GeonameSummary.find_or_initialize_by(geoname_id: geoname_id, language: locale)
    gs.name = localized_name(locale)
    gs.parent_description = parent_description
    gs.type_code = "COUNTRY"
    gs.save
  end

  class << self
    def find_or_create_corresponding_geoname_summary
      all.each { |a| a.find_or_create_corresponding_geoname_summary }
    end

    def import!
      delete_all
      puts "Importing countries..."
      transaction do
        File.open("data/countryInfo.txt").read.split("\n").collect { |a| a.split("\t") }.each do |a|
          GeonamesCountry.create(
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
            equivalent_fips_code: a[18]
          )
        end
      end
      transaction do
        continents = [["AF", "Africa", 6255146],
          ["AS", "Asia", 6255147],
          ["EU", "Europe", 6255148],
          ["NA", "North America", 6255149],
          ["OC", "Oceania", 6255151],
          ["SA", "South America", 6255150],
          ["AN", "Antarctica", 6255152]]
        continents.each do |c|
          GeonamesCountry.create(iso: c[0], iso3: c[0], fips: c[0], country_name: c[1], geoname_id: c[2])
        end
      end
      find_or_create_corresponding_geoname_summary
    end
  end
end
