# frozen_string_literal: true

json.array!(@collections) do |collection|
  json.id collection.id
  json.name collection.name
  json.parent_collection_id collection.parent_collection_id unless collection.parent_collection.root
end