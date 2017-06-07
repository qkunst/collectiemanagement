class ApplicationMailer < ActionMailer::Base
  helper ApplicationHelper
  default from: "collectiebeheer@qkunst.nl"
  layout 'mailer'
end
