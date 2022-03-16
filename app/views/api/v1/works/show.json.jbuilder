# frozen_string_literal: true

json.data do
  json.partial! 'work', locals: {work: @work}
end