class GeonameTranslation < ApplicationRecord
  scope :locale, ->(language_code){ where(language: language_code)}

  class << self
    def import!
      self.delete_all
      self.transaction do
        File.open('data/nl_alternateNames.txt').read.split(/\n/).collect{|a| a.split(/\t/) }.each{|a| GeonameTranslation.create(translation_id: a[0], geoname_id: a[1], language: a[2], label: a[3], priority: a[4]) }
      end
    end
  end
end
