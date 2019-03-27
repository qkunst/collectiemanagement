# frozen_string_literal: true

class AddGeodataToTables < ActiveRecord::Migration
  def self.up
    if ["development", "staging", "testing"].include? Rails.env.to_s
      Geoname.delete_all
      File.open('data/NL.txt').read.split(/\n/).collect{|a| a.split(/\t/) }.each{|a| Geoname.create(geonameid: a[0], name: a[1], asciiname: a[2], alternatenames: a[3], latitude: a[4], longitude: a[5], feature_class: a[6], feature_code: a[7], country_code: a[8], cc2: a[9], admin1_code: a[10], admin2_code: a[11], admin3_code: a[12], admin4_code: a[13], population: a[14], elevation: a[15], dem: a[16], timezone: a[17], modification_date: a[18]) }
      GeonamesAdmindiv.delete_all
      File.open('data/admin1CodesASCII.txt').read.split(/\n/).collect{|a| a.split(/\t/) }.each{|a| GeonamesAdmindiv.create(admin_code: a[0], name: a[1], asciiname: a[2], geonameid: a[3], admin_type: 1) }
      File.open('data/admin2Codes.txt').read.split(/\n/).collect{|a| a.split(/\t/) }.each{|a| GeonamesAdmindiv.create(admin_code: a[0], name: a[1], asciiname: a[2], geonameid: a[3], admin_type: 2) }
    end
  end
  def self.down
    if ["development", "staging", "testing"].include? Rails.env.to_s
      Geoname.delete_all
      GeonamesAdmindiv.delete_all
    end
  end
end
