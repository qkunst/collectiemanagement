class Theme < ApplicationRecord
  belongs_to :collection, optional: true

  scope :general, -> {where("themes.collection_id IS NULL")}
  scope :not_hidden, -> {where(hide: [nil,false])}
  scope :show_hidden, ->(show_h){ where(hide: (show_h ? [true] : [false,nil])) }

  include NameId
end
