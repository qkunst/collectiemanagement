# frozen_string_literal: true

json.data do
  json.array!(@collections) do |collection|
    json.id collection.id
    json.name collection.name
    json.name_extended collection.cached_collection_name_extended
    json.parent_collection_id collection.parent_collection_id
    if json.parent_collection && !collection.parent_collection.root?
      json.parent_collection_id collection.parent_collection_id
    end
  end
end
