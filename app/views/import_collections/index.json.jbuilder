# frozen_string_literal: true

json.array!(@import_collections) do |import_collection|
  json.extract! import_collection, :id, :collection_id, :file, :settings
  json.url import_collection_url(import_collection, format: :json)
end
