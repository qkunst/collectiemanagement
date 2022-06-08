# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  helper ApplicationHelper
  default from: Rails.application.secrets.from_address || "collectiemanagement@qkunst.nl"
  layout "mailer"
end
