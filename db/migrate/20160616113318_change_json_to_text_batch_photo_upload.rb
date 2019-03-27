# frozen_string_literal: true

class ChangeJsonToTextBatchPhotoUpload < ActiveRecord::Migration
  def self.up
    change_column :batch_photo_uploads, :settings, :text
  end
  def self.down
    change_column :batch_photo_uploads, :settings, :json

  end
end
