# frozen_string_literal: true

class ParsePhotosWorker
  include Sidekiq::Worker

  sidekiq_options retry: true, backtrace: true, queue: :qkunst_default

  def perform(batch_photo_upload_id)
    batch_photo_upload = BatchPhotoUpload.find_by_id(batch_photo_upload_id)
    batch_photo_upload&.recreate_versions!
  end
end
