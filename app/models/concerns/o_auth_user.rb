# frozen_string_literal: true

module OAuthUser
  extend ActiveSupport::Concern

  included do
    def oauthable?
      !!(oauth_subject && oauth_provider)
    end

    def oauth_strategy
      @oauth_strategy ||= "::OmniAuth::Strategies::#{oauth_provider.classify}".constantize.new(name, Rails.application.secrets.send("#{oauth_provider}_id"), Rails.application.secrets.send("#{oauth_provider}_secret"), client_options: {site: Rails.application.secrets.send("#{oauth_provider}_site")})
    end

    def client
      @client ||= oauth_strategy.client
    end

    def refresh_required?
      Time.at(oauth_expires_at.to_i) < (Time.now + 1.minute)
    end

    def refresh!(force: false)
      return self if !refresh_required? && !force
      raise("A refresh_token is not available") unless oauth_refresh_token

      params = {}
      params[:grant_type] = "refresh_token"
      params[:refresh_token] = oauth_refresh_token
      params[:response_type] = "id_token"

      new_token = client.get_token(params)
      id_token = new_token.params["id_token"]

      validated_token = oauth_strategy.validate_id_token(id_token)

      if validated_token["sub"] == oauth_subject
        update(oauth_access_token: new_token.token, oauth_refresh_token: (new_token.refresh_token.present? ? new_token.refresh_token : refresh_token), oauth_expires_at: Time.at(new_token.expires_at, in: "UTC").to_datetime, oauth_id_token: id_token)
      end

      self
    end
  end

  class_methods do
    def find_or_initialize_from_oauth_provided_data oauth_subject:, email:, oauth_provider:
      raise "Subject empty" if oauth_subject.blank?
      raise "Provider empty" if oauth_provider.blank?

      User.find_by(oauth_subject: oauth_subject, oauth_provider: oauth_provider) || User.where("users.email ILIKE ?", email).find_by(oauth_subject: nil, oauth_provider: nil) || User.new(email: email, password: Devise.friendly_token[0, 48])
    end

    def from_omniauth_callback_data(data)
      if !data.is_a?(Users::OmniauthCallbackData) || !data.valid?
        raise ArgumentError.new("invalid omniauth data passed")
      else
        user = find_or_initialize_from_oauth_provided_data(oauth_subject: data.oauth_subject, oauth_provider: data.oauth_provider, email: data.email)
        user.oauth_provider = data.oauth_provider
        user.oauth_subject = data.oauth_subject
        user.email = data.email
        user.name = data.name
        user.qkunst = data.qkunst
        user.domain = data.domain || data.email.split("@")[1]
        user.confirmed_at ||= Time.now if data.email_confirmed?
        user.raw_open_id_token = data.raw_open_id_token&.to_hash
        user.app = !!data.app
        user.oauth_expires_at = data.oauth_expires_at
        user.oauth_refresh_token ||= data.oauth_refresh_token
        user.oauth_access_token = data.oauth_access_token

        if OAuthGroupMapping.role_mappings_exists_for?(data.issuer)
          user.reset_all_roles
          new_role = (User::ROLES & OAuthGroupMapping.retrieve_roles(data))[0]
          user.role = new_role
        end

        if OAuthGroupMapping.collection_mappings_exists_for?(data.issuer)
          user.collection_ids = OAuthGroupMapping.retrieve_collection_ids(data)
        end

        user.save

        user.refresh!(force: true) if user.persisted? && user.oauth_refresh_token # retrieve oauth_id_token; machine authenticators do not have refresh tokens

        user
      end
    end
  end
end
