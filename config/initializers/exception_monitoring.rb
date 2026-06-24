if Rails.env.production?
  Rails.application.config.middleware.use ExceptionNotification::Rack,
    email: {
      email_prefix: "[#{I18n.t("application.name")}-#{Rails.env}] ",
      sender_address: %("#{I18n.t("application.name")} Exception" <execption_notification@murb.nl>),
      exception_recipients: ["#{"#{I18n.t("application.name")}-#{Rails.env}".parameterize}@murb.nl"]
    }
end
