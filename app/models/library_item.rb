# frozen_string_literal: true

# == Schema Information
#
# Table name: library_items
#
#  id            :bigint           not null, primary key
#  author        :string
#  description   :text
#  ean           :string
#  item_type     :string
#  location      :string
#  stock_number  :string
#  thumbnail     :string
#  title         :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  collection_id :bigint
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
