# frozen_string_literal: true

module SecureUploadFilename
  extend ActiveSupport::Concern

  included do
    # Override the filename of the uploaded files:
    # Avoid using model.id or version_name here, see uploader/store.rb for details.
    # Override the filename of the uploaded files:
    # Avoid using model.id or version_name here, see uploader/store.rb for details.
    def filename
      if original_filename
        if model && model.read_attribute(mounted_as).present?
          model.read_attribute(mounted_as)
        elsif original_filename.present?
          extension = file.extension.presence || file.content_type.split("/").last
          "#{secure_token}.#{extension}"
        end
      end
    end

    protected

    def secure_token
      var = :"@#{mounted_as}_secure_token"
      model.instance_variable_get(var) || model.instance_variable_set(var, SecureRandom.uuid)
    end
  end
end
