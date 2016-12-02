class GeonameTranslation < ActiveRecord::Base
  scope :locale, ->(language_code){ where(language: language_code)}
end
