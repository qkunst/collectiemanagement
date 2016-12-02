class AddCreatedAtAndUpdatedAtToBatchPhotoUploads < ActiveRecord::Migration
  def change
    add_column :batch_photo_uploads, :created_at, :datetime
    add_column :batch_photo_uploads, :updated_at, :datetime
  end
end
