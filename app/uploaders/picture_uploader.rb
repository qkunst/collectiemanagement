# frozen_string_literal: true

class PictureUploader < CarrierWave::Uploader::Base
  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick
  include CarrierWave::ImageOptimizer
  include SecureUploadFilename

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

  convert :jpg
  process optimize: [{quality: 80}]

  # Create different versions of your uploaded files:
  version :thumb do
    convert :jpg
    process resize_to_fit: [100, 100]
    process optimize: [{quality: 50}]
  end
  version :big_thumb do
    convert :jpg
    process resize_to_fit: [250, 250]
    process optimize: [{quality: 60}]
  end
  version :screen do
    convert :jpg
    process resize_to_fit: [1024, 1024]
    process optimize: [{quality: 70}]
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w[jpg jpeg gif png heic]
  end

  def to_be_path version = nil
    this_store_path = store_path.gsub(file.filename, "")
    this_store_path + [version, file.filename].compact.join("_")
  end
end
