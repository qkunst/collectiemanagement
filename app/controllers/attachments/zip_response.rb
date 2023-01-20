# frozen_string_literal: true

module Attachments::ZipResponse
  extend ActiveSupport::Concern

  included do
    include ZipTricks::RailsStreaming

    def attachments_zip_response
      if can?(:download_attachments, @collection)
        zip_filename = "bijlagen #{@collection.name}.zip"
        headers["Content-Disposition"] = "attachment; filename=\"#{zip_filename}\""

        file_names = {}
        files = []

        @attachments.each do |attachment|
          file_name = attachment.export_file_name

          if file_names.key?(file_name)
            file_parts = file_name.split(".")
            file_extension = file_parts.pop
            file_base = file_parts.join(".")

            file_names[file_name] += 1

            file_name = "#{file_base} (#{file_names[file_name]}).#{file_extension}"
          else
            file_names[file_name] = 1
          end

          files << [attachment.file.path, file_name]

          attachment.artists.each do |artist|
            files << [attachment.file.path, "artists/#{artist.base_file_name}/#{file_name}"]
          end

          attachment.works.each do |work|
            files << [attachment.file.path, "works/#{work.base_file_name}/#{file_name}"]
          end
        end

        zip_tricks_stream do |zip|
          files.lazy.each do |file|
            zip.write_stored_file(file[1]) do |sink|
              sink << File.binread(file[0])
            end
          end
        end

      else
        redirect_to collection_path(@collection), alert: "U heeft onvoldoende rechten om te kunnen downloaden"
      end
    end
  end
end
