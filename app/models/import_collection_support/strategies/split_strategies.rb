module ImportCollectionSupport::Strategies
  class SplitStrategies < Strategies
    class << self
      def split_nothing field
        [field]
      end
      def split_space field
        field.to_s.split(/[\s\n]/).collect{|a| a.strip == "" ? nil : a.strip}.compact
      end
      def split_comma field
        field.to_s.split(/\,|\;/).collect{|a| a.strip == "" ? nil : a.strip}.compact
      end
      def split_natural field
        field.to_s.split(/\sen\s|\,|\;/).collect{|a| a.strip == "" ? nil : a.strip}.compact
      end
      def split_cross field
        field.to_s.split(/[x\*]/i).collect{|a| a.strip == "" ? nil : a.strip}.compact
      end
      def find_keywords field
        [:find_keywords, field]
      end
    end
  end
end