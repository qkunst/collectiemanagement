# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  include ActAsTimeAsBoolean

  strip_attributes

  self.abstract_class = true
end
