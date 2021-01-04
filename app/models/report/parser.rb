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

      def parse elastic_aggragations, base_report: false
        self.base_report = base_report
        parse_bucket elastic_aggragations
      end
    end
  end
end
