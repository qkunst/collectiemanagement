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

### GET /api/v1/collections/:collection_id/works

#### Example response

```json
{
  "meta": {
    "count": 2,
    "total_count": 223
  },
  "data": [
    {
      "id": 72440,
      "stock_number": "E98008",
      "photo_front": {
        "thumb": "https://picsum.photos/100/100",
        "big_thumb": "https://picsum.photos/250/250",
        "original": "https://picsum.photos/1000/1000",
        "screen": "https://picsum.photos/640/640"
      },
      "object_creation_year": 1992,
      "location_detail": "Toren",
      "location_floor": "4",
      "artists": [
        {
          "name": "Kunste, Naar (1961)",
          "id": 392,
          "first_name": "Naar",
          "prefix": null,
          "last_name": "Kunste",
          "year_of_birth": 1961,
          "year_of_death": null,
          "rkd_artist_id": null,
          "artist_name": null,
          "place_of_birth": null,
          "place_of_death": null,
          "description": ""
        }
      ],
      "object_categories": [
        {
          "name": "Grafiek",
          "id": 3
        }
      ],
      "techniques": [
        {
          "name": "Lithografie",
          "id": 18
        }
      ],
      "artist_name_rendered": "Kunste, Naar (1961)",
      "artist_name_rendered_without_years_nor_locality": "Kunste, Naar",
      "frame_size": "73 × 98 (h×b)",
      "work_size": "56 × 76 (h×b)",
      "object_format_code": "l",
      "url": "https://collectionmanagement.qkunst.nl",
      "title_rendered": "Tree",
      "title": "Tree",
      "selling_price": "125.0",
      "purchase_price": "204.0",
      "purchased_on": "1993-10-12",

```

#### Parameters

| parameter                   | waarden          | beschrijving |
|-----------------------------|------------------|--------------|
| limit                       | 24               | geeft een limiet mee voor het aantal werken; mag hoog zijn |
| page                        | 1                | om te bladeren door door de limit beperkte werken |
| significantly_updated_since | 2021-01-01T12:12 | ISO timestamp om alleen werken op te halen die significant gewijzigd zijn sinds een bepaalde datum (b.v. voorgaande call naar de API) |

## Authentication

### JSON Web Token (from OpenID provider CentralLogin)

This is the prefferred way of authentication.

Currently it is limited to users using [Central Login](https://murb.nl/blog?tags=CentralLogin). Central Login is a separate project that offers OAuth with OpenID authentication. Its tokens can be used to make calls to the API.

Use the `Authorization` header with a Bearer token, e.g. `"Bearer #{id_token}"`

Both simple client_credentials are allowed for app connections, but when possible actions are performed using user representing tokens. See the chapter on [authentication](authentication.md) how CentralLogin tokens can be used for single sign on authorization.

Please do not confuse `access_tokens` (default tokens for OAuth) with `id_tokens` (OpenID style tokens that contain a JWT, which not only provides a token but also information that can be verified using PKI).

### Token based authentication

Er is een zeer beperkte API beschikbaar om informatie te lezen uit het systeem. Hiervoor kan een gebruiker een API key toegewezen krijgen. Om te authentiseren dient er bij iedere request een token-header meegestuurd worden, hetgeen een met `bcrypt` geencodeerde string is van het externe ip adres, de url en de api key.

```ruby
    data = "#{self.externalip}#{url}#{method}#{request_body}"
    user_id # known user id; send as header HTTP_API_USER_ID
    api_key # shared key

    digest = OpenSSL::Digest.new('sha512')
    hmac_token = OpenSSL::HMAC.hexdigest(digest, api_key, data) # send as HTTP_HMAC_TOKEN
```

Om een volledige ruby request te doen:

```ruby
    data = "#{external_ip}#{url}"
    digest = OpenSSL::Digest.new('sha512')
    hmac_token = OpenSSL::HMAC.hexdigest(digest, api_key, data)

    uri = URI(url)
    req = Net::HTTP::Get.new(uri)
    req['api_user_id'] = user_id
    req['hmac_token'] = hmac_token
    res = Net::HTTP.start(uri.hostname, uri.port) {|http| http.request(req) }
    response_data = JSON.parse(res.body)
```

Wanneer je via de browser ingelogd bent kun je ook op die manier toegang krijgen.
