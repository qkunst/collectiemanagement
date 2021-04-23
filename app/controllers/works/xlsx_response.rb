# frozen_string_literal: true

module Works::XlsxResponse
  extend ActiveSupport::Concern

  included do
    include ActionController::Streaming

    def show_xlsx_response
      if direct_download?
        send_data prepare_workbook.stream_xlsx, filename: "werken #{@collection.name}.xlsx"
      elsif Collection::DownloadWorker.perform_async(download_parameters[:collection_id], download_parameters[:requested_by_user_id], :xlsx, download_parameters[:audience], download_parameters[:fields_to_expose])
        redirect_to collection_works_path(@collection, @cleaned_params.merge(format: :html)), notice: "De download wordt voorbereid. U krijgt een bericht (vanuit de berichtenmodule) wanneer de download gereed is."
      else
        redirect_to collection_works_path(@collection, @cleaned_params.merge(format: :html)), alert: "Er ging iets mis bij het genereren van de download, probeer het later nog eens"
      end
    end

    def show_csv_response
      if direct_download?
        send_data prepare_workbook.sheet.table.to_csv, filename: "werken #{@collection.name}.csv"
      elsif Collection::DownloadWorker.perform_async(download_parameters[:collection_id], download_parameters[:requested_by_user_id], :csv, download_parameters[:audience], download_parameters[:fields_to_expose])
        redirect_to collection_works_path(@collection, @cleaned_params.merge(format: :html)), notice: "De download wordt voorbereid. U krijgt een bericht (vanuit de berichtenmodule) wanneer de download gereed is."
      else
        redirect_to collection_works_path(@collection, @cleaned_params.merge(format: :html)), alert: "Er ging iets mis bij het genereren van de download, probeer het later nog eens"
      end
    end

    private

    def direct_download?
      @works.count < 500 || @collection_works_count > @works_count
    end

    def download_parameters
      audience = params[:audience] ? params[:audience].to_s.to_sym : :default
      fields_to_expose = @collection.fields_to_expose(audience)
      fields_to_expose -= ["internal_comments"] unless current_user.qkunst?

      {collection_id: @collection.id, audience: audience, fields_to_expose: fields_to_expose, requested_by_user_id: current_user.id}
    end

    def prepare_workbook
      if can?(:download_datadump, @collection)
        @works = @works.audience(download_parameters[:audience]).preload_relations_for_display(:complete)
        @works.to_workbook(download_parameters[:fields_to_expose], @collection)
      else
        redirect_to collection_path(@collection), alert: "U heeft onvoldoende rechten om te kunnen downloaden"
      end
    end
  end
end
