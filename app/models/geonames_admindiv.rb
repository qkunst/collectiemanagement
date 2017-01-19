class GeonamesAdmindiv < ApplicationRecord
  has_many :translations, foreign_key: :geoname_id, primary_key: :geonameid, class_name: 'GeonameTranslation'

  scope :netherlands, -> { where("geonames_admindivs.admin_code LIKE 'NL%'")}

  def localized_name locale=:nl
    lname = translations.locale(locale).first
    lname ? lname.label : name
  end

  def childeren
    if admin_type == 1
      GeonamesAdmindiv.where("geonames_admindivs.admin_code LIKE ?", "#{admin_code}.%")
    elsif admin_type == 2
      cc, admin1_code, admin2_code = admin_code.split('.')
      Geoname.where(admin2_code: admin2_code, admin1_code: admin1_code).populated_places
    end
  end

  def country
    @country ||= GeonamesCountry.where(iso: admin_code.split('.').first).first
  end

  def country_localized_name
    @country_localized_name ||= country ? country.localized_name : admin_code.split('.').first
  end

  def parent_localized_name
    @parent_localized_name ||= if admin_type == 2 and parent
      parent.localized_name
    elsif admin_type == 1
      country_localized_name
    else
      admin_code.split('.')[0..1].join(" > ")
    end
  end

  def parents_description
    (admin_type == 1) ? country_localized_name : [country_localized_name, parent_localized_name].compact.join(" > ")
  end

  def parent
    @parent ||= if admin_type == 1
      country
    elsif admin_type == 2
      GeonamesAdmindiv.where(admin_code: admin_code.split('.')[0..1].join(".")).first
    end
  end

  def find_or_create_corresponding_geoname_summary
    gs = GeonameSummary.find_or_initialize_by(geoname_id: geonameid, language: :nl)
    gs.name = localized_name
    gs.parent_description = parents_description
    gs.type_code = "ADM#{admin_type}"
    gs.type_code = "ADM2-NL" if admin_code.split('.')[0] == "NL" and admin_type == 2
    gs.save
  end

  class << self
    def find_or_create_corresponding_geoname_summary
      self.transaction do
        self.all.each{|a| a.find_or_create_corresponding_geoname_summary}
      end
    end
    def import!
      self.delete_all
      self.transaction do
        File.open('data/admin1CodesASCII.txt').read.split(/\n/).collect{|a| a.split(/\t/) }.each{|a| GeonamesAdmindiv.create(admin_code: a[0], name: a[1], asciiname: a[2], geonameid: a[3], admin_type: 1) }
      end
      self.transaction do
        File.open('data/admin2Codes.txt').read.split(/\n/).collect{|a| a.split(/\t/) }.each{|a| GeonamesAdmindiv.create(admin_code: a[0], name: a[1], asciiname: a[2], geonameid: a[3], admin_type: 2) }
      end
      self.find_or_create_corresponding_geoname_summary
    end
  end
end
