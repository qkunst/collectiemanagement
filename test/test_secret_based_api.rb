#!/usr/bin/env ruby
require "openssl"
require "json"
require "securerandom"

api_key = ENV["API_KEY"]
external_ip = ENV["EXTERNAL_IP"]
user_id = ENV["USER_ID"]
url = ENV["URL"]

data = "#{external_ip}#{url}"
digest = OpenSSL::Digest.new("sha512")
hmac_token = OpenSSL::HMAC.hexdigest(digest, api_key, data)

puts "HMAC(sha512, key, '#{data}') => #{hmac_token}"

command = "curl -H 'X-hmac-token: #{hmac_token}' -H 'X-user-id: #{user_id}' #{url}"

puts "CURL COMMAND: #{command}"

response = JSON.parse(`#{command}`)

begin
  puts "Succesful" if response["data"].count > 1
  binding.irb
rescue
  p response
end
