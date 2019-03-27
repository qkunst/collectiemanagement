# frozen_string_literal: true

json.array!(@object_categories) do |object_category|
  json.extract! object_category, :id, :name
  json.url object_category_url(object_category, format: :json)
end
