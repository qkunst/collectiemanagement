json.extract! stage, :id, :name, :actual_stage_id, :previous_stage_id, :created_at, :updated_at
json.url stage_url(stage, format: :json)