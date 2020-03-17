# frozen_string_literal: true

class CreateCreateGeonameTranslations < ActiveRecord::Migration[4.2]
  def change
    create_table :geoname_translations do |t|
      t.integer :translation_id
      t.integer :geoname_id
      t.string :language
      t.string :label
      t.integer :priority

      t.timestamps null: false
    end
    if ["development", "staging", "testing"].include? Rails.env.to_s
      File.open("data/nl_alternateNames.txt").read.split(/\n/).collect { |a| a.split(/\t/) }.each { |a| GeonameTranslation.create(translation_id: a[0], geoname_id: a[1], language: a[2], label: a[3], priority: a[4]) }
    end
  end
end
