# frozen_string_literal: true

require "jwt"
require "omniauth"
require "openssl"
require "securerandom"

####
# Monkey patching the updated azuread gem from Microsoft 2015: https://github.com/murb/omniauth-azure-activedirectory.git
####

module OmniAuth
  module Strategies
    # A strategy for authentication against Azure Active Directory.
    class AzureActiveDirectory
      private

      ##
      # Stores the nonce generated nonces; optional response for cookie binding
      #
      # @return String
      def store_nonce
        new_response.set_cookie("omniauth.azure.nonce", {value: encrypt(new_nonce), path: "/", expires: (Time.now + 60 * 60), secure: true, httponly: true, same_site: :none})
      end

      def generate_salt
        len = ActiveSupport::MessageEncryptor.key_len
        @generate_salt ||= SecureRandom.random_bytes(len)
      end

      def crypt(salt = generate_salt)
        return @crypt if @crypt
        len = ActiveSupport::MessageEncryptor.key_len
        key = ActiveSupport::KeyGenerator.new(Rails.application.secrets.secret_key_base).generate_key(salt, len)
        @crypt = ActiveSupport::MessageEncryptor.new(key)
      end

      def encrypt(string)
        "#{Base64.encode64(generate_salt).strip}----#{crypt.encrypt_and_sign(string)}"
      end

      def decrypt(salt_with_encrypted_data)
        salt, encrypted_data = salt_with_encrypted_data.split("----")
        crypt(Base64.decode64(salt)).decrypt_and_verify(encrypted_data)
      end

      ##
      # Returns the most recent nonce for the session and deletes it from the
      # session.
      #
      # @return String
      def read_nonce
        azure_nonce_cookie = request.cookies.delete("omniauth.azure.nonce")
        decrypt(azure_nonce_cookie) if azure_nonce_cookie
      end
    end
  end
end

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_action :verify_authenticity_token

  def google_oauth2
    data = Users::OmniauthCallbackData.new(oauth_subject: omniauth_data["uid"], oauth_provider: "google_oauth2")
    data.email = omniauth_data.info[:email] unless omniauth_data.info[:email_verified] == false
    data.email_confirmed = omniauth_data.info[:email_verified]
    data.name = omniauth_data.info[:name]
    data.qkunst = true if omniauth_data.info[:hd] == "qkunst.nl"
    data.domain = omniauth_data.dig("extra", "id_info", "hd") # hd contains organisation's domain in case of GoogleSuite-subscriber
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
    data.name  = omniauth_data.info[:name]
    data.qkunst = false

    data.raw_open_id_token = omniauth_data&.extra&.raw_info
    data.issuer = "#{omniauth_data["provider"]}/#{data.raw_open_id_token.issuer}"

    data.resources = data.raw_open_id_token["resources"]
    data.roles = data.raw_open_id_token["roles"]

    create_user_with_callback_data(data, "Central Login")
  end

  def azureactivedirectory
    data = Users::OmniauthCallbackData.new(oauth_subject: omniauth_data["uid"], oauth_provider: omniauth_data["provider"])
    data.email = omniauth_data.info[:email]
    data.email_confirmed = true
    data.name = omniauth_data.info[:name]
    data.qkunst = false

    data.raw_open_id_token = omniauth_data&.extra&.raw_info&.id_token_claims&.to_h
    data.issuer = "#{omniauth_data["provider"]}/#{data.raw_open_id_token["iss"]}"

    data.groups = data.raw_open_id_token["groups"]
    data.roles = data.raw_open_id_token["wids"]

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
