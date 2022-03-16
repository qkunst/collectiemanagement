# frozen_string_literal: true

json.data do
  json.partial! 'time_span', locals: {time_span: @time_span}
end