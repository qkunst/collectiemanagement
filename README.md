# QKunst Collectiemanagement

[![Maintainability](https://api.codeclimate.com/v1/badges/bcc22238a6f328ddc58c/maintainability)](https://codeclimate.com/github/qkunst/collectiemanagement/maintainability)

Dit is de broncode van de QKunst Collectiemanagement applicatie, vrijgegeven onder een AGPL (GNU Affero General Public License v3.0) opensource licentie. Zie ook [LICENSE](LICENSE).
Deze web applicatie stelt u in staat om kunstwerken binnen uw collectie te bekijken en, afhankelijk van de u toegewezen rol, te beheren.

## Over QKunst Collectiemanagement

[QKunst](http://qkunst.nl) is gespecialiseerd in het inventariseren van grote bedrijfscollecties. Om deze inventarisaties
nog soepeler te laten verlopen ontwikkelden wij QKunst Collectiemanagement, een web applicatie voor collectiemanagement.
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
* *tag\_list:hond* zorgt ervoor dat er gezocht wordt in enkel het veld tag\_list (de lijst met tags); merk op dat dit ook matched op 'honden' (niet zo strict dus als tags normaliter zijn)

Geavanceerd voorbeeld:

> "tag\_list:h?nd OR tag\_list:vog*"

Zoekt dus naar werken met in de lijst van tags "hond", of "hand", of "vogel" of "vogelverschrikker"

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

## Browser support

Er is een browser support grading systeem, geïnspireerd op [How to define a browser support level matrix](https://medium.com/planet4/how-to-define-a-browser-support-level-matrix-54624d3b5250)), voor browserondersteuning. We classificeren browsers met een A, B, C of D.

| Klasse | Omschrijving |
|-------|:------|
| A | Beste gebruikerservaring; alle features werken en weergave is duidelijk. |
| B | Alle features werken. Weergave niet altijd optimaal. |
| C | Basis functionaliteit werkt (in ieder geval rollen buiten controle (b.v. niet-admin functies)), maar geavanceerdere functies zijn niet altijd beschikbaar. Performance mogelijk niet optimaal. |
| D | Wordt niet ondersteund. |

### Klasse A Browsers:

* Google Chrome op Desktop (laatste en op één na laatste versie)
* Microsoft Edge op Desktop (laatste en op één na laatste versie)
* Mozilla Firefox op Desktop (laatste en op één na laatste versie)
* Apple Safari op Desktop (laatste versie)

### Klasse B Browsers:

* Apple Safari op iOS (laatste versie)
* Google Chrome op Android (laatste versie)
* Mozilla Firefox op Android (laatste versie)

### Klasse C Browsers:

* Microsoft Edge Legacy op Desktop (laatste versie)

### Klasse D Browsers:

* Microsoft Internet Explorer 11 op Desktop (per juni 2022 zal Micrsoft ook geen onderhoud meer plegen aan deze browser, door Microsoft producten wordt deze browser ook al niet meer ondersteund)

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

Zorg voor een server die in staat is om Rails applicaties te draaien. De QKunst Collectiedatabase draait op moment van schrijven op een Debian Buster server met voorgeïnstalleerd de volgende zaken:

* postgresql
* nginx
* imagemagick jpegoptim optipng
* elasticsearch 7
* passenger
* systemd
* redis
* node >= 10.21 met yarn (geïnstalleerd met nvm)
* Ruby 3.0.4 (geïnstalleerd via rbenv)

Installeer met `sudo apt-get install jpegoptim optipng imagemagick nginx postgresql`

Ruby wordt geïnstalleerd via rbenv, dit is een systeem om verschillende ruby-versies te kunnen ondersteunen. Installatie instructies hiervoor zijn te vinden op de [rbenv source code pagina](https://github.com/rbenv/rbenv).

Op het moment van schrijven worden de volgende repositories hiervoor geraadpleegd:

    deb http://debian.directvps.nl/debian jessie main
    deb http://debian.directvps.nl/security jessie/updates main
    deb http://ppa.launchpad.net/webupd8team/java/ubuntu precise main # let op: voeg key toe: apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886
    deb https://artifacts.elastic.co/packages/7.x/apt stable main
    deb https://oss-binaries.phusionpassenger.com/apt/passenger jessie main

Op ElasticSearch en Passenger na worden dus de standaard door Debian geleverde versies gehanteerd en alle server pakketten worden dagelijks automatisch voorzien van veiligheidsupdates. Voor een basis inrichting kan het volgende artikel worden geraadpleegd:

* [Basis server inrichting handleiding voor Rails op basis van Debian, nginx, passenger en rbenv](https://murb.nl/articles/204-a-somewhat-secure-debian-server-with-nginx-passenger-rbenv-for-hosting-ruby-on-rails-with-mail-support-and-deployment-with-capistrano)

#### PDF generatie via Puppeteer

Puppeteer wordt geïnstalleerd via yarn. Puppeteer is echter afhankelijk van Chromium, waarvan een binary ook via yarn wordt geïnstalleerd. Voor het sandboxed draaien van Chromium is het van belang de meegeleverde chrome-sandbox executable beschikbaar te maken; draai daarvoor middels `sudo ./bin/copy-chrome-sandbox-for-puppeteer` eenmalig.

Chromium kan (ook via yarn) niet worden geïnstalleerd als de volgende packages niet beschikbaar zijn op het host-systeem:

`sudo apt-get install libnss3 libnspr4 libatk1.0-0 libatk-bridge2.0-0 libdrm2 libxkbcommon0 libxcomposite1 libxdamage1 libxfixes3 libxrandr2 libgbm1 libasound2`

#### Database extensions

`tablefunc` is nodig voor het navigeren door de boom van collecties:

    enable_extension "tablefunc" #    CREATE EXTENSION IF NOT EXISTS tablefunc;

#### Sidekiq in usermode

Sidekiq is in een achtergrondproces dat taken asynchroon uitvoert. Het draait in dezelfde user environment als de gebruiker, hiervoor is het noodzakelijk dat de gebruiker achtergrond services mag starten

    loginctl enable-linger qkunst && loginctl -

### Inrichting ontwikkelomgeving

Verondersteld wordt dat `git` en alle andere eerder genoemde server software aanwezig is op het ontwikkelsysteem (op nginx en passenger na).

Op macOS kunnen deze pakketten eventueel ook via homebrew worden geïnstalleerd. Of de applicatie op Windows zou kunnen draaien is onduidelijk. Een *nix-achtig systeem wordt (eigenlijk altijd) aanbevolen.

Clone de repository:

    git clone https://github.com/qkunst/collectiemanagement.git

De commando's die volgen worden allemaal uitgevoerd in de project folder, dus
navigeer hier naartoe (`cd collectiemanagement`)

#### Installatie afhankelijkheden

De QKunst collectiedatabase is gebaseerd op het Ruby On Rails framework en andere opensource bibliotheken, zogenaamde gems. Deze zijn gemakkelijk te installeren middels het `bundler` commando:

    bundle install

Is het commando `bundle` niet aanwezig op het systeem, typ dan eerst `gem install bundler`.

#### Niet-ruby afhankelijkheden

De applicatie gebruikt naast rubygems ook diverse andere zaken:

* ElasticSearch voor zoeken en rapportages
* Redis voor achtergrond processen
* PostgreSQL als database

ElasticSearch wordt standaard gestart met Docker.

#### Inrichting van de database

Het Ruby on Rails framework komt met een ingebouwd migratiesysteem om een volledige database in te richten. Hiervoor dient de connectie met de database server geconfigureerd worden. Dit kan in het bestand `database.yml`.
Na configuratie dient het volgende commando uitgevoerd te worden:

    RAILS_ENV=production rails db:migrate

Het bestand [`db/schema.rb`](db/schema.rb) kan geraadpleegd worden om een indruk te krijgen van alle tabellen.

#### Applicatie starten

De applicatie kan nu gestart worden middels het commando

    foreman start

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


## Ontwikkelen

### Afhankelijkheden



#### Elastic Search

curl -X GET "localhost:9200"
curl -X PUT "localhost:9200/_settings" -H 'Content-Type: application/json' -d '{ "index" : { "max_result_window" : 5000000 } }'
curl -X PUT "localhost:9200/_settings" -H 'Content-Type: application/json' -d'{"index": {"blocks": {"read_only_allow_delete": "false"}}}'

curl -X GET "elastic:PleaseChangeMe@localhost:59200"
curl -X PUT "elastic:PleaseChangeMe@localhost:59200/_settings" -H 'Content-Type: application/json' -d '{ "index" : { "max_result_window" : 5000000 } }'
curl -X PUT "elastic:PleaseChangeMe@localhost:59200/_settings" -H 'Content-Type: application/json' -d'{"index": {"blocks": {"read_only_allow_delete": "false"}}}'

