class ArtistInvolvement < ApplicationRecord
  belongs_to :artist
  belongs_to :involvement

  accepts_nested_attributes_for :involvement

  validates_presence_of :involvement_type

  scope :educational, -> {where(involvement_type: :educational)}
  scope :professional, -> {where(involvement_type: :professional)}

end
