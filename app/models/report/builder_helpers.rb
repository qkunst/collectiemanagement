# frozen_string_literal: true

module Report
  module BuilderHelpers
    def basic_aggregation_snippet key, postfix = "", field = nil, missing = nil
      rv = {
        key.to_sym => {
          terms: {
            field: field || "#{key}#{postfix}", size: 999
          }
        }
      }
      rv[key.to_sym][:terms][:missing] = missing if missing
      rv
    end

    def basic_aggregation_snippet_with_missing key, postfix = "", field = nil
      rv = basic_aggregation_snippet(key, postfix, field)
      rv[:"#{key}_missing"] = {
        missing: {
          field: field || "#{key}#{postfix}"
        }
      }
      rv
    end
  end
end
