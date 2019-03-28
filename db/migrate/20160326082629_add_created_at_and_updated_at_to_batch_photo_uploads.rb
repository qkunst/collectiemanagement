# frozen_string_literal: true

class AddCreatedAtAndUpdatedAtToBatchPhotoUploads < ActiveRecord::Migration[4.2]
  def change
    add_column :batch_photo_uploads, :created_at, :datetime
    add_column :batch_photo_uploads, :updated_at, :datetime
  end
end
