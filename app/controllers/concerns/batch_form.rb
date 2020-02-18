module BatchForm
  extend ActiveSupport::Concern

  module UpdateStrategies
    IGNORE = [:ignore, :replace, :append]
    REPLACE = nil
    APPEND = nil

    ALL = constants(false) #.map { |c| const_get(c) }.freeze
  end

  class_methods do
    def strategy_attribute_for(field_name)
      "update_#{field_name}_strategy".to_sym
    end

    def strategies_for(field_name)
      strategies = BatchForm::UpdateStrategies::ALL
      if unappendable_fields.include? field_name
        strategies -= [:APPEND]
      end
      if removable_fields.include? field_name
        strategies += [:REMOVE]
      end

      strategies
    end
  end

  included do
    after_initialize :default_to_ignore!

    def default_to_ignore!
      self.class.batch_fields.each do |field_name|
        self.send("#{self.class.strategy_attribute_for(field_name)}=", :IGNORE) if self.send(self.class.strategy_attribute_for(field_name)) == nil
      end
    end

    def object_update_parameters(current_work)
      own_parameters = self.class.batch_fields.map do |field_name|
        new_value = self.send(field_name)
        strategy = self.send(self.class.strategy_attribute_for(field_name))&.to_sym

        if strategy == :IGNORE
          # well ignore :)
        elsif strategy == :REPLACE
          [field_name, new_value]
        elsif strategy == :REMOVE
          current_value = current_work.send(field_name)
          if current_value.nil? || self.class.unappendable_fields.include?(field_name)
            [field_name, nil]
          elsif current_value.is_a? Enumerable
            [field_name, (current_value-new_value).flatten]
          else
            [field_name, current_value.to_s.gsub(new_value.to_s,"")]
          end
        elsif strategy == :APPEND
          current_value = current_work.send(field_name)
          if current_value.nil? || self.class.unappendable_fields.include?(field_name)
            [field_name, new_value]
          elsif current_value.is_a? Enumerable
            [field_name, [current_value,new_value].flatten]
          else
            [field_name, [current_value,new_value].join(" ")]
          end
        end
      end.compact.to_h

      own_parameters
    end

    def not_to_ignore_paramaters
      self.attributes
      @parameters.keys
    end
  end
end