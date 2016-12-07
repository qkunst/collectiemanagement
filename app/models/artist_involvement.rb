class ArtistInvolvement < ApplicationRecord
  belongs_to :artist
  belongs_to :involvement
  accepts_nested_attributes_for :involvement

end
