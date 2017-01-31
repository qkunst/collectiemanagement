class ApplicationRecord < ActiveRecord::Base
  include ActAsTimeAsBoolean
  self.abstract_class = true
end