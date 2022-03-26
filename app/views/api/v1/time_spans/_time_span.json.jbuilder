contact = time_span.contact

json.status time_span.status
json.uuid time_span.uuid
json.contact_url contact&.url
json.subject_id time_span.subject_id
json.subject_type time_span.subject_type
unless defined?(work_context) && work_context
  json.subject do
    if time_span.subject_type == "Work"
      json.partial! 'api/v1/works/work_limited', locals: {work: time_span.subject}
    end
  end
end
if contact
  json.contact do
    json.name contact.name
    json.address contact.address
    json.external contact.external
    json.url contact.url
  end
end
json.starts_at time_span.starts_at
json.ends_at time_span.ends_at
json.classification time_span.classification
