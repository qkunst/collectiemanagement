json.data do
  json.uuid @work_set.uuid

  json.works @work_set.works.map do |work|
    json.partial! "api/v1/works/work_limited", locals: {work: work, current_active_time_span: true}
  end
end
