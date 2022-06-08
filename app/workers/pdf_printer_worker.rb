# frozen_string_literal: true

class PdfPrinterWorker
  include Sidekiq::Worker

  attr_reader :options
  attr_reader :url

  sidekiq_options retry: true, backtrace: true, queue: :qkunst_default

  def clean_resource(url)
    # urls are recognized as urls, but local files are not; simple trick that works on unixy systems
    if /\A\/tmp\/[A-Za-z\d.\/]*/.match?(url)
      "file://#{url}"
    elsif /\A#{Rails.root}\/tmp\/[A-Za-z\d.\/]*/.match?(url)
        "file://#{url}"
    elsif url.start_with? File.join(Rails.root, "public")
      "file://#{url}"
    elsif url.start_with? "https://collectiemanagement.qkunst.nl/"
      url
    else
      raise "Unsecure location (#{url})"
    end
  end

  def perform(url, options = {})
    inform_user_id = options[:inform_user_id] || options["inform_user_id"]
    subject_object_id = options[:subject_object_id] || options["subject_object_id"]
    subject_object_type = options[:subject_object_type] || options["subject_object_type"]

    filename = Rails.root.join("tmp/#{SecureRandom.base58(32)}.pdf").to_s

    resource = clean_resource(url)

    # setting for debugging purposes
    @url = url
    @options = options

    command = [File.join(Rails.root, "bin", "puppeteer"), resource, filename]

    env = {}
    env["CHROME_DEVEL_SANDBOX"] = "/usr/local/sbin/chrome-devel-sandbox" if File.exists?("/usr/local/sbin/chrome_sandbox")
    env["CHROME_DEVEL_SANDBOX"] ||= "/usr/local/sbin/chrome_sandbox" if File.exists?("/usr/local/sbin/chrome_sandbox")


    if !system("node --version")
      raise "Node not found. Required."
    end

    Rails.logger.debug("Start creating a pdf using puppeteer, command: #{command.join(' ')}")
    system(env, *command, exception: true)

    if inform_user_id
      Message.create(to_user_id: inform_user_id, subject_object_id: subject_object_id, subject_object_type: subject_object_type, from_user_name: "Download voorbereider", attachment: File.open(filename), message: "De download is gereed, open het bericht in je browser om de bijlage te downloaden.\n\nFormaat: PDF", subject: "PDF gereed")
    end

    filename
  end
end
