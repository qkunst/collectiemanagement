# frozen_string_literal: true

json.array!(@media) do |medium|
  json.extract! medium, :id, :name
  json.url medium_url(medium, format: :json)
end
