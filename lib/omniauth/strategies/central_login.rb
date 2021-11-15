require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class CentralLogin < OmniAuth::Strategies::OAuth2
      option :name, "central_login"
      option :client_options, site: ""

      option :redirect_url

      uid { raw_info['id'].to_s }

      info do
        {
          name: raw_info['name'],
          username: raw_info['username'],
          email: raw_info['email'],
          image: raw_info['avatar_url']
        }
      end

      extra do
        { raw_info: raw_info }
      end

      def raw_info
        binding.irb
        @raw_info ||= access_token.get('user').parsed
      end

      private

      def callback_url
        options.redirect_url || (full_host + script_name + callback_path)
      end
    end
  end
end

OmniAuth.config.add_camelization 'central_login', 'CentralLogin'