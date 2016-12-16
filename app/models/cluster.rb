class Cluster < ApplicationRecord
  has_many :works
  belongs_to :collection

  include NameId
end
