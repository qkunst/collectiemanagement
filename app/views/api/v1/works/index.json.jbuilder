# frozen_string_literal: true

json.meta do
  json.count @works.count
  json.total_count @works_count
end
json.data do
  json.array!(@works) do |work|
    json.partial! 'work', locals: {work: work}
  end
end
