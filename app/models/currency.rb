class Currency < ActiveRecord::Base
  def name
    "#{iso_4217_code} (#{symbol})"
  end
  include NameId

end
