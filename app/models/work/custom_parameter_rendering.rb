# frozen_string_literal: true

module Work::CustomParameterRendering
  extend ActiveSupport::Concern

  included do
    # custom for single customer; will have to adjust when adding more customers
    def business_rent_price_ex_vat
      if Date.current >= Date.new(2026,5,1)
        if selling_price.nil?
          nil
        elsif selling_price < 500
          8.5
        elsif selling_price < 1500
          14
        else
          (selling_price / 100.0 * 1.1).round(2)
        end
      else
        if selling_price.nil?
          nil
        elsif selling_price < 500
          7.0
        elsif selling_price < 1500
          12.4
        else
          [selling_price / 100.0].min
        end
      end
    end

    def default_rent_price
      if Date.current >= Date.new(2026,7,1)
        if selling_price.nil?
          nil
        elsif selling_price < 1000
          9.5
        elsif selling_price < 2000
          16.0
        elsif selling_price >= 7500
          nil
        else
          [selling_price / 100.0, 40].min
        end
      else
        if selling_price.nil?
          nil
        elsif selling_price < 1000
          8.75
        elsif selling_price < 2000
          14.0
        else
          [selling_price / 100.0, 40].min
        end
      end
    end
  end
end
