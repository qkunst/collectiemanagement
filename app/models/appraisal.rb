# frozen_string_literal: true

class Appraisal < ApplicationRecord

  MARKET_VALUE_CATEGORIES =      [0..50, 50..100, 100..200, 200..300, 300..500, 500..1_000, 1_000..2_500, 2_500..5_000, 5_000..7_500, 7_500..10_000, 10_000..15_000, 15_000..20_000, 20_000..50_000, 50_000..100_000, 100_000..200_000, 200_000..500_000, 500_000..1_000_000]
  REPLACEMENT_VALUE_CATEGORIES = [0..50, 50..100, 100..250, 250..500, 500..750, 750..1_000, 1_000..2_500, 2_500..5_000, 5_000..7_500, 7_500..10_000, 10_000..15_000, 15_000..20_000, 20_000..25_000, 25_000..30_000, 30_000..40_000, 40_000..50_000, 50_000..75_000, 75_000..100_000, 100_000..200_000, 200_000..300_000, 300_000..400_000, 400_000..500_000, 500_000..750_000, 750_000..1_000_000]

  belongs_to :work
  belongs_to :user, optional: true

  after_destroy :update_work_appraisal_data!
  after_save :update_work_appraisal_data!

  validates_presence_of :appraised_on

  include ActionView::Helpers::NumberHelper

  has_paper_trail

  attribute :replacement_value_range
  attribute :market_value_range

  accepts_nested_attributes_for :work

  scope :descending_appraisal_on, -> { order(Arel.sql("appraisals.appraised_on is null, appraisals.appraised_on desc, appraisals.id desc")) }

  def market_value_range= range
    case range
    when Range, Array
      self.market_value_min = range.min
      self.market_value_max = range.max
    when String
      self.market_value_min, self.market_value_max = range.split("..").map(&:to_i)
    end
  end

  def market_value_range
    (market_value_min..market_value_max) if market_value_min && market_value_max
  end

  def replacement_value_range= range
    case range
    when Range, Array
      self.replacement_value_min = range.min
      self.replacement_value_max = range.max
    when String
      self.replacement_value_min, self.replacement_value_max = range.split("..").map(&:to_i)
    end
  end

  def replacement_value_range
    (replacement_value_min..replacement_value_max) if replacement_value_min && replacement_value_max
  end

  def update_work_appraisal_data!
    work&.update_latest_appraisal_data!
  end

  def name
    mw = market_value ? "MW #{number_to_currency(market_value)}" : nil
    vw = replacement_value ? "VW #{number_to_currency(replacement_value)}" : nil
    "#{appraised_on ? I18n.l(appraised_on) : "onbekende datum"} (by #{appraised_by}): #{[mw, vw].compact.join("; ")}"
  end
end
