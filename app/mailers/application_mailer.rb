# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  helper ApplicationHelper
  default from: "collectiemanagement@qkunst.nl"
  layout "mailer"
end
