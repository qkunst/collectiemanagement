# frozen_string_literal: true

json.array!(@conditions) do |condition|
  json.extract! condition, :id, :name
  json.url condition_url(condition, format: :json)
end
