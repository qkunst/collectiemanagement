class ActiveRecord::Base
  def self.attr_localized(*fields)
    delimiter = I18n::t('number.format.delimiter')
    separator = I18n::t('number.format.separator')

    fields.each do |field|
      define_method("#{field}=") do |value|
        if value.is_a?(String)
          self[field] = value.gsub(Regexp.new("(\\#{delimiter}(\\d\\d\\d))"), '\2').sub(separator,".")
        else
          self[field] = value
        end
      end
    end
  end
end