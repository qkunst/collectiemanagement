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
        parse_bucket elastic_aggragations
      end
    end
  end
end
