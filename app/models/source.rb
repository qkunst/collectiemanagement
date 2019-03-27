# frozen_string_literal: true

class Source < ApplicationRecord
  scope :not_hidden, ->{where(hide:[nil,false])}
  include NameId
end
