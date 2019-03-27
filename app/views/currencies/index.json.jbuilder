# frozen_string_literal: true

json.array!(@currencies) do |currency|
  json.extract! currency, :id, :iso_4217_code, :symbol
  json.url currency_url(currency, format: :json)
end
