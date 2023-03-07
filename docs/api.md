# API

A limited API is provided, primarily for reading, although support has been added to create and update TimeSpans, objects that represent an event (e.g. rent of the work concerned)

## Available actions

    GET      /api/v1/time_spans(.:format)
    GET      /api/v1/works/:id(.:format)
    POST     /api/v1/collections/:collection_id/works/:work_id/work_events(.:format)
    GET      /api/v1/collections/:collection_id/works(.:format)
    GET      /api/v1/collections/:collection_id/works/:id(.:format)
    GET      /api/v1/collections(.:format)
    GET      /api/v1/collections/:id(.:format)

## Authentication

### JSON Web Token (from OpenID provider CentralLogin)

This is the prefferred way of authentication.

Currently it is limited to users using [Central Login](https://murb.nl/blog?tags=CentralLogin). Central Login is a separate project that offers OAuth with OpenID authentication. Its tokens can be used to make calls to the API.

Use the `Authorization` header with a Bearer token, e.g. `"Bearer #{id_token}"`

Both simple client_credentials are allowed for app connections, but when possible actions are performed using user representing tokens. See the chapter on [authentication](authentication.md) how CentralLogin tokens can be used for single sign on authorization.

Please do not confuse `access_tokens` (default tokens for OAuth) with `id_tokens` (OpenID style tokens that contain a JWT, which not only provides a token but also information that can be verified using PKI).

### Token based authentication

Er is een zeer beperkte API beschikbaar om informatie te lezen uit het systeem. Hiervoor dient een gebruiker een API key toegewezen te krijgen via de console (`rails c`). Om te authentiseren dient er bij iedere request een token-header meegestuurd worden, het geen een met `HMAC` geencodeerde string is van het externe ip adres, de url en de api key.

Om een volledige ruby request te doen:

    data = "#{external_ip}#{url}#{request_body}"
    digest = OpenSSL::Digest.new('sha512')
    hmac_token = OpenSSL::HMAC.hexdigest(digest, api_key, data)

    uri = URI(url)
    req = Net::HTTP::Get.new(uri)
    req['X-user-id'] = user_id
    req['X-hmac-token'] = hmac_token
    options = {use_ssl: true}
    res = Net::HTTP.start(uri.hostname, uri.port, options) {|http|
      http.request(req)
    }
    JSON.parse(res.body)

Als je via de browser ingelogd bent kun je ook op die manier toegang krijgen.

Een meer curly request:

    #!/usr/bin/env ruby
    require 'openssl'
    require 'json'

    api_key = ENV['API_KEY']
    external_ip = ENV['EXTERNAL_IP']
    user_id = ENV['USER_ID']
    url = ENV['URL']

    data = "#{external_ip}#{url}"
    puts "data: #{data}"
    digest = OpenSSL::Digest.new('sha512')
    hmac_token = OpenSSL::HMAC.hexdigest(digest, api_key, data)

    command = "curl -H 'X-hmac-token: #{hmac_token}' -H 'X-user-id: #{user_id}' #{url}"

    puts "CURL COMMAND: #{command}"

    response = JSON.parse(`#{command}`)

    puts "Succesful" if response["data"].count > 1

