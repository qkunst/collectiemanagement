require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class CentralLogin < OmniAuth::Strategies::OAuth2
      # /.well-known/openid-configuration
      option :name, "central_login"
      option :client_options, site: ""

      option :redirect_url

      uid { raw_info['uid'].to_s }

      info do
        {
          name: raw_info['name'],
          email: raw_info['email'],
        }
      end

      extra do
        { raw_info: raw_info }
      end

      def raw_info
        @raw_info ||= access_token.get('/oauth/userinfo').parsed
      end

      private

      def callback_url
        Rails.logger.debug("requesting callback url")
        options.redirect_url || (full_host + script_name + callback_path)
      end
    end
  end
end

OmniAuth.config.add_camelization 'central_login', 'CentralLogin'



