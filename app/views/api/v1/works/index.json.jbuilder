# frozen_string_literal: true

json.array!(@works) do |work|
  json.partial! 'work', locals: {work: work}
end
