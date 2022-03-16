# frozen_string_literal: true

json.data do
  json.array!(@time_spans) do |time_span|
    json.partial! 'time_span', locals: {time_span: time_span}
  end
end