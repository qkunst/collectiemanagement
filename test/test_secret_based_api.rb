#!/usr/bin/env ruby
require "openssl"
require "json"

api_key = ENV["API_KEY"]
external_ip = ENV["EXTERNAL_IP"]
user_id = ENV["USER_ID"]
url = ENV["URL"]

data = "#{external_ip}#{url}"
puts "data: #{data}"
digest = OpenSSL::Digest.new("sha512")
hmac_token = OpenSSL::HMAC.hexdigest(digest, api_key, data)

command = "curl -H 'X-hmac-token: #{hmac_token}' -H 'X-user-id: #{user_id}' #{url}"

puts "CURL COMMAND: #{command}"

response = JSON.parse(`#{command}`)

begin
  puts "Succesful" if response["data"].count > 1
rescue
  p response
end
