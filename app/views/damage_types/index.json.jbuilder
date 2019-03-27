# frozen_string_literal: true

json.array!(@damage_types) do |damage_type|
  json.extract! damage_type, :id, :name
  json.url damage_type_url(damage_type, format: :json)
end
