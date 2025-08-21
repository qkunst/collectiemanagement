# frozen_string_literal: true

module Report
  module BuilderHelpers
    def basic_aggregation_snippet key, postfix: "", field: nil, size: 999, aggregation: nil, include_missing: false, &block
      rv = {
        key.to_sym => {
          terms: {
            field: field || "#{key}#{postfix}", size:
          }
        }
      }
      if include_missing
        rv[:"#{key}_missing"] = {
          missing: {
            field: field || "#{key}#{postfix}"
          }
        }
      end
      rv[key.to_sym][:aggs] = aggregation if aggregation
      if block
        rv[key.to_sym][:aggs] = block.call
      end
      rv
    end

    def missing_only_aggregation_snippet key, field: nil, aggregation: nil, &block
      rv = {
        key.to_sym => {
          missing: {
            field: field || "#{key}#{postfix}"
          }
        }
      }
      rv[key.to_sym][:aggs] = aggregation if aggregation
      if block
        rv[key.to_sym][:aggs] = block.call
      end
      rv
    end
  end
end
