# frozen_string_literal: true

class Geoname < ApplicationRecord
  scope :populated_places, -> { where(feature_code: ["PPL", "PPLA", "PPLA2", "PPLC", "PPLG", "PPLH", "PPLL", "PPLQ", "PPLS", "PPLX", "ISL"]) }

  has_many :translations, foreign_key: :geoname_id, primary_key: :geonameid, class_name: "GeonameTranslation"

  def admin1
    @admin1 ||= GeonamesAdmindiv.where(admin_code: "#{country_code}.#{admin1_code}").first
  end

  def admin2
    @admin2 ||= GeonamesAdmindiv.where(admin_code: "#{country_code}.#{admin1_code}.#{admin2_code}").first
  end

  def country
    @country ||= GeonamesCountry.where(iso: country_code).first
  end

  def localized_name locale = :nl
    localized_names.last
  end

  def localized_names locale = :nl
    names = translations.locale(locale).order(:priority).collect { |a| a.label }
    names = [name] if names.count == 0
    names
  end

  def parent_description
    ([country_code] + [admin1, admin2].compact.collect { |a| a.localized_name }).join(" > ")
  end

  def parent_geoname_ids
    geo_ids = []
    geo_ids << country.geoname_id if country
    geo_ids << admin1.geonameid if admin1
    geo_ids << admin2.geonameid if admin2
    geo_ids
  end

  def find_or_create_corresponding_geoname_summary locale = :nl
    gs = GeonameSummary.find_or_initialize_by(geoname_id: geonameid, language: locale)
    gs.name = localized_name(locale)
    gs.parent_description = parent_description
    gs.type_code = feature_code
    gs.save
  end

  class << self
    def find_or_create_corresponding_geoname_summary
      all.each { |a| a.find_or_create_corresponding_geoname_summary }
    end

    def import!
      delete_all
      puts "Importing NL data..."
      transaction do
        File.open("data/NL.txt").read.split(/\n/).collect { |a| a.split(/\t/) }.each { |a| Geoname.create(geonameid: a[0], name: a[1], asciiname: a[2], alternatenames: a[3], latitude: a[4], longitude: a[5], feature_class: a[6], feature_code: a[7], country_code: a[8], cc2: a[9], admin1_code: a[10], admin2_code: a[11], admin3_code: a[12], admin4_code: a[13], population: a[14], elevation: a[15], dem: a[16], timezone: a[17], modification_date: a[18]) }
      end
      puts "Importing cities5000 data..."

      transaction do
        File.open("data/cities5000.txt").read.split(/\n/).collect { |a| a.split(/\t/) }.each do |a|
          gn = Geoname.where(geonameid: a[0]).first_or_initialize
          gn.update(name: a[1], asciiname: a[2], alternatenames: a[3], latitude: a[4], longitude: a[5], feature_class: a[6], feature_code: a[7], country_code: a[8], cc2: a[9], admin1_code: a[10], admin2_code: a[11], admin3_code: a[12], admin4_code: a[13], population: a[14], elevation: a[15], dem: a[16], timezone: a[17], modification_date: a[18])
        end
      end
      puts "Generating summaries data..."
      transaction do
        find_or_create_corresponding_geoname_summary
      end
    end

    def import_all!
      GeonameTranslation.import!
      GeonamesAdmindiv.import!
      GeonamesCountry.import!
      import!
    end
  end
end
