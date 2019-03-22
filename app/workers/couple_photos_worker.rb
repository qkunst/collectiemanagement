class CouplePhotosWorker
  include Sidekiq::Worker

  sidekiq_options retry: false, backtrace: true, queue: :qkunst_default

  def perform(batch_photo_upload_id)
    batch_photo_upload = BatchPhotoUpload.find_by_id(batch_photo_upload_id)
    batch_photo_upload.couple! if batch_photo_upload
  end
end
