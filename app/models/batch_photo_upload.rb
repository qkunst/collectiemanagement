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
    self.images.each do |image|
      if image.file.exists?
        work = image.work
        if work
          attribute = image.image_type
          work.send("#{attribute}=".to_sym, image.file)
          work.save
        end
      else
        # p "Image #{image.filename} bestaat niet (meer)..."
      end
    end
  end

  def recreate_versions!
    images.each{|img| img.recreate_versions!(:big_thumb)}
  end

  def short_name
    date = I18n.l(self.created_at, format: :short)
    "Upload van #{date}, #{images.count} foto's"
  end

  def name
    date = I18n.l(self.created_at, format: :short)
    "Upload van #{date}, #{images.count} foto's (#{image_names})"
  end

  def image_names
    "#{images[0..9].collect(&:filename).to_sentence}#{images.count>10 ? '...': ''}"
  end

  def image_directory
    path = images.first.path
    directory = self.images.first.path.gsub(self.images.first.filename,'')
    directory = Dir.new(directory)
  end

  def unmatched_files
    image_directory.collect{|a| a unless a.starts_with?("big_thumb_") or a == "." or a == ".."}.compact
  end

  def column_values
    return @column_values if @column_values
    self.column ||= :stock_number
    values = {}
    collection.works_including_child_works.select(column.to_sym, :id).each{|a| values[a.send(column.to_sym)]=a.id }
    @column_values = values
  end

  def schedule_process_images!
    self.update_attributes(finished_uploading: true) if self.finished_uploading == false
    ParsePhotosJob.perform_later(self)
  end

end
