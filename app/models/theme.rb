# frozen_string_literal: true

class Theme < ApplicationRecord
  include CollectionOwnable
  include Hidable
  include NameId

  has_and_belongs_to_many :works
end
