class Involvement < ApplicationRecord
  scope :educational, -> {where(type: :educational)}
  scope :professional, -> {where(type: :professional)}
end
