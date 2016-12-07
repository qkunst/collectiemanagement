class ParsePhotosJob < ApplicationJob
  queue_as :default

  def perform(batch_photo_upload)
    batch_photo_upload.recreate_versions!
  end
end
