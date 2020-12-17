# Export

## EDM XML Export

Er wordt gewerkt aan het mappen van de collectiedata linked XML / RDF gegevens volgens de [European Data Model](https://pro.europeana.eu/page/edm-documentation), een Europese aanbeveling voortkomend uit [Europeana](https://www.europeana.eu/en).

### edm:ProvidedCHO

Het eigenlijke werk

| tag | beschrijving | cardinaliteit |
|---|---|---|
| dc:title | Titel kunstwerk | 0..1 |
| dcterms:alternative | Beschrijving kunstwerk (veelal bij gebrek aan titel) | 0..1 |
| dc:description | Publieke beschrijving | 0..1 |
| dc:identifier | Identifiers, zie scheme voor type nummer | 1..4 |
| dcterms:creator > edm:Agent | Creator; specificatie hieronder | 0..n |
| dc:subject | Freeform tags | 0..1 |
| qkunst:photo_file_name | photo file name | 0..6 |
| dc:type | Type of artworks | 0..n |
| qkunst:techniques | Techniques (no AAT) | 0..n |
| edm:hasMet | Location | 0..n |

### edm:Agent

Vervaardiger

| tag | beschrijving | cardinaliteit |
|---|---|---|
| skos:prefLabel | name | 0..1 |
| edm:begin | date of birth | 0..1|
| edm:end | date of death | 0..1|
| rdau:P60599  | date of birth | 0..1|
| rdau:P60598  | date of death | 0..1|
| dc:identifier | RKD Artist ID | 0..1 |
| rdau:P60594 | place of birth | 0..1|
| rdau:P60592 | place of death | 0..1|


## XLSX Export

Next to XML Export we offer Excel downloads.

## API Export

To describe.