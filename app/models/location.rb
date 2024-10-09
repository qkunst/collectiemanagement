# == Schema Information
#
# Table name: locations
#
#  id                    :bigint           not null, primary key
#  address               :text
#  building_number       :string
#  hide                  :boolean
#  lat                   :float
#  lon                   :float
#  name                  :string
#  other_structured_data :text
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  collection_id         :integer
#
class Location < ApplicationRecord
  include Hidable

  NAME_SPLITTER = /[,-]/
  belongs_to :collection

  validates_presence_of :name
  has_many :works, foreign_key: :main_location_id
  store :other_structured_data

  after_save :update_works!

  class << self
    def find_or_create_by_name_and_collection(name, collection)
      search_location = new(name: name, collection: collection)
      find_or_create_by(search_location.attributes.except("id", "created_at", "updated_at"))
    end
  end

  def collection= collection
    self.collection_id = collection.super_base_collection.id
  end

  def name= name
    return if name.blank?
    name_split = name.split(NAME_SPLITTER)
    if name_split.size > 1 && !persisted?
      super(name_split[0].strip)
      self.address = name_split[1...].map(&:strip).join("\n").strip
    else
      super(name.strip)
    end
  end

  private

  def update_works!
    works.update_all(location: name, updated_at: Time.now, significantly_updated_at: Time.now)
  end
end
