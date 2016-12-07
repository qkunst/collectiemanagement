class Currency < ApplicationRecord
  def name
    "#{iso_4217_code} (#{symbol})"
  end
  include NameId

end
