# frozen_string_literal: true

module Works::XlsxResponse
  extend ActiveSupport::Concern

  included do
    include ActionController::Streaming

    def show_xlsx_response
      if can?(:download_datadump, @collection)
        audience = params[:audience] ? params[:audience].to_s.to_sym : :default
        fields_to_expose = @collection.fields_to_expose(audience)
        fields_to_expose = fields_to_expose - ["internal_comments"] unless current_user.qkunst?
        @works = @works.preload_relations_for_display(:complete)
        w = @works.to_workbook(fields_to_expose, @collection)
        send_data w.stream_xlsx, :filename => "werken #{@collection.name}.xlsx"
      else
        redirect_to collection_path(@collection), alert: 'U heeft onvoldoende rechten om te kunnen downloaden'
      end
    end
  end
end
