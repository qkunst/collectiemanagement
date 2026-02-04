# frozen_string_literal: true

# == Schema Information
#
# Table name: library_items
#
#  id            :integer          not null, primary key
#  item_type     :string
#  collection_id :integer
#  title         :string
#  author        :string
#  ean           :string
#  stock_number  :string
#  location      :string
#  description   :text
#  thumbnail     :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class LibraryItem < ApplicationRecord
  ITEM_TYPES = ["Artikel", "Boek", "DVD"]

  belongs_to :collection

  has_and_belongs_to_many :works
  has_and_belongs_to_many :artists

  mount_uploader :thumbnail, PictureUploader

  # validates_presence_of :item_type
  validates :item_type, inclusion: ITEM_TYPES, presence: true

  def append_works= works
    self.works = Work.where(id: (works.pluck(:id) + self.works.pluck(:id))).distinct
  end

  def append_artists= artists
    self.artists = Artist.where(id: (artists.pluck(:id) + self.artists.pluck(:id))).distinct
  end

  def name
    "#{item_type}: #{title}"
  end
end
