module ImportCollectionSupport::Strategies
  class AssignStrategies < Strategies
    class << self
      def replace fields, values
        values.each_with_index{|value,index| update_field(fields[index], value) }
      end
      def append fields, values

      end
      def first_then_join_rest fields, values
        values.each_with_index{|value,index| update_field(fields[index], value) }
      end
      def first_then_join_rest_separated fields, values
        values.each_with_index{|value,index| update_field(fields[index], value) }
      end
    end
  end
end