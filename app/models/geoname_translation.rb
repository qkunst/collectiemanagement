# frozen_string_literal: true
# == Schema Information
#
# Table name: geoname_translations
#
#  id             :integer          not null, primary key
#  translation_id :integer
#  geoname_id     :integer
#  language       :string
#  label          :string
#  priority       :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_geoname_translations_on_geoname_id  (geoname_id)
#

class GeonameTranslation < ApplicationRecord
  scope :locale, ->(language_code) { where(language: language_code) }

  class << self
    def import!
      delete_all
      puts "Importing dutch alternate names data..."

      transaction do
        File.read("data/nl_alternateNames.txt").split("\n").collect { |a| a.split("\t") }.each do |a|
          GeonameTranslation.create(translation_id: a[0], geoname_id: a[1], language: a[2], label: a[3], priority: a[4].to_i - a[6].to_i - a[7].to_i)
        end
      end
    end
  end
end
