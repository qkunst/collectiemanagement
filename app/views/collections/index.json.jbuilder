json.array!(@collections) do |collection|
  json.extract! collection, :id, :name
  json.url collection_url(collection, format: :json)
end
