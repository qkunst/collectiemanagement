# frozen_string_literal: true

class MessageMailer < ApplicationMailer

  def new_message(user, message)
    @user = user
    @message = message
    mail(to: @user.email, subject: "QKunst: #{message.subject}")
  end

end
