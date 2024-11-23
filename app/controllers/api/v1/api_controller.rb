# frozen_string_literal: true

require "bcrypt"

class Api::V1::ApiController < ApplicationController
  helper_method :current_api_user

  def api_authorize! action, subject
    Ability.new(current_api_user).authorize! action, subject
  end

  def current_api_user
    return @user if @user
    if current_user
      @user = current_user
    elsif request.headers["X-user-id"]
      @user = User.where(id: request.headers["X-user-id"].to_i).first
      return not_authorized if !@user || !@user.api_key
      data = "#{request.remote_ip}#{request.url}#{request.body&.read}"
      digest = OpenSSL::Digest.new("sha512")
      expected_token = OpenSSL::HMAC.hexdigest(digest, @user.api_key, data)
      received_token = request.headers["X-hmac-token"].strip
      return not_authorized unless received_token == expected_token
      @user
    elsif request.headers["Authorization"]&.starts_with?("Bearer ")
      # only compatible with central login id token

      id_token = request.headers["Authorization"].gsub(/\ABearer\s+/, "")
      user_data = central_login_oauth_strategy.validate_id_token(id_token)

      data = Users::OmniauthCallbackData.new(oauth_subject: user_data["uid"] || user_data["sub"], oauth_provider: :central_login)

      if user_data["sub"].starts_with?("app-")
        issuer_hostname = user_data["iss"].split("//").last.delete("/")
        data.email = "app-connection-#{user_data["sub"]}@#{issuer_hostname}"
        data.email_confirmed = "app-connection-#{user_data["sub"]}@#{issuer_hostname}"
        data.name = user_data["name"] || "#{user_data["sub"].gsub("app-", "").tr("_", " ")} @ #{issuer_hostname}"
        data.app = true
      else
        data.email = user_data["email"]
        data.email_confirmed = user_data["email_verified"]
        data.name = user_data["name"]
        data.app = false
      end
      data.qkunst = false

      data.issuer = "central_login/#{data.app ? "app/" : ""}#{user_data["iss"]}"

      data.resources = user_data["resources"]
      data.roles = user_data["roles"]

      @user = User.from_omniauth_callback_data(data)
    else
      not_authorized
    end
  rescue JWT::ExpiredSignature
    not_authorized("JWT token is expired")
  end

  def authenticate_activated_user!
    current_api_user
  end

  private

  def unprocessable_entity
    render json: {
      message: "Unprocessable entity"
    }, status: 422
    false
  end

  def not_authorized additional_message = nil
    render json: {
      message: ["Not authorized", additional_message].compact.join(" "),
      nuid: request.headers["X-user-id"].to_i,
      data: "#{request.remote_ip}#{request.url}#{request.body&.read}",
      your_remote_ip: request.remote_ip
    }, status: 401
    false
  end

  def central_login_oauth_strategy
    @central_login_oauth_strategy ||= ::OmniAuth::Strategies::CentralLogin.new(:central_login, Rails.application.credentials.central_login_id, Rails.application.credentials.central_login_secret, client_options: {site: Rails.application.credentials.central_login_site})
  end
end
