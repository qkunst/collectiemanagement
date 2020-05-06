class SystemMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.system_mailer.error_message.subject
  #
  def error_message(error)
    mail to: "qkunst@murb.nl", subject: "#{error.class} fout in QKunst Collectiemanagement", body: error.message
  end
end
