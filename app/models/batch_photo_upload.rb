# frozen_string_literal: true

# == Schema Information
#
# Table name: batch_photo_uploads
#
#  id                 :bigint           not null, primary key
#  finished_uploading :boolean          default(FALSE)
#  images             :json
#  settings           :text
#  zip_file           :string
#  created_at         :datetime
#  updated_at         :datetime
#  collection_id      :bigint
#
class BatchPhotoUpload < ApplicationRecord
  # store :images
  store :settings, accessors: [:column]
  mount_uploaders :images, UnsecureTmpBasicPictureUploader
  after_save :schedule_process_images!

  belongs_to :collection

  def process_now?
    finished_uploading
  end

  def couple!
    images.each do |image|
      if image.file_exists? && image.work
        attribute = image.image_type
        work = image.work
        work.send("#{attribute}=".to_sym, image.file)
        work.save
      end
    end
  end

  def recreate_versions!
    images.each { |img| img.recreate_versions!(:big_thumb) }
  end

  def short_name
    date = I18n.l(created_at, format: :short)
    "Upload van #{date}, #{images.count} foto's"
  end

  def name
    date = I18n.l(created_at, format: :short)
    "Upload van #{date}, #{images.count} foto's (#{image_names})"
  end

  def image_names
    "#{images[0..9].collect(&:filename).to_sentence}#{images.count > 10 ? "..." : ""}"
  end

  def image_directory
    directory = images.first.path.gsub(images.first.filename, "")
    Dir.new(directory)
  end

  def unmatched_files
    image_directory.collect { |a| a unless a.starts_with?("big_thumb_") || (a == ".") || (a == "..") }.compact
  end

  def column_values
    return @column_values if @column_values
    self.column ||= :stock_number
    values = {}
    collection.works_including_child_works.select(column.to_sym, :id).each { |a| values[a.send(column.to_sym)] = a.id }
    @column_values = values
  end

  def schedule_process_images!
    update(finished_uploading: true) if finished_uploading == false
    ParsePhotosWorker.perform_async(id)
  end
end
