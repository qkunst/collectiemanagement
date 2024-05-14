# frozen_string_literal: true

module Work::CustomParameterRendering
  extend ActiveSupport::Concern

  included do
    # custom for single customer; will have to adjust when adding more customers
    def business_rent_price_ex_vat
      if selling_price.nil?
        nil
      elsif selling_price < 500
        7.0
      elsif selling_price < 1500
        12.4
      else
        selling_price / 100.0
      end
    end

    def default_rent_price
      if selling_price.nil?
        nil
      elsif selling_price < 1000
        8.75
      elsif selling_price < 2000
        14.0
      else
        selling_price / 100.0
      end
    end
  end
end
