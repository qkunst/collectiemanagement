# frozen_string_literal: true

json.array!(@batch_photo_uploads) do |batch_photo_upload|
  json.extract! batch_photo_upload, :id, :zip_file, :images, :collection_id, :settings
  json.url batch_photo_upload_url(batch_photo_upload, format: :json)
end
