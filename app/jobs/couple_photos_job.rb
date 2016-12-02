class CouplePhotosJob < ActiveJob::Base
  queue_as :default

  def perform(batch_photo_upload)
    batch_photo_upload.couple!
  end
end
