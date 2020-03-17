# frozen_string_literal: true

class Condition < ApplicationRecord
  default_scope -> { order(:order) }

  include Hidable
  include NameId

  class << self
    def find_by_name name
      if name.is_a?(String) && (name.length > 3)
        all.select { |a| a.name.downcase.match(name.downcase) }.first
      end
    end
  end
end
