# frozen_string_literal: true

class CreateGeonamesCountries < ActiveRecord::Migration[4.2]
  def change
    create_table :geonames_countries do |t|
      t.string :iso
      t.string :iso3
      t.string :iso_num
      t.string :fips
      t.string :country_name
      t.string :capital_name
      t.integer :area
      t.integer :population
      t.string :continent
      t.string :tld
      t.string :currency_code
      t.string :currency_name
      t.string :phone
      t.string :postal_code_format
      t.string :postal_code_regex
      t.string :languages
      t.integer :geoname_id
      t.string :neighbours
      t.string :equivalent_fips_code

      t.timestamps null: false
    end
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
end
