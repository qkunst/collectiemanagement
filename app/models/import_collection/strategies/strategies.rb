# frozen_string_literal: true

module ImportCollection::Strategies
  class Strategies
    class << self
      def strategies
        self.methods - Class.methods - [:strategies]
      end
    end
  end
end
