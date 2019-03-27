# frozen_string_literal: true

json.array!(@placeabilities) do |placeability|
  json.extract! placeability, :id, :name, :order, :hide
  json.url placeability_url(placeability, format: :json)
end
