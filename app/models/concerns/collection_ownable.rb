# frozen_string_literal: true

module CollectionOwnable
  extend ActiveSupport::Concern

  included do
    belongs_to :collection, optional: true

    if self.column_names.include? "name"
      validates_presence_of :name
      validates_uniqueness_of :name, scope: :collection_id
    end

    scope :general, -> {where(collection_id: nil)}
    scope :collection_specific, -> {where.not(collection_id: nil)}
    scope :for_collection_including_generic, ->(collection){where(collection_id: collection.id_plus_parent_ids+[nil])}
    scope :for_collection, ->(collection){where(collection_id: collection.id_plus_parent_ids)}
  end
end
