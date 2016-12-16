class Currency < ApplicationRecord
  before_save :set_name!
  def set_name!
    self.name = "#{iso_4217_code} (#{symbol})"
  end
  include NameId
end
