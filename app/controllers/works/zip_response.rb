# frozen_string_literal: true

module Works::ZipResponse
  extend ActiveSupport::Concern

  included do
    include ZipKit::RailsStreaming

    def show_zip_response
      if can?(:download_photos, @collection)
        zip_filename = "werken #{@collection.name}.zip"
        headers["Content-Disposition"] = "attachment; filename=\"#{zip_filename}\""

        only_front = params[:only_front]
        filenames = []
        files = []
        file_editions = only_front ? ["photo_front"] : ["photo_front", "photo_back", "photo_detail_1", "photo_detail_2"]
        @works.each do |work|
          base_file_name = work.base_file_name
          file_editions.each do |field|
            if work.send(:"#{field}?")
              filename_components = [base_file_name]
              filename_components << field.gsub("photo_", "") unless only_front
              filename = "#{filename_components.join("_")}.jpg"
              if filenames.include? filename
                filename = filename.sub(".jpg", "nameclash-#{SecureRandom.uuid}.jpg")
              end
              filenames << filename
              file = work.send(field.to_sym)
              file_path = params[:hq] ? file.path : file.screen.path
              files << [file_path, filename]
            end
          end
        end
        zip_kit_stream do |zip|
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
