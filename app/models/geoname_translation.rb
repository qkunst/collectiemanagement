# frozen_string_literal: true

# == Schema Information
#
# Table name: geoname_translations
#
#  id             :bigint           not null, primary key
#  label          :string
#  language       :string
#  priority       :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  geoname_id     :bigint
#  translation_id :bigint
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
        File.open("data/nl_alternateNames.txt").read.split("\n").collect { |a| a.split("\t") }.each do |a|
          GeonameTranslation.create(translation_id: a[0], geoname_id: a[1], language: a[2], label: a[3], priority: a[4].to_i - a[6].to_i - a[7].to_i)
        end
      end
    end
  end
end
