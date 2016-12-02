require 'bcrypt'

class Api::V1::ApiController < ApplicationController
  def authenticate_activated_user!
    # raise "#{request.headers["HTTP_TOKEN"]}"
    # render body: request.inspect, status: 200
    # return false
    # raise request
    p request.headers["X-user-id"].to_i


    u = User.where(id: request.headers["X-user-id"].to_i).first

    return not_authorized if !u or !u.api_key

    data = "#{request.remote_ip}#{request.url}#{request.body.read}"

    digest = OpenSSL::Digest.new('sha512')

    expected_token = OpenSSL::HMAC.hexdigest(digest, u.api_key, data)

    received_token = request.headers["X-hmac-token"].strip.to_s

    return not_authorized unless received_token == expected_token

  end

  def not_authorized
    render text: "Not authorized\n\nuid: #{request.headers['X-user-id'].to_i}; data: #{request.remote_ip}#{request.url}#{request.body.read})", status: 401
    return false
  end
end
