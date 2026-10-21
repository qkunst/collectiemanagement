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
        new_response.set_cookie("omniauth.azure.nonce", {value: encrypt(new_nonce), path: "/", expires: (Time.current + 60 * 60), secure: true, httponly: true, same_site: :none})
      end

      def generate_salt
        len = ActiveSupport::MessageEncryptor.key_len
        @generate_salt ||= SecureRandom.random_bytes(len)
      end

      def crypt(salt = generate_salt)
        return @crypt if @crypt

        len = ActiveSupport::MessageEncryptor.key_len
        key = ActiveSupport::KeyGenerator.new(Rails.application.credentials.secret_key_base).generate_key(salt, len)
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
