json.extract! attachment, :id, :name, :attache_id, :file, :visibility, :created_at, :updated_at
json.url attachment_url(attachment, format: :json)