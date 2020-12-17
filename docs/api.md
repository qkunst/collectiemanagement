# API

A limited API is provided, allowing for reading of works.

## Authentication

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