# frozen_string_literal: true

json.array!(@artists) do |artist|
  json.extract! artist, :id, :name, :place_of_birth, :place_of_death, :year_of_birth, :year_of_birth
  json.url artist_url(artist, format: :json)
end
