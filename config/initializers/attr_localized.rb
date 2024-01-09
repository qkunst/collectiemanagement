# frozen_string_literal: true

class ActiveRecord::Base
  def self.attr_localized(*fields)
    delimiter = I18n.t("number.format.delimiter")
    separator = I18n.t("number.format.separator")

    fields.each do |field|
      define_method(:"#{field}=") do |value|
        self[field] = if value.is_a?(String)
          value.gsub(Regexp.new("(\\#{delimiter}(\\d\\d\\d))"), '\2').sub(separator, ".")
        else
          value
        end
      end
    end
  end
end
