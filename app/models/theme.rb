# frozen_string_literal: true

class Theme < ApplicationRecord
  include NameId, Hidable, CollectionOwnable

  has_and_belongs_to_many :works

end
