# frozen_string_literal: true

module Works::XlsxResponse
  extend ActiveSupport::Concern

  included do
    include ActionController::Streaming

    def show_xlsx_response
      send_data prepare_workbook.stream_xlsx, :filename => "werken #{@collection.name}.xlsx"
    end

    def show_csv_response
      send_data prepare_workbook.sheet.table.to_csv, :filename => "werken #{@collection.name}.csv"
    end

    private

    def prepare_workbook
      if can?(:download_datadump, @collection)
        audience = params[:audience] ? params[:audience].to_s.to_sym : :default
        fields_to_expose = @collection.fields_to_expose(audience)
        fields_to_expose = fields_to_expose - ["internal_comments"] unless current_user.qkunst?
        @works = @works.audience(audience).preload_relations_for_display(:complete)
        @works.to_workbook(fields_to_expose, @collection)
      else
        redirect_to collection_path(@collection), alert: 'U heeft onvoldoende rechten om te kunnen downloaden'
      end
    end
  end
end
