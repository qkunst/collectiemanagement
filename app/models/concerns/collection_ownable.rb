# frozen_string_literal: true

module CollectionOwnable
  extend ActiveSupport::Concern

  included do
    belongs_to :collection, optional: true

    if column_names.include?("name") && column_names.include?("hide")
      validates :name, presence: true
      validates :name, uniqueness: {scope: :collection_id, unless: ->(a) { a.hidden? }}
    elsif column_names.include? "name"
      validates :name, presence: true
      validates :name, uniqueness: {scope: :collection_id}
    end

    scope :general, -> { where(collection_id: nil) }
    scope :collection_specific, -> { where.not(collection_id: nil) }
    scope :for_collection, ->(collection) { where(collection: collection.expand_with_parent_collections) }
    scope :for_collection_including_generic, ->(collection) { for_collection(collection).or(general) }
  end
end
