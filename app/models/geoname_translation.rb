class GeonameTranslation < ApplicationRecord
  scope :locale, ->(language_code){ where(language: language_code)}

  class << self
    def import!
      self.delete_all
      puts "Importing dutch alternate names data..."

      self.transaction do
        File.open('data/nl_alternateNames.txt').read.split(/\n/).collect{|a| a.split(/\t/) }.each do |a|
          GeonameTranslation.create(translation_id: a[0], geoname_id: a[1], language: a[2], label: a[3], priority: a[4].to_i-a[6].to_i-a[7].to_i)
        end
      end
    end
  end
end
