class Theme < ApplicationRecord
  belongs_to :collection, optional: true

  scope :general, -> {where("themes.collection_id IS NULL")}

  include NameId, Hidable
end
