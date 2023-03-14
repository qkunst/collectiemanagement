# frozen_string_literal: true

class PdfPrinterWorker
  include Sidekiq::Worker

  attr_reader :options
  attr_reader :url

  sidekiq_options retry: true, backtrace: true, queue: :qkunst_quick

  def perform(url, options = {})
    inform_user_id = options[:inform_user_id] || options["inform_user_id"]
    subject_object_id = options[:subject_object_id] || options["subject_object_id"]
    subject_object_type = options[:subject_object_type] || options["subject_object_type"]

    filename = Pupprb::Pdf.write url

    # setting for debugging purposes
    @url = url
    @options = options

    if inform_user_id
      Message.create(to_user_id: inform_user_id, subject_object_id: subject_object_id, subject_object_type: subject_object_type, from_user_name: "Download voorbereider", attachment: File.open(filename), message: "De download is gereed, open het bericht in je browser om de bijlage te downloaden.\n\nFormaat: PDF", subject: "PDF gereed")
    end

    filename
  end
end
