# frozen_string_literal: true

json.extract! frame_type, :id, :name, :hide, :created_at, :updated_at
json.url frame_type_url(frame_type, format: :json)
