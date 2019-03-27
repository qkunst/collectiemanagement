# frozen_string_literal: true

json.array!(@subsets) do |subset|
  json.extract! subset, :id, :name
  json.url subset_url(subset, format: :json)
end
