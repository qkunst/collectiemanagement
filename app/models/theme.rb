class Theme < ActiveRecord::Base
  belongs_to :collection

  scope :general, -> {where("themes.collection_id IS NULL")}
  scope :not_hidden, -> {where(hide: [nil,false])}
  scope :show_hidden, ->(show_h){ where(hide: (show_h ? [true] : [false,nil])) }

  default_scope ->{order(:name)}

  include NameId
end
