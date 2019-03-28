# frozen_string_literal: true

class AddFinishedUploadingToBatchPhotoUploads < ActiveRecord::Migration[4.2]
  def change
    add_column :batch_photo_uploads, :finished_uploading, :boolean, default: false
  end
end
