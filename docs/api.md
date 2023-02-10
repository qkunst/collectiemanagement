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
    "count": 1,                                                         # Aantal werken in de response
    "total_count": 130                                                  # Totaal aantal werken
  },                                                                    # 
  "data": [                                                             # 
    {                                                                   # 
      "collection_id": 438,                                             # Collectie ID
      "id": 86115,                                                      # Database ID van het werk
      "significantly_updated_at": "2021-07-19T08:22:31.822+02:00",      # Moment van laatste significante wijziging (updated_at wordt vaker bijgewerkt)
      "stock_number": "00349.B",                                        # Inventarisnummer
      "title": null,                                                    # Titel
      "title_unknown": true,                                            # Titel onbekend (boolean)
      "description": "beschrijving",                                    # Beschrijving
      "object_creation_year": 1970,                                     # Vervaardigingsjaar
      "object_creation_year_unknown": false,                            # Moment van vervaardigen onbekend
      "object_categories": [                                            # Categoriën
        {                                                               # 
          "name": "Sculptuur (binnen)",                                 # 
          "id": 6                                                       #     id is interne ID
        }                                                               # 
      ],                                                                # 
      "techniques": [                                                   # Technieken
        {                                                               # 
          "name": "Polyester",                                          # 
          "id": 214                                                     # 
        }                                                               # 
      ],                                                                # 
      "artists": [                                                      # Vervaardigers
        {                                                               # 
          "name": "Kunste, Naar",                                       # 
          "id": 62750,                                                  # 
          "first_name": "Naar",                                         # 
          "prefix": null,                                               # Voorvoegsel achtertnaam
          "last_name": "Kunste"  ,                                      # 
          "year_of_birth": null,                                        # 
          "year_of_death": null,                                        # 
          "rkd_artist_id": null,                                        # RKD artists ID
          "artist_name": null,                                          # 
          "place_of_birth": null,                                       # 
          "place_of_death": null,                                       # 
          "description": null                                           # 
        }                                                               # 
      ],                                                                # 
      "themes": [                                                       # Thema's (wordt soms)
        {                                                               # 
          "name": "Mensen",                                             # 
          "id": 138                                                     # 
        }                                                               # 
      ],                                                                # 
      "title_rendered": "Zonder titel",                                 # Titel (voor weergave)
      "frame_type": null,                                               # Lijsttype
      "abstract_or_figurative_rendered": null,                          # Abstract of figuratief (voor weergave)
      "collection_name_extended": "Collectie",                          # Collectienaam
      "locality_geoname_name": null,                                    # Plaatsbeschrijving
      "print_rendered": null,                                           # Oplage (voor weergave)
      "condition_work_rendered": "Goed (++)",                           # Conditie werk (voor weergave)
      "condition_frame_rendered": null,                                 # Conditie lijst (voor weergave)
      "print": null,                                                    # Oplage
      "print_unknown": null,                                            # Oplage onbekend (boolean)
      "frame_height": 100.0,                                            # Lijst hoogte
      "frame_width": 70.0,                                              # Lijst breedte
      "frame_depth": 30.0,                                              # Lijst diepte
      "frame_diameter": null,                                           # Grootste Diameter
      "height": null,                                                   # Werk hoogte
      "width": null,                                                    # Werk breedte
      "depth": null,                                                    # Werk diepte
      "diameter": null,                                                 # Werk diameter
      "public_description": null,                                       # Publieke beschrijving
      "abstract_or_figurative": null,                                   # Abstract of figuratief (enum)
      "artist_name_rendered_without_years_nor_locality": "Kunste Naar", # Vervaardigersnaam (voor weergave; kort)
      "location_detail": "Kamer 32A",                                   # Locatie detail
      "location": "Rotterdam",                                          # Locatie
      "location_floor": null,                                           # Locatie verdieping
      "removed_from_collection_at": null,                               # Verwijderd uit collectie op
      "time_spans": [                                                   # 
                                                                        # 
      ],                                                                # 
      "internal_comments": null,                                        # Interne opmerkingen
      "alt_number_1": "ABC",                                            # Alternatieve nummers
      "alt_number_2": null,                                             # 
      "alt_number_3": null,                                             # 
      "alt_number_4": null,                                             # 
      "alt_number_5": null,                                             # 
      "alt_number_6": null,                                             # 
      "entry_status": null,                                             # Invoerstatus
      "entry_status_description": null,                                 # Invoerstatus opmerkingen
      "updated_at": "2023-02-10T07:00:20.288+01:00",                    # 
      "created_at": "2019-09-29T16:31:14.910+02:00",                    # 
      "inventoried": false,                                             # Geïnventariseerd (boolean)
      "refound": false,                                                 # Teruggevonden (boolean)
      "new_found": false,                                               # Gevonden (boolean)
      "inventoried_at": null,                                           # Geïnventariseerd op (datum)
      "refound_at": null,                                               # Teruggevonden op (datum)
      "new_found_at": null,                                             # Gevonden op (datum)
      "locality_geoname_id": null,                                      # Geoname ID van localiteit
      "imported_at": "2019-09-29T16:29:08.391+02:00",                   # -
      "import_collection_id": 63,                                       # -
      "artist_unknown": false,                                          # Vervaardiger onbekend (boolean)
      "cached_tag_list": [                                              # Tags
        "Uit Collectie",                                                # 
        "Standplaats gecontroleerd december 2019"                       # 
      ],                                                                # 
      "signature_comments": null,                                       # Signatuur opmerkingen
      "no_signature_present": null,                                     # Geen signatuur bekend (boolean)
      "other_comments": "Datering: 1969-1970",                          # Overige opmerkingen
      "grade_within_collection": "B",                                   # Niveau binnen de collectie
      "medium_comments": null,                                          # Opmerkingen drager
      "main_collection": null,                                          # Verwijzing naar hoofdcollectie
      "image_rights": false,                                            # Rechten publicatie afbeeldingen (boolean)
      "publish": false,                                                 # Publiceren (boolean)
      "cluster_name": "Cluster",                                        # Clusternaam (veelal intern)
      "permanently_fixed": null,                                        # Aard- en nagelvast (boolean)
      "removed_from_collection_note": null,                             # Verwijderd uit collectie omdat
      "signature_rendered": null,                                       # Signatuur (voor weergave)
      "information_back": null,                                         # Informatie achterzijde
      "damage_types": [                                                 # Beschadigingen
                                                                        # 
      ],                                                                # 
      "frame_damage_types": [                                           # Beschadigingen lijst
                                                                        # 
      ],                                                                # 
      "condition_work_comments": null,                                  # Conditie werk opmerkingen
      "condition_frame_comments": null,                                 # Conditie lijst opmerkingen
      "source_comments": "Herkomst opmerking",                          # Herkomst opmerkingen
      "sources": [                                                      # Herkomst
        {                                                               # 
          "name": "Aankoop",                                            # 
          "id": 5                                                       # 
        }                                                               # 
      ],                                                                # 
      "purchase_price": "7215.11",                                      # Aankoopprijs
      "purchased_on": "1991-11-06",                                     # Aankoopdatum
      "purchase_year": 1991,                                            # Aankoopjaar
      "fin_balance_item_id": null,                                      # Balansitem
      "selling_price": null,                                            # Verkoopprijs
      "minimum_bid": null,                                              # Startwaarde
      "selling_price_minimum_bid_comments": null,                       # Opmerkingen verkoopprijs
      "balance_category_id": null,                                      # Balanscategorie
      "artist_name_for_sorting": "Naar, Kunste",                        # Vervaardigersnaam voor sortering
      "photo_front": {                                                  # Foto voorzijde
        "thumb": "https://picsum.photos/100/100",                       #
        "big_thumb": "https://picsum.photos/250/250",                   #
        "original": "https://picsum.photos/1000/1000",                  #
        "screen": "https://picsum.photos/640/640"                       #
      },                                                                # 
      "purchase_price_currency_iso_4217_code": null,                    # Aankoopprijs munteenheid (ISO 4217)
      "cluster": {                                                      # Cluster
        "name": "Cluster",                                              # 
        "id": 1910                                                      # 
      },                                                                # 
      "condition_work": {                                               # Conditie werk
        "name": "Goed (++)",                                            # 
        "id": 1                                                         # 
      },                                                                # 
      "appraisals": [                                                   # Marktwaarderingen
        {                                                               # 
          "market_value": "2000.0",                                     # 
          "replacement_value": null,                                    # 
          "appraised_on": "2012-01-01",                                 # 
          "market_value_max": null,                                     # 
          "market_value_min": null,                                     # 
          "replacement_value_min": null,                                # 
          "replacement_value_max": null,                                # 
          "appraised_by": null,                                         # 
          "reference": null                                             # 
        }                                                               # 
      ],                                                                # 
      "work_sets": [                                                    # Werkgroepperingen
                                                                        # 
      ],                                                                # 
      "collection_branch_names": [                                      # Collectie en bovenliggende collecties
        "Supercollectie", "Collectie"                                   #  
      ],                                                                # 
      "artist_name_rendered": "Naar, Kunste",                           # Vervaardigersnaam (voor weergave)
      "frame_size": "100 × 70 × 30 (h×b×d)",                            # Lijstgrootte (voor weergave)
      "work_size": null,                                                # Werkgrootte (voor weergave)
      "height_with_fallback": 100.0,                                    # 
      "width_with_fallback": 70.0,                                      # 
      "depth_with_fallback": 30.0,                                      # 
      "diameter_with_fallback": null,                                   # 
      "object_format_code": "l",                                        # Formaatcode
      "orientation": "portrait",                                        # Orientatie
      "for_purchase": false,                                            # Te koop
      "for_rent": false,                                                # Te huur
      "availability_status": "available_not_for_rent_or_purchase",      # Beschikbaarheid
      "market_value": "2000.0",                                         # Marktwaarde
      "market_value_range": "-",                                        # Marktwaarde range
      "replacement_value": null,                                        # Vervangingswaarde
      "replacement_value_range": "-",                                   # Vervangingswaarde range
      "available": true,                                                # Beschikbaar
      "tag_list": [                                                     # Tags
        "Uit Collectie",                                                # 
        "Standplaats gecontroleerd december 2019"                       # 
      ],                                                                # 
      "url": "https://collectiemanagement.qkunst.nl/"                   # URL in collectiemanagement systeem
    }                                                                   # 
  ]
}
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
