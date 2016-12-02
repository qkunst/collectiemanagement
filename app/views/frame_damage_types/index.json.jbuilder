json.array!(@frame_damage_types) do |frame_damage_type|
  json.extract! frame_damage_type, :id, :name
  json.url frame_damage_type_url(frame_damage_type, format: :json)
end
