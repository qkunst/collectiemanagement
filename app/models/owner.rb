# frozen_string_literal: true

class Owner < ApplicationRecord
  include CollectionOwnable
  include Hidable
  include NameId

  has_many :works
  belongs_to :collection, optional: false
end
