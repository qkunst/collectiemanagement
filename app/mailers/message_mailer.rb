# frozen_string_literal: true

class MessageMailer < ApplicationMailer
  def new_message(user, message)
    @user = user
    @message = message
    mail(to: @user.email, subject: "#{I18n.t("organisation.name")}: #{message.subject}")
  end
end
