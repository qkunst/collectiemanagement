class Involvement < ActiveRecord::Base
  scope :educational, -> {where(type: :educational)}
  scope :professional, -> {where(type: :professional)}
end
