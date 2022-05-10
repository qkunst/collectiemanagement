# frozen_string_literal: true

# == Schema Information
#
# Table name: currencies
#
#  id            :bigint           not null, primary key
#  exchange_rate :decimal(16, 8)
#  hide          :boolean          default(FALSE)
#  iso_4217_code :string
#  name          :string
#  symbol        :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
class Currency < ApplicationRecord
  include NameId
  include Hidable

  before_save :set_name!

  after_save :update_conversions!

  def set_name!
    self.name = "#{iso_4217_code} (#{symbol})"
  end

  def to_eur(amount)
    amount.to_d / exchange_rate
  end

  def update_conversions!
    works.each do |work|
      work.purchase_price_in_eur = to_eur(work.purchase_price) if work.purchase_price_currency_id == id # may now be obviously true, but maybe not for always
      work.save if work.changed?
    end
  end

  def works
    Work.where(purchase_price_currency_id: id)
  end
end
