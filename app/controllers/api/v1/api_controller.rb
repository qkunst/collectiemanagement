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
      data = "#{request.remote_ip}#{request.url}#{request.body.read}"
      digest = OpenSSL::Digest.new("sha512")
      expected_token = OpenSSL::HMAC.hexdigest(digest, @user.api_key, data)
      received_token = request.headers["X-hmac-token"].strip.to_s
      return not_authorized unless received_token == expected_token
      @user
    elsif request.headers["Authorization"] && request.headers["Authorization"].starts_with?("Bearer ")
      # only compatible with central login id token

      id_token = request.headers["Authorization"].gsub(/\ABearer\s+/,"")
      user_data = oauth_strategy.validate_id_token(id_token)

      data = Users::OmniauthCallbackData.new(oauth_subject: user_data["uid"], oauth_provider: :central_login)
      data.email = user_data["email"]
      data.email_confirmed = user_data["email_verified"]
      data.name  = user_data["name"]
      data.qkunst = false

      data.issuer = "central_login/#{user_data['iss']}"

      data.resources = user_data["resources"]
      data.roles = user_data["roles"]

      @user = User.from_omniauth_callback_data(data)
    else
      return not_authorized
    end
  rescue JWT::ExpiredSignature
    return not_authorized("JWT token is expired")
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

  def not_authorized additional_message=nil
    render json: {
      message: ["Not authorized", additional_message].compact.join(" "),
      nuid: request.headers["X-user-id"].to_i,
      data: "#{request.remote_ip}#{request.url}#{request.body.read})",
      your_remote_ip: request.remote_ip
    }, status: 401
    false
  end

  def oauth_strategy
    @oauth_strategy ||= ::OmniAuth::Strategies::CentralLogin.new(:central_login, Rails.application.secrets.central_login_id, Rails.application.secrets.central_login_secret, client_options: {site: Rails.application.secrets.central_login_site})
  end

end
