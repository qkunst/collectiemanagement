json.status time_span.status
json.contact_url time_span.contact&.url
json.subject_id time_span.subject_id
json.subject_type time_span.subject_type
unless defined?(work_context) && work_context
  json.subject do
    if time_span.subject_type == "Work"
      json.partial! 'api/v1/works/work_limited', locals: {work: time_span.subject}
    end
  end
end
json.starts_at time_span.starts_at
json.ends_at time_span.ends_at
json.classification time_span.classification
