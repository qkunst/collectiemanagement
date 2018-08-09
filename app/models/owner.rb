class Owner < ApplicationRecord
  has_many :works
  belongs_to :collection, optional: false

  include NameId, Hidable
end
