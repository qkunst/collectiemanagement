# frozen_string_literal: true

module Works::PdfResponse
  extend ActiveSupport::Concern

  included do
    def show_pdf_response
      if Collection::HtmlRendererWorker.perform_async(@collection.id, current_user.id, params.to_json, {generate_pdf: true, send_message: true})
        redirect_to collection_works_path(@collection, @cleaned_params.merge(format: :html)), notice: "De PDF wordt voorbereid. U krijgt een bericht (vanuit de berichtenmodule) wanneer deze gereed is."
      else
        redirect_to collection_works_path(@collection, @cleaned_params.merge(format: :html)), alert: "Er ging iets mis bij het genereren van de PDF, probeer het later nog eens"
      end
    end
  end
end
