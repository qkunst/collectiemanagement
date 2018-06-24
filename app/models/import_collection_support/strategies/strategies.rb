module ImportCollectionSupport::Strategies
  class Strategies
    class << self
      def strategies
        self.methods - Class.methods - [:strategies]
      end
    end
  end
end