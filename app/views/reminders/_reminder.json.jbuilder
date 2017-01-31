json.extract! reminder, :id, :name, :text, :stage_id, :interval_length, :interval_unit, :repeat, :collection_id, :created_at, :updated_at
json.url reminder_url(reminder, format: :json)