class Organisation < ApplicationRecord
  belongs_to :auth_provider, optional: true
end
