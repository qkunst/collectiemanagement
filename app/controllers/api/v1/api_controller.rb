require 'bcrypt'

class Api::V1::ApiController < ApplicationController
  def authenticate_activated_user!
    if current_user
      @user = current_user
    else
      @user = User.where(id: request.headers["X-user-id"].to_i).first

      return not_authorized if !@user or !@user.api_key

      data = "#{request.remote_ip}#{request.url}#{request.body.read}"
      digest = OpenSSL::Digest.new('sha512')
      expected_token = OpenSSL::HMAC.hexdigest(digest, @user.api_key, data)
      received_token = request.headers["X-hmac-token"].strip.to_s

      return not_authorized unless received_token == expected_token
    end
  end

  def not_authorized
    render json: {
      message: "Not authorized",
      nuid: request.headers['X-user-id'].to_i,
      data: "#{request.remote_ip}#{request.url}#{request.body.read})",
      your_remote_ip: request.remote_ip
    }, status: 401
    return false
  end
end
