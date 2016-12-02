class CreateBatchPhotoUploads < ActiveRecord::Migration
  def change
    create_table :batch_photo_uploads do |t|
      t.string :zip_file
      t.json :images
      t.integer :collection_id
      t.json :settings
    end
  end
end
