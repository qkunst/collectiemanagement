class Appraisal < ApplicationRecord
  belongs_to :work
  belongs_to :user

  validates_presence_of :appraised_on

  include ActionView::Helpers::NumberHelper

  scope :descending_appraisal_on, -> { order("appraisals.appraised_on is null, appraisals.appraised_on desc") }

  def name
    mw = market_value ? "MW #{number_to_currency(market_value)}" : nil
    vw = replacement_value ? "VW #{number_to_currency(replacement_value)}" : nil
    "#{appraised_on ? I18n.l(appraised_on) : 'onbekende datum'} (by #{appraised_by}): #{[mw,vw].compact.join("; ")}"
  end
end
