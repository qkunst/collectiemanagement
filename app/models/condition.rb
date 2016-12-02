class Condition < ActiveRecord::Base
  scope :not_hidden, ->{where(hide:[nil,false])}
  default_scope ->{order(:order)}

  include NameId

  class << self
    def find_by_name name
      if name.is_a? String and name.length > 3
        self.all.select{|a| a.name.downcase.match(name.downcase)}.first
      end
    end
  end
end
