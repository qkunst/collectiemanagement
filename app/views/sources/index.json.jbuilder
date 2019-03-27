# frozen_string_literal: true

json.array!(@sources) do |source|
  json.extract! source, :id, :name
  json.url source_url(source, format: :json)
end
