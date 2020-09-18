# frozen_string_literal: true

module Works::XmlResponse
  extend ActiveSupport::Concern

  included do
    include ActionController::Streaming

    def show_xml_response
      prepare_data
    end

    private

    def prepare_data
      if can?(:download_datadump, @collection)
        audience = params[:audience] ? params[:audience].to_s.to_sym : :default
        @fields_to_expose = @collection.fields_to_expose(audience)
        @fields_to_expose -= ["internal_comments"] unless current_user.qkunst?
        @works = @works.audience(audience).preload_relations_for_display(:complete)
      else
        redirect_to collection_path(@collection), alert: "U heeft onvoldoende rechten om te kunnen downloaden"
      end
    end
  end
end
