# frozen_string_literal: true

json.array!(@involvements) do |involvement|
  json.extract! involvement, :id, :name, :city, :country, :type
  json.url involvement_url(involvement, format: :json)
end
