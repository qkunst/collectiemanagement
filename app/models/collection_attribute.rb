# frozen_string_literal: true

# == Schema Information
#
# Table name: collection_attributes
#
#  id               :bigint           not null, primary key
#  attributed_type  :string
#  label            :string
#  value_ciphertext :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  attributed_id    :string
#  collection_id    :bigint
#
class CollectionAttribute < ApplicationRecord
  has_encrypted :value
  belongs_to :collection
  belongs_to :attributed, polymorphic: true

  validates_uniqueness_of :label, scope: [:collection_id, :attributed_id, :attributed_type]
  validates_presence_of :label, :value, :collection, :attributed

  scope :for_collection, ->(collections) { where(collection: collections.is_a?(Collection) ? collections.expand_with_child_collections : collections) }
  scope :for_user, ->(user) { for_collection(user.accessible_collections) }
  scope :description, -> { where(label: ["Beschrijving", "description", "beschrijving"])}

  def collection= collection
    self.collection_id = collection.base_collection.id
  end
end
