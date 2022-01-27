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

Er is een zeer beperkte API beschikbaar om informatie te lezen uit het systeem. Hiervoor dient een gebruiker een API key toegewezen te krijgen via de console (`rails c`). Om te authentiseren dient er bij iedere request een token-header meegestuurd worden, het geen een met `bcrypt` geencodeerde string is van het externe ip adres, de url en de api key.

    data = "#{self.externalip}#{url}#{method}#{request_body}"
    user_id # known user id; send as header HTTP_API_USER_ID
    api_key # shared key

    digest = OpenSSL::Digest.new('sha512')
    hmac_token = OpenSSL::HMAC.hexdigest(digest, api_key, data) # send as HTTP_HMAC_TOKEN

Om een volledige ruby request te doen:

    data = "#{external_ip}#{url}"
    digest = OpenSSL::Digest.new('sha512')
    hmac_token = OpenSSL::HMAC.hexdigest(digest, api_key, data)

    uri = URI(url)
    req = Net::HTTP::Get.new(uri)
    req['api_user_id'] = user_id
    req['hmac_token'] = hmac_token
    res = Net::HTTP.start(uri.hostname, uri.port) {|http| http.request(req) }
    response_data = JSON.parse(res.body)

Als je via de browser ingelogd bent kun je ook op die manier toegang krijgen.