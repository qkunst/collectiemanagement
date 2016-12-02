class Placeability < ActiveRecord::Base
  scope :not_hidden, ->{where(hide:[nil,false])}

  include NameId

end
