# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  def create
    if oauth_provider
      sign_out
      redirect_to users_oauth_path(methods: [oauth_provider])
    else
      super
      # this has basically become a no-op
      if current_user.enforce_oauth?
        sign_out
        set_flash_message! :alert, :oauth_required
      end
    end
  end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
  #

  private

  def email
    params.require(:user).require(:email)
  end

  def domain
    email.split("@").last.strip
  end

  def organisation
    Organisation.for_domain(domain).first if domain.present?
  end

  def user
    User.find_by(email:)
  end

  def oauth_provider
    sleep(rand / 2) # adding some noise
    organisation&.auth_provider || user&.oauth_provider
  end
end
