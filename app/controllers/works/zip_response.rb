module Works::ZipResponse
  extend ActiveSupport::Concern

  included do
    include Zipline
    include ActionController::Streaming

    def show_zip_response
      if can?(:download_photos, @collection)
        only_front = params[:only_front]
        files = []
        file_editions = only_front ? ["photo_front"] : ["photo_front","photo_back","photo_detail_1", "photo_detail_2"]
        @works.each do |work|
          base_file_name = work.base_file_name
          file_editions.each do |field|
            if work.send("#{field}?".to_sym)
              filename_components = [base_file_name]
              filename_components << field.gsub('photo_','') unless only_front
              filename = "#{filename_components.join("_")}.jpg"
              file = work.send(field.to_sym)
              file_path = params[:hq] ? file.path : file.screen.path
              files << [file_path, filename]
            end
          end
        end
        zipline(files.lazy.map{|path, name| [File.open(path), name]}, "werken #{@collection.name}.zip")
      else
        redirect_to collection_path(@collection), alert: 'U heeft onvoldoende rechten om te kunnen downloaden'
      end

    end
  end
end