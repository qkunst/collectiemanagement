class FrameDamageType < ApplicationRecord
  scope :not_hidden, ->{where(hide:[nil,false])}

  include NameId
end
