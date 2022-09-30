# Test report QKunst Collectiemanagement

Date: 2022-09-30 17:42:37 +0200

This report gives an overview of the test ran. This report is automatically created.

## Statistics

In total **55.34%** of the lines are covered by automated test. The code base consists of **11747** lines of code.

## Abilities

As a general note: except for administrators, user access is limited to a a selected set of collections.

### General abilities

This lists what a user can do per object-type.

|-|Administrator | Kunstadviseur | Compliance | Registrator | Taxateur | Facility Manager | Facility Manager Support | Read-only|
|-|---|---|---|---|---|---|---|---|
|**Alles**||
|*Beheren*|✔|✘|✘|✘|✘|✘|✘|✘|
|*Beheer (inclusief aanmaken) collectie in collectie-context*|✔|✔|✘|✘|✘|✘|✘|✘|
|*Overzicht tonen in collectie-context*|✔|✔|✘|✘|✘|✘|✘|✘|
|*Toon gebruikers binnen de collectie*|✔|✔|✘|✘|✘|✘|✘|✘|
|*Bewerk collectie in collectie-context*|✔|✔|✘|✘|✘|✘|✘|✘|
|**Rapport**||
|*Beheren*|✔|✘|✘|✘|✘|✘|✘|✘|
|*Beheer (inclusief aanmaken) collectie in collectie-context*|✔|✔|✘|✘|✘|✘|✘|✘|
|*Overzicht tonen in collectie-context*|✔|✔|✔|✘|✘|✘|✘|✘|
|*Toon gebruikers binnen de collectie*|✔|✔|✘|✘|✘|✘|✘|✘|
|*Bewerk collectie in collectie-context*|✔|✔|✘|✘|✘|✘|✘|✘|
|*Aanmaken*|✔|✔|✘|✘|✘|✘|✘|✘|
|*Zien*|✔|✔|✔|✘|✔|✘|✘|✘|
|*Bijwerken*|✔|✔|✘|✘|✘|✘|✘|✘|
|**Bericht**||
|*Beheren*|✔|✘|✘|✘|✘|✘|✘|✘|
|*Zien*|✔|✔|✔|✔|✔|✔|✔|✔|
|*Aanmaken*|✔|✔|✔|✘|✔|✔|✘|✘|
|*Bijwerken*|✔|✔|✘|✘|✘|✘|✘|✘|
|*Markeer als voltooid*|✔|✔|✘|✘|✘|✘|✘|✘|
|*Status inzien*|✔|✘|✘|✘|✘|✔|✘|✘|
|**Eigenaar**||
|*Beheren*|✔|✔|✘|✘|✔|✘|✘|✘|
|*Zien*|✔|✔|✔|✘|✔|✔|✘|✘|
|*Overzicht tonen in collectie-context*|✔|✔|✔|✘|✔|✘|✘|✘|
|**Bibliotheek item**||
|*Beheren*|✔|✔|✘|✘|✘|✘|✘|✘|
|*Zien*|✔|✔|✔|✔|✔|✔|✘|✘|
|*Aanmaken*|✔|✔|✘|✔|✔|✘|✘|✘|
|*Bijwerken*|✔|✔|✘|✔|✔|✘|✘|✘|
|**Collectie**||
|*Beheren*|✔|✘|✘|✘|✘|✘|✘|✘|
|*Beheer (inclusief aanmaken) collectie in collectie-context*|✔|✔|✘|✘|✘|✘|✘|✘|
|*Overzicht tonen in collectie-context*|✔|✔|✔|✘|✘|✘|✘|✘|
|*Toon gebruikers binnen de collectie*|✔|✔|✔|✘|✘|✘|✘|✘|
|*Bewerk collectie in collectie-context*|✔|✔|✘|✘|✘|✘|✘|✘|
|*Filteren van rapportages*|✔|✔|✘|✔|✘|✘|✘|✘|
|*translation missing: nl.abilities.read_cluster_report*|✔|✔|✔|✔|✔|✘|✔|✘|
|*API toegang (alleen lezen)*|✔|✔|✔|✔|✔|✔|✘|✘|
|*Toegang tot API aanmaken van gebeurtenissen*|✔|✔|✘|✔|✔|✔|✘|✘|
|*Toegang tot de batch-editor*|✔|✔|✘|✔|✔|✔|✘|✘|
|*Kan foto's downloaden*|✔|✔|✔|✘|✘|✔|✘|✘|
|*Kan gegevens downloaden*|✔|✔|✔|✘|✘|✘|✘|✘|
|*Kan PDF downloaden*|✔|✔|✔|✘|✘|✔|✘|✘|
|*Kan publieke gegevens downloaden*|✔|✔|✔|✘|✘|✘|✘|✘|
|*Kan waardering zien*|✔|✔|✔|✘|✘|✘|✘|✘|
|*Rapportage lezen*|✔|✔|✔|✔|✔|✔|✔|✘|
|*Uitgebreide rapportage lezen*|✔|✔|✔|✔|✔|✘|✘|✘|
|*Waardering zien*|✔|✔|✔|✘|✔|✔|✘|✘|
|*Status inzien*|✔|✔|✔|✔|✔|✔|✘|✘|
|*Waarderingsreferentie lezen*|✔|✔|✘|✘|✔|✘|✘|✘|
|*Zoekmachine verversen*|✔|✔|✘|✔|✔|✘|✘|✘|
|*Status bijwerken*|✔|✔|✘|✘|✘|✘|✘|✘|
|*Toon gewijzigde werken*|✔|✔|✔|✘|✘|✔|✘|✘|
|*Verwijderen*|✔|✔|✘|✘|✘|✘|✘|✘|
|*Aanmaken*|✔|✔|✘|✘|✘|✘|✘|✘|
|*Zien*|✔|✔|✔|✔|✔|✔|✔|✔|
|*Bijwerken*|✔|✔|✘|✘|✘|✘|✘|✘|
|*Toegang tot beheer*|✔|✔|✔|✘|✘|✘|✘|✘|
|**Gebruiker**||
|*Beheren*|✔|✘|✘|✘|✘|✘|✘|✘|
|*Verwijderen*|✔|✘|✘|✘|✘|✘|✘|✘|
|*Administrator rol toekennen*|✔|✘|✘|✘|✘|✘|✘|✘|
|*Zien*|✔|✘|✔|✘|✘|✘|✘|✘|
|*Overzicht tonen in collectie-context*|✔|✔|✔|✘|✘|✘|✘|✘|
|**Werkgroepering**||
|*Beheren*|✔|✘|✘|✘|✘|✘|✘|✘|
|*Tonen buiten collectie-context*|✔|✘|✘|✘|✘|✘|✘|✘|
|*Aanmaken*|✔|✔|✘|✔|✔|✘|✘|✘|
|*Zien*|✔|✔|✔|✔|✔|✘|✘|✘|
|*Bijwerken*|✔|✔|✘|✔|✔|✘|✘|✘|
|*Verwijderen*|✔|✔|✘|✘|✔|✘|✘|✘|
|**Vervaardiger**||
|*Opschonen*|✔|✘|✘|✘|✘|✘|✘|✘|
|*Combineren*|✔|✘|✘|✘|✘|✘|✘|✘|
|*Beheer (inclusief aanmaken) collectie in collectie-context*|✔|✔|✘|✔|✔|✘|✘|✘|
|*Overzicht tonen in collectie-context*|✔|✔|✔|✔|✔|✘|✘|✘|
|*Toon gebruikers binnen de collectie*|✔|✔|✘|✔|✔|✘|✘|✘|
|*Bewerk collectie in collectie-context*|✔|✔|✘|✔|✔|✘|✘|✘|
|*Aanmaken*|✔|✔|✘|✔|✔|✘|✘|✘|
|*Zien*|✔|✔|✔|✔|✔|✔|✔|✔|
|*Bijwerken*|✔|✔|✘|✔|✔|✘|✘|✘|
|**Cluster**||
|*Beheer (inclusief aanmaken) collectie in collectie-context*|✔|✔|✘|✘|✘|✘|✘|✘|
|*Overzicht tonen in collectie-context*|✔|✔|✔|✘|✘|✘|✘|✘|
|*Toon gebruikers binnen de collectie*|✔|✔|✘|✘|✘|✘|✘|✘|
|*Bewerk collectie in collectie-context*|✔|✔|✘|✘|✘|✘|✘|✘|
|*Beheren*|✔|✔|✘|✘|✘|✘|✘|✘|
|**RKD Artist**||
|*Zien*|✔|✔|✔|✔|✔|✘|✘|✘|
|*Kopieer*|✔|✔|✘|✔|✔|✘|✘|✘|
|**Gebeurtenis**||
|*Zien*|✔|✔|✔|✔|✔|✔|✘|✘|
|**Bijlage**||
|*Pas zichtbaarheid aan*|✔|✔|✘|✘|✘|✘|✘|✘|
|*Bijwerken*|✔|✔|✘|✔|✔|✘|✘|✘|
|*Beheren*|✔|✔|✘|✘|✘|✘|✘|✘|
|*Zien*|✔|✔|✔|✔|✔|✘|✘|✘|
|*Aanmaken*|✔|✔|✘|✔|✔|✘|✘|✘|
|**Werk**||
|*API toegang (alleen lezen)*|✔|✔|✘|✘|✘|✘|✘|✘|
|*Toon conditie*|✔|✔|✔|✔|✔|✔|✘|✘|
|*Foto's bewerken*|✔|✔|✘|✔|✔|✘|✘|✘|
|*Kan herkomst bewerken (& inzien)*|✔|✔|✘|✔|✔|✘|✘|✘|
|*Toon informatie achterzijde*|✔|✔|✔|✔|✔|✔|✘|✘|
|*Aanmaken*|✔|✔|✘|✔|✔|✘|✘|✘|
|*Wijzig interne opmerkingen*|✔|✔|✔|✔|✔|✘|✘|✘|
|*Toon interne opmerkingen*|✔|✔|✘|✔|✔|✘|✘|✘|
|*Beheer locatie*|✔|✔|✘|✔|✔|✔|✘|✘|
|*Toon locatie*|✔|✔|✔|✔|✔|✔|✔|✘|
|*Bewerk locatie*|✔|✔|✘|✔|✔|✔|✘|✘|
|*Taggen*|✔|✔|✘|✔|✔|✘|✘|✘|
|*Toon locatiegeschiedenis*|✔|✔|✔|✔|✔|✔|✘|✘|
|*Details tonen*|✔|✔|✔|✔|✔|✔|✘|✘|
|*Zien*|✔|✔|✔|✔|✔|✔|✔|✔|
|*Bijwerken*|✔|✔|✘|✘|✘|✘|✘|✘|
|*Toegang tot API aanmaken van gebeurtenissen*|✔|✔|✘|✘|✘|✘|✘|✘|
|*Status inzien*|✔|✔|✔|✔|✔|✘|✘|✘|
|*Bewerk beschikbaarheid*|✔|✔|✘|✘|✘|✘|✘|✘|
|*Kan aankoopgegevens bewerken (& inzien)*|✔|✔|✘|✘|✔|✘|✘|✘|
|*Toon status*|✔|✘|✘|✘|✘|✔|✘|✘|
|**Vervaardigersbetrekking**||
|*Aanmaken*|✔|✔|✘|✔|✔|✘|✘|✘|
|*Zien*|✔|✔|✘|✘|✘|✘|✘|✘|
|*Bijwerken*|✔|✔|✘|✔|✔|✘|✘|✘|
|**Waardering**||
|*Aanmaken*|✔|✔|✘|✘|✔|✘|✘|✘|
|*Zien*|✔|✔|✔|✘|✔|✘|✘|✘|
|*Bijwerken*|✔|✔|✘|✘|✔|✘|✘|✘|
|**Contact**||
|*Beheren*|✔|✔|✘|✘|✘|✘|✘|✘|
|*Zien*|✔|✔|✔|✘|✘|✘|✘|✘|
|**Import**||
|*Zien*|✔|✘|✔|✘|✘|✘|✘|✘|
|*Overzicht tonen in collectie-context*|✔|✘|✔|✘|✘|✘|✘|✘|
|**Herinnering**||
|*Zien*|✔|✘|✔|✘|✘|✘|✘|✘|
|*Overzicht tonen in collectie-context*|✔|✔|✔|✘|✘|✘|✘|✘|
|**Thema**||
|*Overzicht tonen in collectie-context*|✔|✔|✔|✘|✘|✘|✘|✘|

### Write access

This is a list of fields a user can write to

|-|Administrator | Kunstadviseur | Compliance | Registrator | Taxateur | Facility Manager | Facility Manager Support | Read-only|
|-|---|---|---|---|---|---|---|---|
|**works_attributes**||
|*location_detail*|✔|✔|✘|✔|✔|✔|✘|✘|
|*location*|✔|✔|✘|✔|✔|✔|✘|✘|
|*location_floor*|✔|✔|✘|✔|✔|✔|✘|✘|
|*work_status_id*|✔|✔|✘|✔|✔|✔|✘|✘|
|*internal_comments*|✔|✔|✘|✔|✔|✘|✘|✘|
|*photo_front*|✔|✔|✘|✔|✔|✘|✘|✘|
|*photo_back*|✔|✔|✘|✔|✔|✘|✘|✘|
|*photo_detail_1*|✔|✔|✘|✔|✔|✘|✘|✘|
|*photo_detail_2*|✔|✔|✘|✔|✔|✘|✘|✘|
|*remove_photo_front*|✔|✔|✘|✔|✔|✘|✘|✘|
|*remove_photo_back*|✔|✔|✘|✔|✔|✘|✘|✘|
|*remove_photo_detail_1*|✔|✔|✘|✔|✔|✘|✘|✘|
|*remove_photo_detail_2*|✔|✔|✘|✔|✔|✘|✘|✘|
|*inventoried*|✔|✔|✘|✔|✔|✘|✘|✘|
|*refound*|✔|✔|✘|✔|✔|✘|✘|✘|
|*new_found*|✔|✔|✘|✔|✔|✘|✘|✘|
|*locality_geoname_id*|✔|✔|✘|✔|✔|✘|✘|✘|
|*imported_at*|✔|✔|✘|✔|✔|✘|✘|✘|
|*import_collection_id*|✔|✔|✘|✔|✔|✘|✘|✘|
|*stock_number*|✔|✔|✘|✔|✔|✘|✘|✘|
|*alt_number_1*|✔|✔|✘|✔|✔|✘|✘|✘|
|*alt_number_2*|✔|✔|✘|✔|✔|✘|✘|✘|
|*alt_number_3*|✔|✔|✘|✔|✔|✘|✘|✘|
|*artist_unknown*|✔|✔|✘|✔|✔|✘|✘|✘|
|*title*|✔|✔|✘|✔|✔|✘|✘|✘|
|*title_unknown*|✔|✔|✘|✔|✔|✘|✘|✘|
|*description*|✔|✔|✘|✔|✔|✘|✘|✘|
|*object_creation_year*|✔|✔|✘|✔|✔|✘|✘|✘|
|*object_creation_year_unknown*|✔|✔|✘|✔|✔|✘|✘|✘|
|*medium_id*|✔|✔|✘|✔|✔|✘|✘|✘|
|*frame_type_id*|✔|✔|✘|✔|✔|✘|✘|✘|
|*signature_comments*|✔|✔|✘|✔|✔|✘|✘|✘|
|*no_signature_present*|✔|✔|✘|✔|✔|✘|✘|✘|
|*print*|✔|✔|✘|✔|✔|✘|✘|✘|
|*print_unknown*|✔|✔|✘|✔|✔|✘|✘|✘|
|*frame_height*|✔|✔|✘|✔|✔|✘|✘|✘|
|*frame_width*|✔|✔|✘|✔|✔|✘|✘|✘|
|*frame_depth*|✔|✔|✘|✔|✔|✘|✘|✘|
|*frame_diameter*|✔|✔|✘|✔|✔|✘|✘|✘|
|*height*|✔|✔|✘|✔|✔|✘|✘|✘|
|*width*|✔|✔|✘|✔|✔|✘|✘|✘|
|*depth*|✔|✔|✘|✔|✔|✘|✘|✘|
|*diameter*|✔|✔|✘|✔|✔|✘|✘|✘|
|*condition_work_id*|✔|✔|✘|✔|✔|✘|✘|✘|
|*condition_work_comments*|✔|✔|✘|✔|✔|✘|✘|✘|
|*condition_frame_id*|✔|✔|✘|✔|✔|✘|✘|✘|
|*condition_frame_comments*|✔|✔|✘|✔|✔|✘|✘|✘|
|*information_back*|✔|✔|✘|✔|✔|✘|✘|✘|
|*other_comments*|✔|✔|✘|✔|✔|✘|✘|✘|
|*subset_id*|✔|✔|✘|✔|✔|✘|✘|✘|
|*public_description*|✔|✔|✘|✔|✔|✘|✘|✘|
|*grade_within_collection*|✔|✔|✘|✔|✔|✘|✘|✘|
|*entry_status*|✔|✔|✘|✔|✔|✘|✘|✘|
|*entry_status_description*|✔|✔|✘|✔|✔|✘|✘|✘|
|*abstract_or_figurative*|✔|✔|✘|✔|✔|✘|✘|✘|
|*medium_comments*|✔|✔|✘|✔|✔|✘|✘|✘|
|*main_collection*|✔|✔|✘|✔|✔|✘|✘|✘|
|*image_rights*|✔|✔|✘|✔|✔|✘|✘|✘|
|*publish*|✔|✔|✘|✔|✔|✘|✘|✘|
|*cluster_name*|✔|✔|✘|✔|✔|✘|✘|✘|
|*collection_id*|✔|✔|✘|✔|✔|✘|✘|✘|
|*cluster_id*|✔|✔|✘|✔|✔|✘|✘|✘|
|*owner_id*|✔|✔|✘|✔|✔|✘|✘|✘|
|*permanently_fixed*|✔|✔|✘|✔|✔|✘|✘|✘|
|*placeability_id*|✔|✔|✘|✔|✔|✘|✘|✘|
|*artist_ids*|✔|✔|✘|✔|✔|✘|✘|✘|
|*damage_type_ids*|✔|✔|✘|✔|✔|✘|✘|✘|
|*frame_damage_type_ids*|✔|✔|✘|✔|✔|✘|✘|✘|
|*theme_ids*|✔|✔|✘|✔|✔|✘|✘|✘|
|*object_category_ids*|✔|✔|✘|✔|✔|✘|✘|✘|
|*technique_ids*|✔|✔|✘|✔|✔|✘|✘|✘|
|*source_comments*|✔|✔|✘|✔|✔|✘|✘|✘|
|*source_ids*|✔|✔|✘|✔|✔|✘|✘|✘|
|*purchase_price*|✔|✔|✘|✘|✔|✘|✘|✘|
|*purchased_on*|✔|✔|✘|✘|✔|✘|✘|✘|
|*purchase_year*|✔|✔|✘|✘|✔|✘|✘|✘|
|*fin_balance_item_id*|✔|✔|✘|✘|✔|✘|✘|✘|
|*for_rent*|✔|✔|✘|✘|✘|✘|✘|✘|
|*for_purchase*|✔|✔|✘|✘|✘|✘|✘|✘|
|*highlight*|✔|✔|✘|✘|✘|✘|✘|✘|
|*cluster*|✔|✔|✘|✘|✘|✘|✘|✘|
|*selling_price*|✔|✔|✘|✘|✔|✘|✘|✘|
|*minimum_bid*|✔|✔|✘|✘|✔|✘|✘|✘|
|*selling_price_minimum_bid_comments*|✔|✔|✘|✘|✔|✘|✘|✘|
|*purchase_price_currency_id*|✔|✔|✘|✘|✔|✘|✘|✘|
|*balance_category_id*|✔|✔|✘|✘|✔|✘|✘|✘|
|**artists_attributes**||
|*_destroy*|✔|✔|✘|✔|✔|✘|✘|✘|
|*first_name*|✔|✔|✘|✔|✔|✘|✘|✘|
|*last_name*|✔|✔|✘|✔|✔|✘|✘|✘|
|*prefix*|✔|✔|✘|✔|✔|✘|✘|✘|
|*place_of_birth*|✔|✔|✘|✔|✔|✘|✘|✘|
|*place_of_death*|✔|✔|✘|✔|✔|✘|✘|✘|
|*year_of_birth*|✔|✔|✘|✔|✔|✘|✘|✘|
|*year_of_death*|✔|✔|✘|✔|✔|✘|✘|✘|
|*description*|✔|✔|✘|✔|✔|✘|✘|✘|
|**appraisals_attributes**||
|*appraised_on*|✔|✔|✘|✘|✔|✘|✘|✘|
|*market_value*|✔|✔|✘|✘|✔|✘|✘|✘|
|*replacement_value*|✔|✔|✘|✘|✔|✘|✘|✘|
|*market_value_range*|✔|✔|✘|✘|✔|✘|✘|✘|
|*replacement_value_range*|✔|✔|✘|✘|✔|✘|✘|✘|
|*appraised_by*|✔|✔|✘|✘|✔|✘|✘|✘|
|*reference*|✔|✔|✘|✘|✔|✘|✘|✘|
|*notice*|✔|✔|✘|✘|✔|✘|✘|✘|


## Features

The feature specs cover the most important work flow. The test descriptions should be comprehensible for someone familiar with the application.

```

Import works
  as an admin from CSV
  and upload matching images

Admin can set reminders
  on a global level
  on collection-level

Admin can review
  modified works on collection level and work level

Manage attachments
  in context of collection, as advisor
    add attachment, change name
  in context of work, as advisor
    add existing attachment
  in context of artist, as advisor
    add new and couple existing attachment

Appraise works
  as appraiser
    cannot appraise work outside scope
    can appraise work using ranges
    cannot appraise a diptych at work level, but only at work set level
    can appraise work old style

Filter from report
  as an admin

Manage Collection
  as admin
    should open imports overview

Manage Collection
  as admin
    editing a collection
    creating a sub-collection

Pagination of works
  as QKunst  read only
    can paginate
  as QKunst  compliance
    can paginate

Signin in and out
  should sign in a regular user using password login
  should not allow password login as admin user
  should allow oauth login as admin user
  should allow oauth login as never oauthed admin user

Batch editor
  facility manager can scan works with batch editor
  move work to sub-collection in cluster
  appraise works
  open selection and start batch edit after
  open two selections and start batch edit after
  modify other attributes (happy flow)
  Specialized batch editors
    move work to subcollection in using the cluster-batch editor

Werken groeperen
  Advisor can group works
  Advisor add a work to an existing group
  Admin can remove a work from a group

Edit photos
  as QKunst regular user with collection
    can edit photo's
  as QKunst administrator
    can edit photo's
  as QKunst  appraiser
    can edit photo's
  as QKunst  advisor
    can edit photo's
  as QKunst  read only
    can not edit photo's
  as QKunst  compliance
    can not edit photo's

Edit tags
  as QKunst regular user with collection
    can edit tags
  as QKunst administrator
    can edit tags
  as QKunst  appraiser
    can edit tags
  as QKunst  advisor
    can edit tags

Navigate works
  read only
  registrator
  appraiser
  advisor
  compliance
  facility

Navigate works in a collection
  as QKunst  read only
    cannot edit anything
  as QKunst  compliance
    cannot edit anything
  as QKunst regular user with collection
    can edit work through main form
  as QKunst administrator
    can edit work through main form
  as QKunst  appraiser
    can edit work through main form
  as QKunst  advisor
    can edit work through main form
  as QKunst regular user with collection
    can edit location through location form
  as QKunst administrator
    can edit location through location form
  as QKunst  appraiser
    can edit location through location form
  as QKunst  advisor
    can edit location through location form
  as QKunst  facility manager
    can edit location through location form

User can send messages
  can mark message as completed
  qkunst-test-facility_manager@murb.nl
    can send messages
  qkunst-admin-user@murb.nl
    can send messages
  qkunst-test-appraiser@murb.nl
    can send messages
  qkunst-test-advisor@murb.nl
    can send messages
  qkunst-test-compliance@murb.nl
    can send messages

View report
  as an admin
  multi select
  as a facility manager (limited)
  as a facility manager support (limited)

Finished in 1 minute 1.45 seconds (files took 3.26 seconds to load)
69 examples, 0 failures


```

## Appendix A: Full test results

Full test results; only for reference.

```

ClustersController
  GET #index
    returns a success response when signed in as admin
  GET #show
    returns a success response when signed in as admin
  GET #new
    returns a success response
  GET #edit
    returns a success response
  POST #create
    with valid params
      creates a new Cluster
      redirects to the created cluster
    with invalid params
      returns a success response (i.e. to display the 'new' template)
  PUT #update
    with valid params
      updates the requested cluster
      redirects to the cluster
    with invalid params
      returns a success response (i.e. to display the 'edit' template)
  DELETE #destroy
    destroys the requested cluster
    redirects to the clusters list

CollectionsController
  DELETE #destroy
    without login
      doesn't destroy the requested Collection without login
      redirects to the sign up path when not logged in
    as regular user
      redirects to the root path when not allowed
    as admin
      can destroy the requested Collection
      doesn't destroy the requested Collection with admin login if it has works
      does destroy the requested Collection with admin login if it has works and a parent collection
    as advisor
      doesn't destroy a newly generated Collection with advisor login
      cannot destroy a collection the advisor has access to
      cannot destroy the a collection the advisor has no access to

CollectionsStagesController
  GET #update
    returns http success

CustomReportTemplatesController
  GET #index
    returns a success response
  GET #show
    returns a success response
  GET #new
    returns a success response
  GET #edit
    returns a success response
  POST #create
    with valid params
      creates a new CustomReportTemplate
      redirects to the created custom_report_template
    with invalid params
      returns a success response (i.e. to display the 'new' template)
  PUT #update
    with valid params
      updates the requested custom_report_template (PENDING: Add a hash of attributes valid for your model)
      redirects to the custom_report_template
    with invalid params
      returns a success response (i.e. to display the 'edit' template)
  DELETE #destroy
    destroys the requested custom_report_template
    redirects to the custom_report_templates list

CustomReportsController
  GET #index
    returns a success response
  GET #show
    returns a success response
  GET #new
    returns a success response
  GET #edit
    returns no success response by default
    returns success response when admin
  POST #create
    with valid params
      creates a new CustomReport
      redirects to the created custom_report
    with invalid params
      returns a success response (i.e. to display the 'new' template)
  PUT #update
    with valid params
      updates the requested custom_report
      redirects to the custom_report
    with invalid params
      returns a success response (i.e. to display the 'edit' template)
  DELETE #destroy
    destroys the requested custom_report
    redirects to the custom_reports list

InvolvementsController
  GET #index
    assigns all involvements as @involvements
  GET #show
    assigns the requested involvement as @involvement
  GET #new
    assigns a new involvement as @involvement
  GET #edit
    assigns the requested involvement as @involvement
  POST #create
    with valid params
      creates a new Involvement
      assigns a newly created involvement as @involvement
      redirects to the created involvement
    with invalid params
      assigns a newly created but unsaved involvement as @involvement
      re-renders the 'new' template
  PUT #update
    with valid params
      updates the requested involvement
      assigns the requested involvement as @involvement
      redirects to the involvement
    with invalid params
      assigns the involvement as @involvement
      re-renders the 'edit' template
  DELETE #destroy
    destroys the requested involvement
    redirects to the involvements list

MessagesController
  SHOW #messages
    should not show the message to no-user
    should show the message to the author
    should not show just a normal qkunst user
    should  show to a admin qkunst user (and mark message as read)
  PUT #update
    should allow an advisor to edit a message belonging to a collection he/she manages
    should not allow an advisor to edit a message not belonging to a collection he/she manages

OfflineController
  GET #work_form
    returns http success
  GET #offline
    returns http success
  GET #collection
    returns http success

Users::OmniauthCallbackData
  Validations
    returns invalid when no params given
    returns true when minimum params are given
    doesn't allow qkunst registrations for non qkunst
    does allow qkunst registrations for qkunst domain

UsersController
  GET /users
    is inaccessible by default
    is accessible for admins
    user1
      is inaccessible
    qkunst
      is inaccessible
    appraiser
      is inaccessible
    advisor
      is inaccessible
  PUT /users/:id
    allows for a advisor not to change a collection membership he/she is part of
    allows for an admin to change collection membership he/she is part of

Works::Filtering
  #set_selection_filter
    returns empty hash when none
    returns empty hash when none

WorksController
  PATCH/PUT #works
    shouldn't change anything by default
    shouldn't be change title when role == facility
    shouldn't be change location when role == facility
    qkunst admin should be able to edit all fields

Import works
  as an admin from CSV
  and upload matching images

Admin can set reminders
  on a global level
  on collection-level

Admin can review
  modified works on collection level and work level

Manage attachments
  in context of collection, as advisor
    add attachment, change name
  in context of work, as advisor
    add existing attachment
  in context of artist, as advisor
    add new and couple existing attachment

Appraise works
  as appraiser
    cannot appraise work outside scope
    can appraise work using ranges
    cannot appraise a diptych at work level, but only at work set level
    can appraise work old style

Filter from report
  as an admin

Manage Collection
  as admin
    should open imports overview

Manage Collection
  as admin
    editing a collection
    creating a sub-collection

Pagination of works
  as QKunst  read only
    can paginate
  as QKunst  compliance
    can paginate

Signin in and out
  should sign in a regular user using password login
  should not allow password login as admin user
  should allow oauth login as admin user
  should allow oauth login as never oauthed admin user

Batch editor
  facility manager can scan works with batch editor
  move work to sub-collection in cluster
  appraise works
  open selection and start batch edit after
  open two selections and start batch edit after
  modify other attributes (happy flow)
  Specialized batch editors
    move work to subcollection in using the cluster-batch editor

Werken groeperen
  Advisor can group works
  Advisor add a work to an existing group

Pending: (Failures listed here are expected and do not affect your suite's status)

  1) CustomReportTemplatesController PUT #update with valid params updates the requested custom_report_template
     # Add a hash of attributes valid for your model
     # ./spec/controllers/custom_report_templates_controller_spec.rb:114

Finished in 42.17 seconds (files took 5.29 seconds to load)
121 examples, 0 failures, 1 pending


```