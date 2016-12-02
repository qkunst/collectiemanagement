# encoding: utf-8

class BasicPictureUploader < CarrierWave::Uploader::Base
  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def move_to_cache
    true
  end
  def move_to_store
    true
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  version :big_thumb, if: :process_now? do
     process :resize_to_fit => [250, 250]
  end

  def process_now?(work)
    self.model.process_now?
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(jpg jpeg gif png)
  end

  attr_accessor :work_id

  def filename
    file.filename
  end

  def work
    work_ids = {}
    model.column_values.each do |key, value|
      downcased_key = key.to_s.downcase
      downcased_filename = filename.to_s.downcase
      if key and downcased_filename.include?(downcased_key)
        work_ids[key] = value
      end
    end
    return_work = work_ids.keys.count == 1 ? Work.where(id:work_ids.values).first : nil
    if return_work == nil and work_ids.keys.count > 1
      work_ids = work_ids.sort{|a,b| a[0].length<=>b[0].length}
      longest_match = work_ids[-1]
      second_longest_match = work_ids[-2]
      if longest_match[0].length > second_longest_match[0].length
        return_work = Work.where(id: longest_match[1]).first
      end
    end
    return_work
  end

  def image_type
    options = {
      "voor" => :photo_front,
      "front" => :photo_front,
      "achter" => :photo_back,
      "back" => :photo_back,
      "detail 1" => :photo_detail_1,
      "detail 2" => :photo_detail_2
      # "detail" => :photo_detail_1
    }

    options.each do | fragment, result |
      return result if filename.include?(fragment)
    end

    return :photo_front

  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  def filename
    if original_filename
      if model && model.read_attribute(mounted_as).present?
        model.read_attribute(mounted_as)
      else
        "#{secure_token}.#{file.extension}" if original_filename.present?
      end
    end
  end

  protected

  def secure_token
    var = :"@#{mounted_as}_secure_token"
    model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.uuid)
  end

end
