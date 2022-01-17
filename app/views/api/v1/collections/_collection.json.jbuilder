json.id collection.id
json.name collection.name
json.child_collections do
  collection.child_collections.map do |child_collection|
    json.partial! 'collection', locals: {collection: child_collection}
  end
end