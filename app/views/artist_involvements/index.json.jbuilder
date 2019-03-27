# frozen_string_literal: true

json.array!(@artist_involvements) do |artist_involvement|
  json.extract! artist_involvement, :id, :involvement_id, :artist_id, :start_year, :end_year
  json.url artist_involvement_url(artist_involvement, format: :json)
end
