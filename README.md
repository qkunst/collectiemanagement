# QKunst collectiebeheer

[![Build Status](https://travis-ci.org/qkunst/collectiebeheer.svg?branch=master)](https://travis-ci.org/qkunst/collectiebeheer) [![Code Climate](https://codeclimate.com/github/qkunst/collectiebeheer/badges/gpa.svg)](https://codeclimate.com/github/qkunst/collectiebeheer)

Dit is de broncode van de QKunst Collectiebeheer applicatie, vrijgegeven onder een AGPL (GNU Affero General Public License v3.0) opensource licentie. Zie ook [LICENSE](LICENSE).
Deze web applicatie stelt u in staat om kunstwerken binnen uw collectie te bekijken en, afhankelijk van de u toegewezen rol, te beheren.

## Over QKunst Collectiebeheer

[QKunst](http://qkunst.nl) is gespecialiseerd in het inventariseren van grote bedrijfscollecties. Om deze inventarisaties
nog soepeler te laten verlopen ontwikkelden wij QKunst Collectiebeheer, een web applicatie voor collectiebeheer.
Hiermee worden grote hoeveelheden informatie over een collectie toegankelijk en kunnen we uitgebreide rapportages uitdraaien.
De applicatie wordt continu doorontwikkeld om de gebruiksvriendelijkheid ervan te vergroten.

## Functies

### Zoeken in de collectie

Voor het zoeken wordt onderliggend gebruik gemaakt van ElasticSearch. Deze kent een krachtig taaltje dat veel
queries mogelijk maakt. De belangrijkste zijn:

* *~*: fuzzy~ (ik weet de juiste spelling niet van dit woord, maar ik kan een paar letters verkeerd )
* ***: hottentottente* (het woord begint zo, maar verder…; hotten*tentoonstelling (het woord begint en eindigd zo…; *tentoonstelling (woord dat eindigt op tentoonstelling)
* *?*: l?tter (als je een letter niet meer weet)
* *OR*: Als één van de woorden er in moet voorkomen (“tentoonstelling expo”, levert 13 werken op (impliciet wordt “tentoonstelling AND expo” uitgevoerd), "tentoonstelling OR expo” levert veel meer werken op).
* *()*: "(tentoonstelling OR expo) AND direct inzetbaar” (iets met tentoonstelling of expo én direct inzetbaar).

Wanneer geen van dit soort tekens / commando's worden gebruikt wordt getracht de applicatie 'fuzzy' te doorzoeken; hetgeen betekend dat de zoekmachine iets vergevingsgezinder is t.a.v. typfouten/spelfouten.

### Langere teksten

Vele van de langere teksten in de applicatie kunnen worden opgemaakt middels [Markdown](https://nl.wikipedia.org/wiki/Markdown). In deze tekstvelden kun je beperkt de tekst opmaken. Hier een kort voorbeeld:

	  # Kop 1
	  ## Kop 2
	  …
	  ###### Kop 6

	  **Vet** *Cursief*

	  * Opsomming
	  * Opsomming

	  1. Opsomming genummerd
	  2. Opsomming genummerd

	  [Link](http://example.com)

## Installatie

De meest actuele versie van deze handleiding zal altijd terug te vinden zijn in
de source code (README.md). Deze handleiding verondersteld basiskennis Linux.
Wanneer je reeds ervaring hebt met Capistrano voor de uitrol van applicaties zal
deze handleiding grotendeels overbodig zijn.

### Over versies & OTAP

Er is een ontwikkelstraat, een teststraat, een acceptatie-straat en een productiestraat.

De code zelf staat in een git-repository. Deze kent twee branches, develop en master, en waar nodig tijdelijke feature branches. De code op de develop branch wordt geïnstalleerd op de staging server, de master branch wordt na goedkeuring van de werking door QKunst geïnstalleerd op de applicatie server voor productie.

De code in develop wordt ook gebruikt om actief in te ontwikkelen. Deze wordt ook uitgerold op de acceptatie-server. Automatische tests vinden op beide branches plaats, en zijn ingeregeld op travisci.

Er worden geen versienummers toegekend, de applicatie is in principe continue in ontwikkeling. Er kan gecommuniceerd worden over de geïnstalleerde versie dmv commit ids, een lange string die op basis van datum en tijd en omgeving gemakkelijk teruggevonden kan worden in het deployment logboek dat automatisch door de deployment-tool wordt bijgehouden.

Updates van de applicatie worden door de leverancier van de software uitgevoerd middels Capistrano, maar een ander update mechanisme kan gebruikt worden. Door gebruik te maken van Capistrano kunnen updates op de acceptatie en productie omgevingen bijna onmerkbaar uitgevoerd worden.

### Pakketten die aanwezig dienen te zijn

Zorg voor een server die in staat is om Rails applicaties te draaien. De QKunst Collectiedatabase draait op moment van schrijven op een Debian Jessie server met voorgeïnstalleerd de volgende zaken:

* postgresql
* nginx
* imagemagick
* elasticsearch 5.4
* passenger
* redis
* Java 8 (geïnstalleerd met behulp van webupd8team ppa package, zie beneden en `apt-get install oracle-java8-installer`)
* Ruby 2.3.3 (geïnstalleerd via rbenv)

Ruby wordt geïnstalleerd via rbenv, dit is een systeem om verschillende ruby-versies te kunnen ondersteunen. Installatie instructies hiervoor zijn te vinden op de [rbenv source code pagina](https://github.com/rbenv/rbenv).

Op het moment van schrijven worden de volgende repositories hiervoor geraadpleegd:

    deb http://debian.directvps.nl/debian jessie main
    deb http://debian.directvps.nl/security jessie/updates main
    deb http://ppa.launchpad.net/webupd8team/java/ubuntu precise main # let op: voeg key toe: apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886
    deb https://artifacts.elastic.co/packages/5.x/apt stable main
    deb https://oss-binaries.phusionpassenger.com/apt/passenger jessie main

Op ElasticSearch en Passenger na worden dus de standaard door Debian geleverde versies gehanteerd en alle server pakketten worden dagelijks automatisch voorzien van veiligheidsupdates. Voor een basis inrichting kan het volgende artikel worden geraadpleegd:

* [Basis server inrichting handleiding voor Rails op basis van Debian, nginx, passenger en rbenv](https://murb.nl/articles/204-a-somewhat-secure-debian-server-with-nginx-passenger-rbenv-for-hosting-ruby-on-rails-with-mail-support-and-deployment-with-capistrano)

### Inrichting ontwikkelomgeving

Verondersteld wordt dat `git` en alle andere eerder genoemde server software aanwezig is op het ontwikkelsysteem (op nginx en passenger na).

Op macOS kunnen deze pakketten eventueel ook via homebrew worden geïnstalleerd. Of de applicatie op Windows zou kunnen draaien is onduidelijk. Een *nix-achtig systeem wordt (eigenlijk altijd) aanbevolen.

Clone de repository:

    git clone https://github.com/qkunst/collectiebeheer.git

De commando's die volgen worden allemaal uitgevoerd in de project folder, dus
navigeer hier naartoe (`cd collectiebeheer`)

#### Installatie afhankelijkheden

De QKunst collectiedatabase is gebaseerd op het Ruby On Rails framework en andere opensource bibliotheken, zogenaamde gems. Deze zijn gemakkelijk te installeren middels het `bundler` commando:

    bundle install

Is het commando `bundle` niet aanwezig op het systeem, typ dan eerst `gem install bundler`.

#### Inrichting van de database

Het Ruby on Rails framework komt met een ingebouwd migratiesysteem om een volledige database in te richten. Hiervoor dient de connectie met de database server geconfigureerd worden. Dit kan in het bestand `database.yml`.
Na configuratie dient het volgende commando uitgevoerd te worden:

    RAILS_ENV=production rails db:migrate

Het bestand [`db/schema.rb`](db/schema.rb) kan geraadpleegd worden om een indruk te krijgen van alle tabellen.

#### Applicatie starten

De applicatie kan nu gestart worden middels het commando

    rails s

#### Aanmaken van een eerste admin gebruiker

Om gebruikers rechten te kunnen geven is een administrator-account nodig. Een administrator kan ook andere gebruikers tot administrator benoemen, maar
de eerste gebruiker dient handmatig tot administrator worden benoemd. Doorloop de reguliere registratie methode, en open de console:

    rails c [environment_name]

(de environment_name is standaard ‘`development`’ (voor lokale ontwikkeling, op server typ hier ‘`production`’ (zonder aanhalingstekens))

Type vervolgens de volgende commando's:

    u = User.where(email: jouw_email).first
    u.admin = true
    u.save

De gebruiker met 'jouw_email' als e-mailadres kan vervolgens andere gebruikers administrator rechten geven via de administratie functie binnen de applicatie.

### Installatie van de applicatie op een server voor acceptatie en productie

Zorg dat de server gereed is voor gebruik: [Basis server inrichting handleiding voor Rails op basis van Debian, nginx, passenger en rbenv](https://murb.nl/articles/204-a-somewhat-secure-debian-server-with-nginx-passenger-rbenv-for-hosting-ruby-on-rails-with-mail-support-and-deployment-with-capistrano).

We gebruiken Capistrano wat de uitrol vergemakkelijkt. Hiervoor is het noodzakelijk dat
capistrano goed wordt geconfigureerd. Zie voor een voorbeeld bestand config/deploy/production.rb.example.
('.example' moet vanzelfsprekend verwijderd worden na het correct hebben geconfigureerd van de server).

Draai nu:

    cap production deploy

De eerste keer zal deze falen, maar door het eenmaal te draaien worden veel van de standaard
directories klaargezet op de server.

Vervolgens is het zaak om de `database.yml` en `secrets.yml` configuratie voor productie gereed te zetten.
Dit is een eenmalige operatie die plaats vind op de server. De structuur is gelijk aan de `config/database.yml` en `config/secrets.yml` files, maar
de files in deze publieke repository bevatten (om veiligheidsredenen) geen productiegegevens.

Kopieer deze bestanden naar de server in de `shared/config` folder (de folder `shared` zal na `cap production deploy` al aangemaakt zijn)

Meer over het configureren van Rails applicaties, zoals deze, raadpleeg de Rails documentatie: [Configuring Rails Applications](http://guides.rubyonrails.org/configuring.html).

### De applicatie draaien op andere omgevingen.

Rails bied ook ondersteuning voor andere databases, en draait ook op diverse servers-typen.
We testen echter niet actief in andere omgevingen dan de hierboven beschreven omgeving.
De applicatie wordt echter wel ontwikkeld op een macOS systeem.

## Identity Access Management

### Identificatie

Identificatie geschied door invoer van een e-mail/wachtwoord inlog. De identiteit
wordt na registratie geverifieerd door een administrator. Pas daarna krijgt een
geregistreerde gebruiker toegang tot enige collectie.

### Toegang

#### Tot collecties

Administratoren hebben toegang tot alle collecties, en zijn ook in staat de rollen
van gebruikers aan te passen. Alle rol- en collectieaanpassingen worden op gebruikersmodel niveau automatisch gelogd.

Collecties zijn hierarchisch georganiseerd. Er zijn dus super- en sub-collecties.
Iemand met toegang tot een een collectie hoger in de hierarchie heeft automatisch
toegang tot alle onderliggende collecties.

Toegang tot een bepaald werk kan niet op het niveau van het individuele werk worden bepaald.

#### Tot functionaliteit

QKunst collectiebeheer kent een simpel rollenmodel. De rollen die worden onderscheiden zijn:

* Administrator
* Taxateur
* Registrator
* Facility Manager
* Read only
* Inactieve gebruiker (read only gebruiker zonder toegang tot enige collectie)

Een gebruiker heeft slechts 1 rol, al is de functionaliteit van de rollen overlappend.

Belangrijk onderscheid tussen Registrator en Taxateur is de toegang tot waarderingen van de werken (en deze kunnen toevoegen).
Belangrijk onderscheid tussen Read only en Facility Manager is de toegang tot waarderingen. Een Facility Manager kan echter geen taxaties toevoegen of aanpassen.
Read only gebruikers beschikken ook niet over alle filtermogelijkheden.

### Management

Het beheer van rollen en koppeling aan een collectie kan slechts gedaan worden door een administrator.

## Backup

### Herstellen met een databasebackup

Er wordt dagelijks een `pg_dump` (een standaard export functie van PostgreSQL) gedaan van alle informatie in de database. Deze wordt beveiligd opgeslagen en verstuurd op de server en bij QKunst en bij de leverancier. Deze backups zijn niet te gebruiken door een enkele afnemer van de QKunst collectiedatabase omdat deze informatie bevat van alle klanten. Wel is deze backup te gebruiken om een backup terug te halen.

### Herstellen met een export

Eigenaren van een collectie kunnen een export maken (een excel bestand en een zip bestand met alle foto's). Deze export kan vervolgens gebruikt worden om collectie opnieuw te importeren middels de standaard import functie.
Toegangsrechten dienen wel opnieuw ingesteld te worden.

## Bijdragen aan de applicatie

1. Clone deze repository
2. Maak nieuwe functionaliteit in een feature branch
3. Vraag een pull request aan en beschrijf wat je hebt aangepast
4. Wees behulpzaam en vriendelijk bij evt. vragen van de maintainer (QKunst)

## Toegepaste cryptografie-technieken

### Connectie

Toegang tot de applicatie is slechts mogelijk via een HTTPS verbinding (min. TLS 1.0). Dit wordt afgedwongen door zowel de applicatie als de webserver. De webserver staat slechts een beperkte set aan verlesutelingscombinaties toe. Zie onderstaand:

> ##### TLS 1.2 (suites in voorkeursvolgorde van de server)
>
> * TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
> * TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
> * TLS_DHE_RSA_WITH_AES_256_GCM_SHA384
> * TLS_DHE_RSA_WITH_AES_128_GCM_SHA256
> * TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384
> * TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA
> * TLS_DHE_RSA_WITH_AES_256_CBC_SHA256
> * TLS_DHE_RSA_WITH_AES_256_CBC_SHA
>
> ##### TLS 1.1 (suites in voorkeursvolgorde van de server)
>
> * TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA
> * TLS_DHE_RSA_WITH_AES_256_CBC_SHA
>
> ##### TLS 1.0 (suites in voorkeursvolgorde van de server)
>
> * TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA
> * TLS_DHE_RSA_WITH_AES_256_CBC_SHA

Zie voor meer details (en up to date): [Qualys SSL Report: collectiebeheer.qkunst.nl](https://www.ssllabs.com/ssltest/analyze.html?d=collectiebeheer.qkunst.nl).

Certificaat wordt een maand voor verlopen vernieuwd.

#### Hashing wachtwoorden

Wachtwoorden worden 10x gehashed met [bcrypt](https://en.wikipedia.org/wiki/Bcrypt)

#### API

De API loopt over dezelfde HTTPS verbinding als de eindgebruikersinterface. Voor de ondertekening van de berichten wordt [HMAC](https://en.wikipedia.org/wiki/Hash-based_message_authentication_code) gebruikt welke gebruik maakt van een SHA512 digest.
Sleutels voor API's kennen geen beperking in levensduur, maar kunnen op verzoek worden gereset. Wanneer er geen API-key verzoek is gedaan, is API toegang voor die 'gebruiker' niet mogelijk.

#### Servertoegang

Voor deployment wordt gebruikt van een OpenSSH (dagelijks wordt gecontroleerd op veiligheids updates) SSL verbinding, waartoe slechts toegang wordt verleend middels SSH-sleutels. Directe root-toegang via SSH is uitgesloten. Configuratie van de gebruikte ciphers voor SSH wijkt niet af van de standaard configuratie die komt met Debian Jessie package voor OpenSSL.

## API

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

## Ontwikkelen

### Afhankelijkheden

curl -X PUT "localhost:9200/_settings" -H 'Content-Type: application/json' -d'{"index": {"blocks": {"read_only_allow_delete": "false"}}}'
curl -X PUT "localhost:59200/_settings" -H 'Content-Type: application/json' -d'{"index": {"blocks": {"read_only_allow_delete": "false"}}}'