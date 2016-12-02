# QKunst collectiebeheer

Dit is de broncode van de QKunst Collectiebeheer applicatie, vrijgegeven onder een AGPL (GNU Affero General Public License v3.0) opensource licentie. Zie ook [LICENSE](LICENSE).
Deze web applicatie stelt u in staat om kunstwerken binnen uw collectie te bekijken en, afhankelijk van de u toegewezen rol, te beheren.

## Over QKunst Collectiebeheer

[QKunst](http://qkunst.nl) is gespecialiseerd in het inventariseren van grote bedrijfscollecties. Om deze inventarisaties
nog soepeler te laten verlopen ontwikkelden wij QKunst Collectiebeheer, een web applicatie voor collectiebeheer.
Hiermee worden grote hoeveelheden informatie over een collectie toegankelijk en kunnen we uitgebreide rapportages uitdraaien.
De applicatie wordt continu doorontwikkeld om de gebruiksvriendelijkheid ervan te vergroten.

## Installatie

De meest actuele versie van deze handleiding zal altijd terug te vinden zijn in de source code (README.md).

### Server

Zorg voor een server die in staat is om Rails applicaties te draaien. De QKunst Collectiedatabase draait op een Debian Jessie server met voorgeïnstalleerd de volgende zaken:

* postgresql
* nginx
* imagemagick
* elasticsearch
* passenger
* Ruby 2.3.3 (geïnstalleerd via rbenv)

Ruby wordt geïnstalleerd via rbenv, dit is een systeem om verschillende ruby-versies te kunnen ondersteunen. Installatie instructies hiervoor zijn te vinden op de [rbenv-soursecode pagina](https://github.com/rbenv/rbenv)

Op het moment van schrijven worden de volgende repositories hiervoor geraadpleegd:

    deb http://debian.directvps.nl/debian jessie main
    deb http://debian.directvps.nl/security jessie/updates main
    deb http://packages.elastic.co/elasticsearch/1.7/debian stable main
    deb https://oss-binaries.phusionpassenger.com/apt/passenger jessie main

Op ElasticSearch en Passenger na worden dus de standaard door Debian geleverde versies gehanteerd, dagelijks automatisch voorzien van veiligheidsupdates. Voor een basis inrichting kan het volgende artikel worden geraadpleegd:

* [Basis server inrichting handleiding voor Rails op basis van Debian, nginx, passenger en rbenv](https://murb.nl/articles/204-a-somewhat-secure-debian-server-with-nginx-passenger-rbenv-for-hosting-ruby-on-rails-with-mail-support-and-deployment-with-capistrano)

### Over versies & OTAP

Er is een ontwikkelstraat, een teststraat, een acceptatie-straat en een productiestraat.

De code zelf staat in een git-repository. Deze kent twee branches, develop en master, en waar nodig tijdelijke feature branches. De code op de develop branch wordt geïnstalleerd op de staging server, de master branch wordt na goedkeuring van de werking door QKunst geïnstalleerd op de applicatie server voor productie.

De code in develop wordt ook gebruikt om actief in te ontwikkelen en te testen.

Er worden geen versienummers toegekend, de applicatie is in principe continue in ontwikkeling. Er kan gecommuniceerd worden over de geïnstalleerde versie dmv commit ids, een lange string die op basis van datum en tijd en omgeving gemakkelijk teruggevonden kan worden in het deployment logboek dat automatisch door de deployment-tool wordt bijgehouden.

Updates van de applicatie worden uitgevoerd middels Capistrano. Door gebruik te maken van Capistrano kunnen updates op de acceptatie en productie omgevingen bijna onmerkbaar uitgevoerd worden.

### Installatie van de applicatie

Voordat de applicatie in een serveromgeving gestart kan worden dient de connectie met de database server geconfigureerd worden. Dit kan in het bestand database.yml. Daarnaast dient een bestand met veiligheidscodes aangemaakt te worden, secrets.yml.

Meer over het configureren van Rails applicaties, zoals deze, raadpleeg de Rails documentatie: [Configuring Rails Applications](http://guides.rubyonrails.org/configuring.html).

### Aanmaken van een eerste admin gebruiker

Doorloop de reguliere registratie methode, en open op de server vervolgens de console:

`rails c [environment_name]`

Type vervolgens de volgende commando's:

    u = User.where(email: jouw_email).first
    u.admin = true
    u.save

De gebruiker met 'jouw_email' als e-mailadres kan vervolgens andere gebruikers administrator rechten geven etc.

### Starten van de applicatie

Rails komt standaard met een ingebouwde server, die gestart kan worden met `rails s [environment_name]` Deze server is niet geschikt voor productie. Zie daarvoor de eerder genoemde handleiding: [Basis server inrichting handleiding voor Rails op basis van Debian, nginx, passenger en rbenv](https://murb.nl/articles/204-a-somewhat-secure-debian-server-with-nginx-passenger-rbenv-for-hosting-ruby-on-rails-with-mail-support-and-deployment-with-capistrano).

### De applicatie draaien op andere omgevingen.

Rails bied ook ondersteuning voor andere databases, en draait ook op diverse servers-typen. We testen echter niet actief in andere omgevingen dan de hierboven beschreven omgeving.

## Backup

### Herstellen met een databasebackup

Er wordt dagelijks een pg_dump gedaan van alle informatie in de database. Deze wordt beveiligd opgeslagen en verstuurd op de server en bij QKunst en bij de leverancier. Deze backups zijn niet te gebruiken door een enkele afnemer van de QKunst collectiedatabase omdat deze informatie bevat van alle klanten. Wel is deze backup te gebruiken om een backup terug te halen.

### Herstellen met een export

Eigenaren van een collectie kunnen een export maken (een excel bestand en een zip bestand met alle foto's). Deze export kan vervolgens gebruikt worden om collectie opnieuw te importeren middels de standaard import functie.
Toegangsrechten dienen wel opnieuw ingesteld te worden.

## API

### Token based authentication

To authenticate the user has to send a token-header with every request, a token that is a bcrypted string representing
the external ip, the url and the secret api key:

    data = "#{self.externalip}#{url}#{method}#{request_body}"
    user_id # known user id; send as header HTTP_API_USER_ID
    api_key # shared key

    digest = OpenSSL::Digest.new('sha512')
    hmac_token = OpenSSL::HMAC.hexdigest(digest, api_key, data) # send as HTTP_HMAC_TOKEN

To make the full request in ruby:

    data = "#{external_ip}#{url}"
    digest = OpenSSL::Digest.new('sha512')
    hmac_token = OpenSSL::HMAC.hexdigest(digest, api_key, data)

    uri = URI(url)
    req = Net::HTTP::Get.new(uri)
    req['api_user_id'] = user_id
    req['hmac_token'] = hmac_token
    res = Net::HTTP.start(uri.hostname, uri.port) {|http| http.request(req) }
    response_data = JSON.parse(res.body)

