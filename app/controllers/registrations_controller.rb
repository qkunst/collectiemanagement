# frozen_string_literal: true

class RegistrationsController < Devise::RegistrationsController
  invisible_captcha only: [:create]
  before_action :configure_account_update_params, only: [:update]

  protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :receive_mails])
  end
end
