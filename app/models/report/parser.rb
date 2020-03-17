# frozen_string_literal: true

module Report
  class Parser
    extend Report::ParserHelpers

    class << self
      def key_model_relations= key_model_relations
        @@key_model_relations = key_model_relations
      end

      def key_model_relations
        @@key_model_relations
      end

      def parse elastic_aggragations
        report = {}
        elastic_aggragations.each do |key, set|
          counts = parse_aggregation(set, key)
          key = key.gsub(/_missing$/, "")
          # key = key.gsub(/.keyword/,"")
          report[key.to_sym] = {} unless report[key.to_sym]
          report[key.to_sym].deep_merge!(counts) if counts
        end
        report
      end
    end
  end
end
