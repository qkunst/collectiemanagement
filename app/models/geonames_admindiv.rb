# frozen_string_literal: true

# == Schema Information
#
# Table name: geonames_admindivs
#
#  id         :bigint           not null, primary key
#  admin_code :string
#  admin_type :integer
#  asciiname  :string
#  geonameid  :bigint
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_geonames_admindivs_on_admin_code  (admin_code)
#
class GeonamesAdmindiv < ApplicationRecord
  has_many :translations, foreign_key: :geoname_id, primary_key: :geonameid, class_name: "GeonameTranslation"

  scope :netherlands, -> { where("geonames_admindivs.admin_code LIKE 'NL%'") }

  def localized_name locale = :nl
    localized_names.last
  end

  def localized_names locale = :nl
    names = translations.locale(locale).order(:priority).collect { |a| a.label }
    names = [name] if names.count == 0
    names
  end

  def childeren
    if admin_type == 1
      GeonamesAdmindiv.where("geonames_admindivs.admin_code LIKE ?", "#{admin_code}.%")
    elsif admin_type == 2
      _cc, admin1_code, admin2_code = admin_code.split(".")
      Geoname.where(admin2_code: admin2_code, admin1_code: admin1_code).populated_places
    end
  end

  def country
    @country ||= GeonamesCountry.where(iso: admin_code.split(".").first).first
  end

  def country_localized_name
    @country_localized_name ||= country ? country.localized_name : admin_code.split(".").first
  end

  def parent_localized_name
    @parent_localized_name ||= if (admin_type == 2) && parent
      parent.localized_name
    elsif admin_type == 1
      country_localized_name
    else
      admin_code.split(".")[0..1].join(" > ")
    end
  end

  def geoname_id
    geonameid
  end

  def parent_geoname_ids
    geo_ids = []
    geo_ids << country.geoname_id if country
    geo_ids << parent.geoname_id if parent
    geo_ids
  end

  def parents_description
    admin_type == 1 ? country_localized_name : [country_localized_name, parent_localized_name].compact.join(" > ")
  end

  def parent
    @parent ||= if admin_type == 1
      country
    elsif admin_type == 2
      GeonamesAdmindiv.where(admin_code: admin_code.split(".")[0..1].join(".")).first
    end
  end

  def find_or_create_corresponding_geoname_summary
    gs = GeonameSummary.find_or_initialize_by(geoname_id: geonameid, language: :nl)
    gs.name = localized_name
    gs.parent_description = parents_description
    gs.type_code = "ADM#{admin_type}"
    gs.type_code = "ADM2-NL" if (admin_code.split(".")[0] == "NL") && (admin_type == 2)
    gs.save
  end

  class << self
    def find_or_create_corresponding_geoname_summary
      transaction do
        all.each { |a| a.find_or_create_corresponding_geoname_summary }
      end
    end

    def import!
      delete_all
      puts "Importing admin1 areas..."
      transaction do
        File.open("data/admin1CodesASCII.txt").read.split("\n").collect { |a| a.split("\t") }.each { |a| GeonamesAdmindiv.create(admin_code: a[0], name: a[1], asciiname: a[2], geonameid: a[3], admin_type: 1) }
      end
      puts "Importing admin2 areas..."
      transaction do
        File.open("data/admin2Codes.txt").read.split("\n").collect { |a| a.split("\t") }.each { |a| GeonamesAdmindiv.create(admin_code: a[0], name: a[1], asciiname: a[2], geonameid: a[3], admin_type: 2) }
      end
      find_or_create_corresponding_geoname_summary
    end
  end
end
