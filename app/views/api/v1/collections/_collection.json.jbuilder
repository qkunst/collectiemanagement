json.id collection.id
json.name collection.name
json.name_extended collection.cached_collection_name_extended
json.parent_collection_id collection.parent_collection_id
json.child_collections do
  collection.child_collections.map do |child_collection|
    json.partial! "collection", locals: {collection: child_collection}
  end
end
