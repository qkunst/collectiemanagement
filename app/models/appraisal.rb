class Appraisal < ApplicationRecord
  belongs_to :work
  belongs_to :user

  include ActionView::Helpers::NumberHelper

  scope :descending_appraisal_on, -> { order("appraisals.appraised_on is null, appraisals.appraised_on desc") }

  def name
    "#{I18n.l appraised_on} (by #{appraised_by}): MW #{number_to_currency(market_value)}; VW #{number_to_currency(replacement_value)}"
  end
end
