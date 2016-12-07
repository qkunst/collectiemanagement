class GeonameTranslation < ApplicationRecord
  scope :locale, ->(language_code){ where(language: language_code)}
end
