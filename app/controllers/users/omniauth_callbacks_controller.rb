# frozen_string_literal: true

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_action :verify_authenticity_token

  def google_oauth2
    data = Users::OmniauthCallbackData.new(oauth_subject: omniauth_data["uid"].to_s, oauth_provider: "google_oauth2")
    data.email = omniauth_data.info[:email].to_s unless omniauth_data.info[:email_verified] == false
    data.email_confirmed = omniauth_data.info[:email_verified].to_s
    data.name = omniauth_data.info[:name].to_s
    data.domain = omniauth_data.dig("extra", "id_info", "hd").to_s # hd contains organisation's domain in case of GoogleSuite-subscriber
    data.qkunst = true if data.domain == "qkunst.nl"

    data.raw_open_id_token = omniauth_data&.extra&.raw_info.to_h

    data.issuer = "google_oauth2/#{data.domain}"
    data.groups = []
    data.roles = []

    create_user_with_callback_data(data, "Google")
  end

  def central_login
    data = Users::OmniauthCallbackData.new(oauth_subject: omniauth_data["uid"], oauth_provider: omniauth_data["provider"])
    data.email = omniauth_data.info[:email]
    data.email_confirmed = omniauth_data.info[:email_verified]
    data.name = omniauth_data.info[:name]
    data.qkunst = false
    data.oauth_expires_at = omniauth_data.credentials.expires_at
    data.oauth_refresh_token = omniauth_data.credentials.refresh_token
    data.oauth_access_token = omniauth_data.credentials.token

    data.raw_open_id_token = omniauth_data&.extra&.raw_info
    data.issuer = "#{omniauth_data["provider"]}/#{data.raw_open_id_token.issuer}"

    data.resources = data.raw_open_id_token["resources"]
    data.roles = data.raw_open_id_token["roles"]

    create_user_with_callback_data(data, "Central Login")
  end

  def azureactivedirectory
    data = Users::OmniauthCallbackData.new(oauth_subject: omniauth_data["uid"].to_s, oauth_provider: omniauth_data["provider"].to_s)
    data.email = omniauth_data.info[:email].to_s
    data.email_confirmed = true
    data.name = omniauth_data.info[:name].to_s
    data.qkunst = false

    data.raw_open_id_token = omniauth_data&.extra&.raw_info&.id_token_claims&.to_h
    data.issuer = "#{omniauth_data["provider"]}/#{data.raw_open_id_token["iss"]}"

    data.groups = data.raw_open_id_token["groups"].map(&:to_s)
    data.roles = data.raw_open_id_token["wids"].map(&:to_s)

    create_user_with_callback_data(data, "Microsoft")
  end

  def create_user_with_callback_data(data, kind)
    @user = User.from_omniauth_callback_data(data)

    if @user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", kind: kind
      sign_in_and_redirect @user, event: :authentication
    else
      session["devise.omniauth_data"] = request.env["omniauth.auth"].except("extra") # Removing extra as it can overflow some session stores
      redirect_to new_user_registration_url, alert: @user.errors.full_messages.join("\n")
    end
  end

  def failure
    if failure_message == "Csrf detected"
      set_flash_message! :alert, "Er ging iets mis bij het inloggen via de externe dienst (CSRF Fout), probeer het nogmaals."
    else
      set_flash_message! :alert, :failure, kind: OmniAuth::Utils.camelize(failed_strategy.name), reason: failure_message
    end
    redirect_to after_omniauth_failure_path_for(resource_name)
  end

  private

  def omniauth_data
    request.env["omniauth.auth"]
  end
end
