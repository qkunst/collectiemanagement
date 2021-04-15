# frozen_string_literal: true

class CollectionAttribute < ApplicationRecord
  encrypts :value
  belongs_to :collection
  belongs_to :attributed, polymorphic: true

  validates_uniqueness_of :label, scope: [:collection_id, :attributed_id, :attributed_type]
  validates_presence_of :label, :value, :collection, :attributed

  scope :for_collection, ->(collections){ where(collection: collections) }
  scope :for_user, ->(user) { for_collection(user.accessible_collections) }

  def collection= collection
    self.collection_id= collection.base_collection.id
  end

end
