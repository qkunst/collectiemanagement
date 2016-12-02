json.array!(@techniques) do |technique|
  json.extract! technique, :id, :name
  json.url technique_url(technique, format: :json)
end
