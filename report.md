# Test report QKunst Collectiemanagement

Date: 2021-01-15 16:46:55 +0100

This report gives an overview of the test ran. This report is automatically created.

## Statistics

In total **93.81%** of the lines are covered by automated test. The code base consists of **10154** lines of code.

## Abilities

As a general note: except for administrators, user access is limited to a a selected set of collections.

### General abilities

This lists what a user can do per object-type.

|-|Administrator | Kunstadviseur | Compliance | Taxateur | Facility Manager | Read-only|
|-|---|---|---|---|---|---|
|**Alles**||
|*Beheren*|✔|✘|✘|✘|✘|✘|
|*Beheer (inclusief aanmaken) collectie in collectie-context*|✔|✔|✘|✘|✘|✘|
|*Overzicht tonen in collectie-context*|✔|✔|✘|✘|✘|✘|
|*Toon gebruikers binnen de collectie*|✔|✔|✘|✘|✘|✘|
|*Bewerk collectie in collectie-context*|✔|✔|✘|✘|✘|✘|
|**Rapport**||
|*Beheren*|✔|✘|✘|✘|✘|✘|
|*Beheer (inclusief aanmaken) collectie in collectie-context*|✔|✔|✘|✘|✘|✘|
|*Overzicht tonen in collectie-context*|✔|✔|✔|✘|✘|✘|
|*Toon gebruikers binnen de collectie*|✔|✔|✘|✘|✘|✘|
|*Bewerk collectie in collectie-context*|✔|✔|✘|✘|✘|✘|
|*Aanmaken & opslaan*|✔|✔|✘|✘|✘|✘|
|*Aanmaken*|✔|✔|✘|✘|✘|✘|
|*Lezen*|✔|✔|✔|✔|✘|✘|
|*Overzicht zien*|✔|✔|✔|✔|✘|✘|
|*Tonen*|✔|✔|✔|✔|✘|✘|
|*Bijwerken*|✔|✔|✘|✘|✘|✘|
|*Bewerken*|✔|✔|✘|✘|✘|✘|
|**Bericht**||
|*Beheren*|✔|✘|✘|✘|✘|✘|
|*Lezen*|✔|✔|✔|✔|✔|✔|
|*Overzicht zien*|✔|✔|✔|✔|✔|✔|
|*Tonen*|✔|✔|✔|✔|✔|✔|
|*Aanmaken & opslaan*|✔|✔|✔|✔|✔|✘|
|*Aanmaken*|✔|✔|✔|✔|✔|✘|
|*Bijwerken*|✔|✔|✘|✘|✘|✘|
|*Bewerken*|✔|✔|✘|✔|✘|✘|
|*Markeer als voltooid*|✔|✔|✘|✘|✘|✘|
|**Bibliotheek item**||
|*Beheren*|✔|✔|✘|✘|✘|✘|
|*Lezen*|✔|✔|✔|✔|✔|✘|
|*Overzicht zien*|✔|✔|✔|✔|✔|✘|
|*Tonen*|✔|✔|✔|✔|✔|✘|
|*Aanmaken & opslaan*|✔|✔|✘|✔|✘|✘|
|*Aanmaken*|✔|✔|✘|✔|✘|✘|
|*Bijwerken*|✔|✔|✘|✔|✘|✘|
|*Bewerken*|✔|✔|✘|✔|✘|✘|
|**Collectie**||
|*Beheren*|✔|✘|✘|✘|✘|✘|
|*Beheer (inclusief aanmaken) collectie in collectie-context*|✔|✔|✘|✘|✘|✘|
|*Overzicht tonen in collectie-context*|✔|✔|✔|✘|✘|✘|
|*Toon gebruikers binnen de collectie*|✔|✔|✔|✘|✘|✘|
|*Bewerk collectie in collectie-context*|✔|✔|✘|✘|✘|✘|
|*API toegang (alleen lezen)*|✔|✔|✘|✘|✘|✘|
|*Toegang tot de batch-editor*|✔|✔|✘|✔|✔|✘|
|*Kan foto's downloaden*|✔|✔|✔|✘|✔|✘|
|*Kan gegevens downloaden*|✔|✔|✔|✘|✘|✘|
|*Kan publieke gegevens downloaden*|✔|✔|✔|✘|✘|✘|
|*Kan waardering zien*|✔|✔|✔|✘|✘|✘|
|*Rapportage lezen*|✔|✔|✔|✔|✔|✘|
|*Uitgebreide rapportage lezen*|✔|✔|✔|✔|✘|✘|
|*Waardering zien*|✔|✔|✔|✔|✔|✘|
|*Status inzien*|✔|✔|✔|✔|✔|✘|
|*Waarderingsreferentie lezen*|✔|✔|✘|✔|✘|✘|
|*Zoekmachine verversen*|✔|✔|✘|✔|✘|✘|
|*Status bijwerken*|✔|✔|✘|✘|✘|✘|
|*Toon gewijzigde werken*|✔|✔|✔|✘|✘|✘|
|*Verwijderen*|✔|✔|✘|✘|✘|✘|
|*Aanmaken & opslaan*|✔|✔|✘|✘|✘|✘|
|*Aanmaken*|✔|✔|✘|✘|✘|✘|
|*Lezen*|✔|✔|✔|✔|✔|✔|
|*Overzicht zien*|✔|✔|✔|✔|✔|✔|
|*Tonen*|✔|✔|✔|✔|✔|✔|
|*Bijwerken*|✔|✔|✘|✘|✘|✘|
|*Bewerken*|✔|✔|✘|✘|✘|✘|
|*Toegang tot beheer*|✔|✔|✔|✘|✘|✘|
|**Gebruiker**||
|*Beheren*|✔|✘|✘|✘|✘|✘|
|*Verwijderen*|✔|✘|✘|✘|✘|✘|
|*Administrator rol toekennen*|✔|✘|✘|✘|✘|✘|
|*Lezen*|✔|✘|✔|✘|✘|✘|
|*Overzicht zien*|✔|✘|✔|✘|✘|✘|
|*Tonen*|✔|✘|✔|✘|✘|✘|
|*Overzicht tonen in collectie-context*|✔|✔|✔|✘|✘|✘|
|**Werkgroepering**||
|*Beheren*|✔|✘|✘|✘|✘|✘|
|*Tonen buiten collectie-context*|✔|✘|✘|✘|✘|✘|
|*Aanmaken & opslaan*|✔|✔|✘|✔|✘|✘|
|*Aanmaken*|✔|✔|✘|✔|✘|✘|
|*Lezen*|✔|✔|✔|✔|✘|✘|
|*Overzicht zien*|✔|✔|✔|✔|✘|✘|
|*Tonen*|✔|✔|✔|✔|✘|✘|
|*Bijwerken*|✔|✔|✘|✔|✘|✘|
|*Bewerken*|✔|✔|✘|✔|✘|✘|
|*Verwijderen*|✔|✔|✘|✔|✘|✘|
|**Vervaardiger**||
|*Opschonen*|✔|✘|✘|✘|✘|✘|
|*Combineren*|✔|✘|✘|✘|✘|✘|
|*Beheer (inclusief aanmaken) collectie in collectie-context*|✔|✔|✘|✔|✘|✘|
|*Overzicht tonen in collectie-context*|✔|✔|✔|✔|✘|✘|
|*Toon gebruikers binnen de collectie*|✔|✔|✘|✔|✘|✘|
|*Bewerk collectie in collectie-context*|✔|✔|✘|✔|✘|✘|
|*Aanmaken & opslaan*|✔|✔|✘|✔|✘|✘|
|*Aanmaken*|✔|✔|✘|✔|✘|✘|
|*Lezen*|✔|✔|✔|✔|✔|✔|
|*Overzicht zien*|✔|✔|✔|✔|✔|✔|
|*Tonen*|✔|✔|✔|✔|✔|✔|
|*Bijwerken*|✔|✔|✘|✔|✘|✘|
|*Bewerken*|✔|✔|✘|✔|✘|✘|
|**Cluster**||
|*Beheer (inclusief aanmaken) collectie in collectie-context*|✔|✔|✘|✘|✘|✘|
|*Overzicht tonen in collectie-context*|✔|✔|✔|✘|✘|✘|
|*Toon gebruikers binnen de collectie*|✔|✔|✘|✘|✘|✘|
|*Bewerk collectie in collectie-context*|✔|✔|✘|✘|✘|✘|
|*Beheren*|✔|✔|✘|✘|✘|✘|
|**Werk**||
|*API toegang (alleen lezen)*|✔|✔|✘|✘|✘|✘|
|*Foto's bewerken*|✔|✔|✘|✔|✘|✘|
|*Kan herkomst bewerken (& inzien)*|✔|✔|✘|✔|✘|✘|
|*Toon informatie achterzijde*|✔|✔|✔|✔|✔|✘|
|*Aanmaken & opslaan*|✔|✔|✘|✔|✘|✘|
|*Aanmaken*|✔|✔|✘|✔|✘|✘|
|*Wijzig interne opmerkingen*|✔|✔|✔|✔|✘|✘|
|*Toon interne opmerkingen*|✔|✔|✘|✔|✘|✘|
|*Beheer locatie*|✔|✔|✘|✔|✔|✘|
|*Toon locatie*|✔|✔|✔|✔|✔|✘|
|*Bewerk locatie*|✔|✔|✘|✔|✔|✘|
|*Taggen*|✔|✔|✘|✔|✘|✘|
|*Toon locatiegeschiedenis*|✔|✔|✔|✔|✔|✘|
|*Details tonen*|✔|✔|✔|✔|✔|✘|
|*Lezen*|✔|✔|✔|✔|✔|✔|
|*Overzicht zien*|✔|✔|✔|✔|✔|✔|
|*Tonen*|✔|✔|✔|✔|✔|✔|
|*Bijwerken*|✔|✔|✘|✘|✘|✘|
|*Bewerken*|✔|✔|✘|✔|✘|✘|
|*Kan aankoopgegevens bewerken (& inzien)*|✔|✔|✘|✔|✘|✘|
|**RKD Artist**||
|*Lezen*|✔|✔|✔|✔|✘|✘|
|*Overzicht zien*|✔|✔|✔|✔|✘|✘|
|*Tonen*|✔|✔|✔|✔|✘|✘|
|*Kopieer*|✔|✔|✘|✔|✘|✘|
|**Bijlage**||
|*Pas zichtbaarheid aan*|✔|✔|✘|✘|✘|✘|
|*Bijwerken*|✔|✔|✘|✔|✘|✘|
|*Bewerken*|✔|✔|✘|✔|✘|✘|
|*Aanmaken & opslaan*|✔|✔|✘|✔|✘|✘|
|*Aanmaken*|✔|✔|✘|✔|✘|✘|
|*Overzicht zien*|✔|✔|✔|✔|✘|✘|
|*Lezen*|✔|✘|✔|✘|✘|✘|
|*Tonen*|✔|✘|✔|✘|✘|✘|
|**Vervaardigersbetrekking**||
|*Aanmaken & opslaan*|✔|✔|✘|✔|✘|✘|
|*Aanmaken*|✔|✔|✘|✔|✘|✘|
|*Lezen*|✔|✔|✘|✘|✘|✘|
|*Overzicht zien*|✔|✔|✘|✘|✘|✘|
|*Tonen*|✔|✔|✘|✘|✘|✘|
|*Bijwerken*|✔|✔|✘|✔|✘|✘|
|*Bewerken*|✔|✔|✘|✔|✘|✘|
|**Waardering**||
|*Aanmaken & opslaan*|✔|✔|✘|✔|✘|✘|
|*Aanmaken*|✔|✔|✘|✔|✘|✘|
|*Lezen*|✔|✔|✔|✔|✘|✘|
|*Overzicht zien*|✔|✔|✔|✔|✘|✘|
|*Tonen*|✔|✔|✔|✔|✘|✘|
|*Bijwerken*|✔|✔|✘|✔|✘|✘|
|*Bewerken*|✔|✔|✘|✔|✘|✘|
|**Import**||
|*Lezen*|✔|✘|✔|✘|✘|✘|
|*Overzicht zien*|✔|✘|✔|✘|✘|✘|
|*Tonen*|✔|✘|✔|✘|✘|✘|
|*Overzicht tonen in collectie-context*|✔|✘|✔|✘|✘|✘|
|**Herinnering**||
|*Lezen*|✔|✘|✔|✘|✘|✘|
|*Overzicht zien*|✔|✘|✔|✘|✘|✘|
|*Tonen*|✔|✘|✔|✘|✘|✘|
|*Overzicht tonen in collectie-context*|✔|✔|✔|✘|✘|✘|
|**Thema**||
|*Overzicht tonen in collectie-context*|✔|✔|✔|✘|✘|✘|
|**Eigenaar**||
|*Overzicht tonen in collectie-context*|✔|✔|✔|✘|✘|✘|

### Write access

This is a list of fields a user can write to

|-|Administrator | Kunstadviseur | Compliance | Taxateur | Facility Manager | Read-only|
|-|---|---|---|---|---|---|
|**works_attributes**||
|*location_detail*|✔|✔|✘|✔|✔|✘|
|*location*|✔|✔|✘|✔|✔|✘|
|*location_floor*|✔|✔|✘|✔|✔|✘|
|*work_status_id*|✔|✔|✘|✔|✔|✘|
|*internal_comments*|✔|✔|✘|✔|✘|✘|
|*photo_front*|✔|✔|✘|✔|✘|✘|
|*photo_back*|✔|✔|✘|✔|✘|✘|
|*photo_detail_1*|✔|✔|✘|✔|✘|✘|
|*photo_detail_2*|✔|✔|✘|✔|✘|✘|
|*remove_photo_front*|✔|✔|✘|✔|✘|✘|
|*remove_photo_back*|✔|✔|✘|✔|✘|✘|
|*remove_photo_detail_1*|✔|✔|✘|✔|✘|✘|
|*remove_photo_detail_2*|✔|✔|✘|✔|✘|✘|
|*inventoried*|✔|✔|✘|✔|✘|✘|
|*refound*|✔|✔|✘|✔|✘|✘|
|*new_found*|✔|✔|✘|✔|✘|✘|
|*locality_geoname_id*|✔|✔|✘|✔|✘|✘|
|*imported_at*|✔|✔|✘|✔|✘|✘|
|*import_collection_id*|✔|✔|✘|✔|✘|✘|
|*stock_number*|✔|✔|✘|✔|✘|✘|
|*alt_number_1*|✔|✔|✘|✔|✘|✘|
|*alt_number_2*|✔|✔|✘|✔|✘|✘|
|*alt_number_3*|✔|✔|✘|✔|✘|✘|
|*artist_unknown*|✔|✔|✘|✔|✘|✘|
|*title*|✔|✔|✘|✔|✘|✘|
|*title_unknown*|✔|✔|✘|✔|✘|✘|
|*description*|✔|✔|✘|✔|✘|✘|
|*object_creation_year*|✔|✔|✘|✔|✘|✘|
|*object_creation_year_unknown*|✔|✔|✘|✔|✘|✘|
|*medium_id*|✔|✔|✘|✔|✘|✘|
|*frame_type_id*|✔|✔|✘|✔|✘|✘|
|*signature_comments*|✔|✔|✘|✔|✘|✘|
|*no_signature_present*|✔|✔|✘|✔|✘|✘|
|*print*|✔|✔|✘|✔|✘|✘|
|*print_unknown*|✔|✔|✘|✔|✘|✘|
|*frame_height*|✔|✔|✘|✔|✘|✘|
|*frame_width*|✔|✔|✘|✔|✘|✘|
|*frame_depth*|✔|✔|✘|✔|✘|✘|
|*frame_diameter*|✔|✔|✘|✔|✘|✘|
|*height*|✔|✔|✘|✔|✘|✘|
|*width*|✔|✔|✘|✔|✘|✘|
|*depth*|✔|✔|✘|✔|✘|✘|
|*diameter*|✔|✔|✘|✔|✘|✘|
|*condition_work_id*|✔|✔|✘|✔|✘|✘|
|*condition_work_comments*|✔|✔|✘|✔|✘|✘|
|*condition_frame_id*|✔|✔|✘|✔|✘|✘|
|*condition_frame_comments*|✔|✔|✘|✔|✘|✘|
|*information_back*|✔|✔|✘|✔|✘|✘|
|*other_comments*|✔|✔|✘|✔|✘|✘|
|*subset_id*|✔|✔|✘|✔|✘|✘|
|*public_description*|✔|✔|✘|✔|✘|✘|
|*grade_within_collection*|✔|✔|✘|✔|✘|✘|
|*entry_status*|✔|✔|✘|✔|✘|✘|
|*entry_status_description*|✔|✔|✘|✔|✘|✘|
|*abstract_or_figurative*|✔|✔|✘|✔|✘|✘|
|*medium_comments*|✔|✔|✘|✔|✘|✘|
|*main_collection*|✔|✔|✘|✔|✘|✘|
|*image_rights*|✔|✔|✘|✔|✘|✘|
|*publish*|✔|✔|✘|✔|✘|✘|
|*cluster_name*|✔|✔|✘|✔|✘|✘|
|*collection_id*|✔|✔|✘|✔|✘|✘|
|*cluster_id*|✔|✔|✘|✔|✘|✘|
|*owner_id*|✔|✔|✘|✔|✘|✘|
|*placeability_id*|✔|✔|✘|✔|✘|✘|
|*artist_ids*|✔|✔|✘|✔|✘|✘|
|*damage_type_ids*|✔|✔|✘|✔|✘|✘|
|*frame_damage_type_ids*|✔|✔|✘|✔|✘|✘|
|*theme_ids*|✔|✔|✘|✔|✘|✘|
|*object_category_ids*|✔|✔|✘|✔|✘|✘|
|*technique_ids*|✔|✔|✘|✔|✘|✘|
|*source_comments*|✔|✔|✘|✔|✘|✘|
|*source_ids*|✔|✔|✘|✔|✘|✘|
|*purchase_price*|✔|✔|✘|✔|✘|✘|
|*purchased_on*|✔|✔|✘|✔|✘|✘|
|*purchase_year*|✔|✔|✘|✔|✘|✘|
|*selling_price*|✔|✔|✘|✔|✘|✘|
|*minimum_bid*|✔|✔|✘|✔|✘|✘|
|*selling_price_minimum_bid_comments*|✔|✔|✘|✔|✘|✘|
|*purchase_price_currency_id*|✔|✔|✘|✔|✘|✘|
|*balance_category_id*|✔|✔|✘|✔|✘|✘|
|**artists_attributes**||
|*_destroy*|✔|✔|✘|✔|✘|✘|
|*first_name*|✔|✔|✘|✔|✘|✘|
|*last_name*|✔|✔|✘|✔|✘|✘|
|*prefix*|✔|✔|✘|✔|✘|✘|
|*place_of_birth*|✔|✔|✘|✔|✘|✘|
|*place_of_death*|✔|✔|✘|✔|✘|✘|
|*year_of_birth*|✔|✔|✘|✔|✘|✘|
|*year_of_death*|✔|✔|✘|✔|✘|✘|
|*description*|✔|✔|✘|✔|✘|✘|
|**appraisals_attributes**||
|*appraised_on*|✔|✔|✘|✔|✘|✘|
|*market_value*|✔|✔|✘|✔|✘|✘|
|*replacement_value*|✔|✔|✘|✔|✘|✘|
|*market_value_range*|✔|✔|✘|✔|✘|✘|
|*replacement_value_range*|✔|✔|✘|✔|✘|✘|
|*appraised_by*|✔|✔|✘|✔|✘|✘|
|*reference*|✔|✔|✘|✔|✘|✘|


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
    reattach attachment

Appraise works
  as appraiser
    cannot appraise work outside scope
    can appraise work using ranges
    can appraise work old style

Manage Collection
  as admin
    editing a collection
    creating a sub-collection

Batch editor
  move work to sub-collection in cluster
  appraise works
  modify other attributes (happy flow)
  Specialized batch editors
    move work to subcollection in using the cluster-batch editor

Edit photos
  as QKunst regular user with collection
    can edit photo's
  as QKunst administrator
    can edit photo's
  as QKunst  appraiser
    can edit photo's
  as QKunst  advisor
    can edit photo's
  as QKunst  read only user
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
  as QKunst  read only user
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
  as a facility manager (limited)

Finished in 53.46 seconds (files took 3.11 seconds to load)
51 examples, 0 failures


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
      returns a success response (i.e. to display the 'new' template) (PENDING: Add a hash of attributes invalid for your model)
  PUT #update
    with valid params
      updates the requested custom_report (PENDING: Add a hash of attributes valid for your model)
      redirects to the custom_report
    with invalid params
      returns a success response (i.e. to display the 'edit' template) (PENDING: Add a hash of attributes invalid for your model)
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

WorksController
  GET /works
    should be able to get an index
    should be able to get an index als xlsx
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

Manage Collection
  as admin
    editing a collection
    creating a sub-collection

Signin in and out
  should sign in a regular user using password login
  should not allow password login as admin user
  should allow oauth login as admin user
  should allow oauth login as never oauthed admin user

Batch editor
  facility manager can scan works with batch editor
  move work to sub-collection in cluster
  appraise works
  modify other attributes (happy flow)
  Specialized batch editors
    move work to subcollection in using the cluster-batch editor

Werken groeperen
  Advisor can group works

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
  as a facility manager (limited)

ApplicationHelper
  #menu_link_to
    returns takes a description and task
    should mark equal path active
    should mark equal path active also with :only_exact_path_match-option true
    should mark child path active (by default)
    should not mark child path active if only_exact_path_match: true
    should work with full urls as well
  #kramdown
    understands bold
    doesn't parse tables

CollectionReportHelper
  #render_report_column
    should render a empt report when no values are given
    should render a simple report (with missing)
    should render a report with numbers
    should render a report with a string/key
    should created the proper nested urls
  #iterate_report_sections
    should work
  #render_range
    works with simple example
    works with complex example

JsonHelper
  render_hash
    should return an nothing when empty
    should return a list when given a list
    should return a dl if kvs
    should combine

WorksHelper
  filter_checkbox
    should return an nothing when empty

SystemMailer
  error_message
    renders the headers
    renders the body

Ability
  admin
    Works
      can read work(:work1)
      can edit work(:work1)
      can edit_location work(:work1)
      can read work(:work6)
      can show_details work(:work1)
    Users
      can update user(:user_with_no_rights)
  advisor
    Test: alias working of :manage_collection
      can manage_collection collection(:collection_with_works)
      can review_collection collection(:collection_with_works)
    Works
      can read work(:work1)
      can edit work(:work1)
      can edit_location work(:work1)
      cannot read work(:work6)
      can show_details work(:work1)
    Users
      cannot update user(:user_with_no_rights)
  compliance
    Collections
      can read collection(:collection_with_works)
      cannot read collection(:collection3)
      cannot manage_collection collection(:collection_with_works)
      can review_collection collection(:collection_with_works)
      can read_extended_report collection(:collection_with_works)
    Works
      can read work(:work1)
      cannot edit work(:work1)
      cannot edit_location work(:work1)
      cannot read work(:work6)
      can show_details work(:work1)
    Users
      cannot update user(:user_with_no_rights)
  appraiser
    Collections
      can read collection(:collection_with_works)
      can read collection(:collection3)
      cannot read collection(:collection_with_stages)
      cannot manage_collection collection(:collection_with_works)
      cannot review_collection collection(:collection_with_works)
      can read_report collection(:collection_with_works)
      can read_extended_report collection(:collection_with_works)
    Works
      can read work(:work1)
      can edit work(:work1)
      can edit_purchase_information work(:work1)
      can edit_location work(:work1)
      can show_details work(:work1)
      can read work(:work6)
      cannot read work(:work_with_private_theme)
    Users
      cannot update user(:user_with_no_rights)
  facility_manager
    Collections
      can read collection(:collection_with_works)
      cannot read collection(:collection3)
      cannot manage_collection collection(:collection_with_works)
      cannot review_collection collection(:collection_with_works)
      can read_report collection(:collection_with_works)
      cannot read_extended_report collection(:collection_with_works)
    Works
      can read work(:work1)
      cannot edit work(:work1)
      can edit_location work(:work1)
      cannot read work(:work6)
      can show_details work(:work1)
    Users
      cannot update user(:user_with_no_rights)
  registrator
    Collections
      can read collection(:collection_with_works)
      cannot read collection(:collection3)
      cannot manage_collection collection(:collection_with_works)
      cannot review_collection collection(:collection_with_works)
      can read_report collection(:collection_with_works)
      can read_extended_report collection(:collection_with_works)
    Works
      can read work(:work1)
      can edit work(:work1)
      can edit_location work(:work1)
      can show_details work(:work1)
      can edit_source_information work(:work1)
      cannot edit_purchase_information work(:work1)
      cannot read work(:work6)
      cannot edit work(:work6)
    Users
      cannot update user(:user_with_no_rights)
  Role manager role
    when added to admin
      can update anonymous users for a collection
      can update an admin user
      can update self
      can update an user from another collection
      can update an user from current collection
    when added to advisor
      can update anonymous users for a collection
      cannot update an admin user
      cannot update self
      cannot update an user from another collection
      can update an user from current collection
    when added to compliance
      can update anonymous users for a collection
      cannot update an admin user
      cannot update self
      cannot update an user from another collection
      can update an user from current collection
    when added to appraiser
      can update anonymous users for a collection
      cannot update an admin user
      cannot update self
      cannot update an user from another collection
      can update an user from current collection
    when added to facility_manager
      can update anonymous users for a collection
      cannot update an admin user
      cannot update self
      cannot update an user from another collection
      can update an user from current collection
    when added to registrator
      can update anonymous users for a collection
      cannot update an admin user
      cannot update self
      cannot update an user from another collection
      can update an user from current collection
  report related functions
    .report_field_abilities
      should report field abilities
    .report_abilities
      should report field abilities

Appraisal
  methods
    #destroy
      should be destroyable
    #market_value_range
      should accept string
      should accept range
    #name
      should return a valid name
      should also work when date is not present
    #replacement_value_range
      should accept string
      should accept range
  scopes
    .descending_appraisal_on
      should return the latest by date and then id

ArtistInvolvement
  #copy_place_geoname_id_from_involvement_when_nil
    should work copy geoname from involvement
  #to_s
    should include name
    should include name and year
    should include name, geoname and year
    option={format:short}
      should include name
      should include name and year
      should include name, geoname and year
      should include geoname when no name

Artist
  #collection_attributes_attributes=
    should create collection attributes
    should destroy collection attributes when emptied
  #combine_artists_with_ids(artist_ids_to_combine_with)
    should work
  #import
    should import from another artist
    should not overwrite name when prefix is present
  #to_parameters
    should return basic params
  #name
    should return a reasonable name string
    should return a reasonable name string with years if given
    should return a reasonable name string without years if given when include_years == false
    should render artist name, when present
    should render not the full name, just the artist name when present
  #save
    should update artist name at work
  #import
    should import basic params
    should not import name when middle name is given
    should import artist involvements
  #other_structured_data
    should work
  Class methods
    .empty_artists
      should list all workless-artists
    .destroy_all_empty_artists!
      should destroy all workless-artists
      should list all workless-artists (check check)
    .artists_with_no_name_that_have_works_that_already_belong_to_artists_with_a_name
      should list all workless-artists
    .collapse_by_name!
      should colleapse only same creation date by default
      should colleapse only same creation date by default

Attachment
  Class methods
    move_work_attaches_to_join_table
      should migrate as intended
  Scopes
    .without_works
      should return attachments without works
    .without_artists
      should return attachments without works
      should only return attache less when combined with .without_works
    for_role
      should return all for advisor
      should return all for admin
      should filter compliance
      should filter facility_manager
      should filter appraiser
      should filter qkunst
      should show none for readonly
    for_me
      should always work for admin
      should always work for admin
      should always work correctly for readonly

BatchPhotoUpload
  instance methods
    #couple!
      couples

Cache spec
  collection that changes
    should touch all related works
  artist that changes
    should touch all related works

CachedApi
  class methods
    .query
      should return json

Cluster
  callbacks
    before_destroy :remove_cluster_id_at_works
      should work
  class methods
    remove_cluster_id_where_cluster_is_removed
      should do the cleanup

Collection::Hierarchy
  methods
    #child_collections_flattened
      should return all childs
    #expand_with_child_collections
      should return all collections when expanded from root
      should return empty array when no id
      should return subset for collection1
    #expand_with_parent_collections
      should return only the root when expanded from root
      should return all parents
      should return parents in order
    #self_and_parent_collections_flattened
      should return sorted from parent to child
    #parent_collections_flattened
      should return sorted from parent to child
    #parent_collections_flattened
      should return the oldest parent, then that child .
    #possible_parent_collections
      should return all qkunst managed collections if new and qkunst admin
      should return all collections if new if super admin
      should not return child collections
  Class methods
    .expand_with_child_collections
      returns child collections
      returns child collections until depth 1
      works with larger start-set that includes child
      works with larger start-set that does not  include child

CollectionAttribute
  class methods
    .create
      creates with an encrypted value
      defaults to base_collection
  scopes
    .for_user
      does not return parent collection's data if the user does not have access to that collection
      does return parent collection's data if the user has access to that collection
    .for_collection
      returns one for the stages collection

Collection
  callbacks
    after save
      touches child works
      doesn't change collection_locality_artist_involvements_texts_cache
      does change collection_locality_artist_involvements_texts_cache when locality has been updated
    before save
      #attach_sub_collection_ownables_when_base
  methods
    #appraise_with_ranges?
      should return false by default
      should return true when self true
      should return true when parent true
    #available_clusters
      should list all private clusters
      should list not list private clusters
    #available_themes
      should include all generic themes
      should not include hidden generic themes
      should not include themes that belong to another collection
      should include collection specific themes if any
    #can_be_accessed_by_user
      collection_with_works not to be accessed by collection_with_works_child_user
      collection_with_works not to be accessed by collection_with_works_user
      admin can see collection_with_works
      admin can not see  not_qkunst_managed_collection
      super admin can see  not_qkunst_managed_collection
    #collection_name_extended
      should have a logical order of parents
    #fields_to_expose
      should return almost all fields when fields_to_expose(:default)
      should return no condition, appraisal and location fields when public
    #main_collection
      should return self if no main collection exists
      should return the parent collection marked as base when it exists
    #sort_works_by
      should not accept noise
      should not valid value
    #works_including_child_works
      should return all child works
      should return child collections' works
  Class methods
    .for_user
      returns collections with root parent for super admin user
      returns collections with root parent for admin user, except for those not qkunst managed
      returns only base collection for user
    .for_user_expanded
      returns collections with root parent for super admin user
      returns collections with root parent for admin user, except for those not qkunst managed
      returns only base collection for user
  Scopes
    default scope
      orders by collection_name_extended_cache
    .artist
      should return all works by certain artist
      should return all works by certain artist, but not expand scope

NameId
  #names_hash
    should work
  #find_in_string
    should find single strings
    can be repeated strings
    should work
  #to_s
    should feature the name first
  Class methods
    .find_by_case_insensitive_name
      should find by string
      should find by array
    .names
      should return a proper name kv
      should return 'Naamloos' when nil

CollectionOwnable
  scopes
    .for_collection_including_generic
      should include generic themes
      should include private themes
    .for_collection
      should include generic themes
      should include private themes
  actually Theme that includes CollectionOwnable
    should validate name
  it should belong to a collection
    well, neot necesarily
    typical roundtrip

MethodCache
  Artist implementation geoname_ids
    should return nil if unset
    should return an empty array after save
    should return array of ids when involvements exist

Template
  #contents_as_html
    should return an empty string when nil
    should parse simple markdown
  Helper.fields_with_modifiers
    should return an empty array when nil
    should parse simple markdown
  #object_calls_with_modifiers
    should return an empty array when nil
    should parse simple markdown
  #content_merge
    should return an empty string when nil
    should parse string
    should parse string with obects

Condition
  class methods
    .find_by_name
      should work

Currency
  instance methods
    #update_conversions
      should update works

CustomReportTemplate
  add some examples to (or delete) /Users/murb/Documents/Zakelijk/Projecten/QKunst/source-collectiemanagement/spec/models/custom_report_template_spec.rb (PENDING: Not yet implemented)

Geoname
  add some examples to (or delete) /Users/murb/Documents/Zakelijk/Projecten/QKunst/source-collectiemanagement/spec/models/geoname_spec.rb (PENDING: Not yet implemented)

GeonameSummary
  Class methods
    .search
      should return an empty array when nil
      should return an empty array when not found

GeonamesAdmindiv
  add some examples to (or delete) /Users/murb/Documents/Zakelijk/Projecten/QKunst/source-collectiemanagement/spec/models/geonames_admindiv_spec.rb (PENDING: Not yet implemented)

GeonamesCountry
  add some examples to (or delete) /Users/murb/Documents/Zakelijk/Projecten/QKunst/source-collectiemanagement/spec/models/geonames_country_spec.rb (PENDING: Not yet implemented)

ImportCollection
  instance methods
    #internal_header_row_offset
      should work humanely
    #workbook
      should update import settings
    #import_file_to_workbook_table
      should return the table
    #update
      should allow for updating import settings
    #read
      should work
      should import into a different collection when sub
      should not import into a different collection when not a child

ImportCollection::Strategies::SplitStrategies
  class methods
    .split_space
      should work

Message
  methods
    set_from_user_name!
      should set on save
    #notifyable_users
      should return current_users
      should return also not email receiving users with direct reply
      should return conversation users
      should return only qkunst admin when private
      should return only admin when qkunst private and no to user
    #attachment
      accepts attachment
  scopes
    .sent_at_date
      should work
    thread_can_be_accessed_by_user
      should show the thread to participating users
      should show the thread to facility managers in same org
      should block facility user from accessing messages from other collections
    collections
      should not contain messages with another collection message subject
      should include message about a collection's work
      should include messages about child collections (and works in those)
    .limit_age_to
      should limit to last year
      accepts overrrides

Owner
  vaidations
    should have collection
    Should create with collection and name

PaperTrail::Version
  Work
    should reify and return artist_name_rendered of that time

Reminder
  methods
    #additional_time
      should work for all time intervals in INTERVAL_UNITS
    reference_date
      should be the created at date by default
      should return nil when stage is set and no collection has no stages
    #last_sent_at
      should return nil by default
      should return nil by default
    #next_dates / #next_date
      should return one date for non repeating
      should return one date for non repeating
      should return an empty array if the next date for non repeating has already passed
      should return 10 dates for non repeating
      should return today for event that triggers today
      should return today for singular event that triggers today
      should return nil for event that hasn't passed yet
      should return nil if no collection is given
    #to_message
      should return nil if no collection is given
      should return message if collection is given
      should inform all admins
    #to_message!
      should return nil if no collection is given
      should return message if collection is given
    #send_message_if_current_date_is_next_date!
      should not send any message when next_date is not equal to now
      should send any message when next_date is equal to now
      should not double send any message when next_date is equal to now

Report::Builder
  aggregation_builder
    should work while I'm refactoring

RkdArtist
  #to_artist_params
    extracts correctly artist params rkd_api_response1
    extracts correctly artist params rkd_api_response2

SimpleArtist
  instance methods
    #name
      should return no name given string by default
      should return full name (with years when given)
      can render places as well
    #to_json_for_simple_artist
      should work

Stage
  methdos
    #non_cyclic_graph_from_here
      should be available from start
      should match te expected result
      should take a collection as a parameter (and then consider all stages to be disabled)
      should take a collection as a parameter (and mark stages correctly)
      should not mark the combination stage as active when stages before are inactive
  Class methods
    .start
      should return the first stage

User
  methods
    #accessible_collections
      should return all collections when admin (except when not qkunst managed)
      should return all collections when the user is a super admin
      should return all collections and sub(sub)collections the user has access to
      should restrict find
    #collection_ids
      should return ids of collections
    #collection_accessibility_log
      should be empty when new
      should log accessible projects with name and id on save
      should log accessible projects with name and id on update
      should log accessible projects with name and id on update with ids
      should be retrievable from an earlier version
    #name
      should return name when set
      should return email when not set
    #oauthable?
      supposed_admin_without_oauth
        should return false
      admin
        should return true
      collection_with_works_user
        should return true
      compliance
        should return false
      advisor
        should return false
      appraiser
        should return false
    #role
      should return read_only by default
      should return admin for admin
      should return not admin when supposedly admin
    #roles
      should return read_only by default
      should return read_only by default, even for admin
    #super_admin?
      should return false for regular admin
      should return true for super admin
    #works_created
      should count 2 for admin
    #accessible_users
      should return all users when admin
      should return no users when qkunst
      should return subset of users when advisor
    #accessible_roles
      should return all for admin
      should return nil for regular advisor
      should return some for advisor with manager roles role (advisor;compliance;qkunst;appraiser;facility_manager;read_only)
  Class methods
    .from_omniauth_callback_data
      raises argument error when invalid data is passed
      creates a new user when given
      creates a new user when given and confirms when confirmed
  Callbacks
    name change should result in name changes with work
      should change

Validators::CollectionScopeValidator
  validates properly
    works with theme in own collection
    works with theme in super collection
    works with theme in hidden super collection
    should fail on theme in other collection

WorkSet
  has and belongs to many works
  requires a type
  scopes
    .accepts_appraisals
      should return only diptych
  validations
    cannot have works exist in two appraisable sets
    can have works exist in a multiple sets that are not all appraisable
  instance methods
    #appraisable?
    #can_be_accessed_by_user?(user)
      only work1
        returns true for admin
        returns false for user1
        returns true for appraiser
        returns false for collection_with_works_child_user
        returns true for collection_with_works_user
      work1, work2, work7
        returns true for admin
        returns false for user1
        returns true for appraiser
        returns false for collection_with_works_child_user
        returns false for collection_with_works_user
    #most_specific_shared_collection
      returns single work's collection as base
      returns shared collection as base
      returns shared parent collection as base
      returns nil when nothing shared

WorkSetType
  add some examples to (or delete) /Users/murb/Documents/Zakelijk/Projecten/QKunst/source-collectiemanagement/spec/models/work_set_type_spec.rb (PENDING: Not yet implemented)

Work
  instance methods
    #all_work_ids_in_collection
      sorts by default on inventory and id
      can sort on super collection
    #appraisable?
      should return true by default
      should return false on a work part of a diptych
    #artist_#{index}_methods
      should have a first artist
      should return nil when no artist is found at index
    #frame_type
      should be able to set a FrameType
    #stock_number_file_safe
      should not change good number
      should change risky number
    #height
      should accept integer
      should accept string
      should accept us-localized string
      should accept nl-localized string
      should accept long nl-localized string
    #purchased_on=
      should accept a date
      should not fail on an empty string
      should accept a string
      should accept a nil
      should accept a number
      should accept a number in a string
    #damage_types
      should be an empty by default
      should should touch work on add (and should only return once)
    #cluster_name
      should set cluster to nil when name is nil or empty
      should reset cluster when set to a different name
      should create cluster when set to a different name
    #location_description
      concats the location fields
      returns emtpy string when none
    #location_history
      returns an empty array if no history
      returns a single item array if no history
      returns complete history if work is created after enabling history
      skip_current options skips current
      returns empty location if empty location
      never returns empty location if empty location and no empty locations
      never returns empty location if empty location and no empty locations (and doesn't just pop the skip current false)
    #purchased_on_with_fallback
      should return nil when not set
      should return date both year and date are present
      should return year if only year is present
    #next
      should redirect to the next work
      should return first if no next
    #previous
      should redirect to the previous work
      should return last if no previous
    #object_creation_year
      should return nil if object_creation_year_unknown = true
    #object_format_code
      should return proper format code
    #frame_size_with_fallback
      should return frame size by default
      should return work size if frame size is not present
    #restore_last_location_if_blank!
      shoudl restore last location when blenk
      should not 'restore' a location if location is set
    #save
      should save, even without info
    public_tag_list
      filters public tags
    work_set_attributes=
      ignores empty hashes
      ignores partially empty hashes
      creates when full hash is given
      reuses when full hash is given equal to earlier in same collection
      creates when full hash is given equal to earlier in other collection
  class methods
    .artist_name_rendered
      should not fail on an empty name
      should summarize the artists nicely
      should respect include_years option
    .artist_name_rendered_without_years_nor_locality
      should summarize the artist nicely
      should summarize the artists nicely
    .artist_name_rendered_without_years_nor_locality_semicolon_separated
      should summarize the artist nicely
      should summarize the artists nicely
    .count_as_whole_works
      should return all works uniquele
      should return all works uniquely even when in two work sets
    .possible_exposable_fields
      should return possible_exposable_fields
    .fast_aggregations
      should allow to be initialized
    .whd_to_s
      should render nil if all are nil
      should render w x h x d if set
      should round w x h x d
      should add diameter if set
      should add diameter if set
    .frame_size
      should use whd_to_s
    .to_workbook
      should be callable and return a workbook
      should be work even with complex fieldset
      should work with tags
      should return basic types
    .update
      updates collection
      throws error when updating a work that doesn't validate
    .column_types
      returns a hash
      should return  for {:inventoried=>:boolean, :title=>:string}
  Scopes
    .has_number
      finds nothing when an unknown number is passed
      finds by alt number
      finds by stock number
      finds by array
      finds by array on all numbers
      adheres earlier scopes
    .order_by
      artist
        works when there are no artists
      location
        sorts -1 before BG
        sorts by location, floor, detail

Collections
  GET /collections
    shouldn't be publicly accessible!
    an api user without advisor role should be access the collection
    an api user with advisor role should be access the collection
    an allowed user should be able to get a single work through the api
    even an allowed user shouldn't be able to mess with the url
    not allowed user should be not be able to get an index

Appraisals
  GET /collections/1/works/1/appraisals/new
    HTTP response codes
      it refuses by default
      it refuses by qkunst
      it works for admin
  GET /collections/1/works/1/appraisals/1/edit
    refuses by default
    refuses by qkunst
    admin
      works for admin
      allows editing ranges
      allows editing non-existing ranges
  POST appraisals (#create)
    POST /collections/1/works/1/appraisals
      stores an appraisal
    POST /collections/:collection_id/work_sets/:work_set_id/appraisals
      allows for appraising
      single work not in accessible collection
        does not allow appraising a work set that is partially not accessible

Artists
  GET /artists
    shouldn't be publicly accessible
    shouldn't be accessible by QKunst
    should be accessible by admin
  GET collection/id/artists
    shouldn't be publicly accessible
    should be accessible by QKunst having access to collection
  GET /artists/:id/edit
    should be accessible for an admin
    /collection/:collection_id
      should be accessible for an appraiser
  GET /artists/new
    should be accessible for an admin
  POST /artists/clean
    shouldn't be publicly accessible!
    should be accessible when logged in as admin
    should not be accessible when logged in as qkunst

Attachments
  GET /attachments/new
    redirects by default
    redirects by default when not qkunst
    redirects by default when not qkunst (fm)
    redirects by default when qkunst without access
    success when qkunst with acces
    success when admin
    succeeds when registrator
  GET /attachments
    lists no attachments if none
    lists no accessible attachments if none
    lists  accessible attachments if some
  POST /attachments
    work
      stores an attachment on work level
    collection
      stores an attachment on collection level
      stores an attachment on collection level as registrator
      attaches to a base collection when set
  DELETE /attachment/:id
    collection
      destroys
      doesn't destroy as registrator
    collection
      destroys
    work
      removes at work
  PATCH /attachment/:id
    collection
      as admin it should update visibility
      as registrator it should not update visibility

BatchPhotoUploads
  GET /batch_photo_uploads
    redirects! (now write some real specs)

WorkBatchs
  GET /collections/:id/batch/
    Collection defense
      shouldn't be publicly accessible!
      should be accessible when logged in as admin
      should not be accessible when logged in as an anonymous user
      should not be accessible when logged in as an registrator user
      should not allow accesss to the batch editor for non qkunst user has access to
      should redirect to the root when accessing anohter collection
    Field-accessibility
      describe facility should only be able to edit location
      describe facility should only be able to edit location
  PATCH /collection/:collection_id/batch
    appraisal
      should store appraisal
      should ignore ignored fields
      diptych
        should stop when work cannot be appraised (diptych scenario)
    themes
      appends themes
    tag_list
      should REPLACE
      should APPEND
      should REMOVE

Clusters
  GET /collections/:collection_id/clusters
    not accessible by default
    accessible by admin
    accessible by advisor
    shows create button for advisor
    is not accessible by a random registrerd user
    is not accessible by a facility manager with access to the collection
  GET /collections/:collection_id/clusters/new
    not accessible by default
    accessible by admin
    accessible by advisor
    is not accessible by a random registrerd user
    is not accessible by a facility manager with access to the collection
  POST /collections/:collection_id/clusters
    anonymous cannot create cluster
    admin can create cluster
    advisor can create cluster

Collection::UsersController
  GET /collections/:id/users
    shouldn't be publicly accessible!
    facility_manager
      should return 302
    appraiser
      should return 302
    advisor
      should return 200
      should show users
      should show users from a few collections deep
    compliance
      should return 200
      should show users
      should show users from a few collections deep
    admin
      should return 200
      should show users
      should show users from a few collections deep
  POST /collection/:collection_id/users/:id
    shouldn't be publicly accessible!
    not a role manager
      facility_manager
        should not update
        should update collection ids
        user with existing roles
          should leave existing collections in tact
      appraiser
        should not update
        should update collection ids
        user with existing roles
          should leave existing collections in tact
      advisor
        should not update
        should update collection ids
        user with existing roles
          should leave existing collections in tact
      compliance
        should not update
        should update collection ids
        user with existing roles
          should leave existing collections in tact
    role manager
      facility_manager
        should update
        should update collection ids
        should not allow editing roles outside current scope
        user with existing roles
          should leave existing collections in tact
      appraiser
        should update
        should update collection ids
        should not allow editing roles outside current scope
        user with existing roles
          should leave existing collections in tact
      advisor
        should update
        should update collection ids
        should not allow editing roles outside current scope
        user with existing roles
          should leave existing collections in tact
      compliance
        should update
        should update collection ids
        should not allow editing roles outside current scope
        user with existing roles
          should leave existing collections in tact
      admin
        should update
        should update collection ids
        user with existing roles
          should leave existing collections in tact

Collections
  GET /collections
    shouldn't be publicly accessible!
    should be accessible when logged in as admin
    should not be accessible when logged in as an anonymous user
    should redirect to the single collection the user has access to
  GET /collections/:id
    shouldn't be publicly accessible!
    should be accessible when logged in as admin
    should not be accessible when logged in as an anonymous user
    should allow accesss to the single collection the user has access to
    should redirect to the root when accessing anohter collection
  DELETE /collections/:colletion_id
    allows access for admin
    allows access for advisor
    denies access for facility_manager
    denies access for appraiser
    denies access for compliance
  GET /collections/:id/edit
    shouldn't be publicly accessible!
    should be accessible when logged in as admin
    should not be accessible when logged in as an anonymous user
    should allow accesss to the single collection the user has access to
    should redirect to the root when accessing anohter collection
  GET /collections/new
    shouldn't be publicly accessible!
    should be accessible when logged in as admin
    should not be accessible when logged in as an anonymous user
    should allow accesss to the single collection the user has access to

CustomReportTemplates
  GET /custom_report_templates
    redirects; cause forbidden by default

CustomReports
  GET /custom_reports
    redirects! (now write some real specs)

Involvements
  GET /involvements
    works! (now write some real specs)

/collection/:collection_id/library_items
  GET /index
    redirects to sign in path when not signed in
    redirects to root path when insufficient credentials
    displays for compliance
    displays for compliance at work level
    doesn't display for compliance at another collection
  GET /show
    renders a successful response for compliance at work level
  GET /new
    renders a redirect response for compliance
    renders for registrator
    renders couple action when isn't yet coupled
    renders a form
  GET /edit
    render a successful response
  POST /create
    with valid parameters
      creates a no new LibraryItem when not signed in
      signed in as registrator
        creates a new LibraryItem when signed in
        redirects to the created library_item
    with invalid parameters
      does not create a new LibraryItem
      renders a successful response (i.e. to display the 'new' template)
  PATCH /update
    with valid parameters
      updates the requested library_item
      redirects to the library_item
    with invalid parameters
      renders a successful response (i.e. to display the 'edit' template)
  DELETE /destroy
    doesnt destroys the requested library_item when not signed in
    doesnt destroys the requested library_item when not signed in as registrator
    does destroys the requested library_item when signed in as admin
    redirects to the library_items list

Messages
  GET /messages
    shouldn't be publicly accessible!
    should be accessible when logged in as admin
  GET /messages/:id
    advisor
      should be able to download the download message

Admin level management
  conditions
    GET /conditions
      ignores anonymous request
      ignores advisor request
      adheres to admin request
    GET /conditions/new
      ignores anonymous request
      ignores advisor request
      adheres to admin request
    POST /conditions
      does not change Condition.count when performed by anonymous
      does not change Condition.count when performed by advisor
      changes Condition.count by 1 when performed by admin
  currencies
    GET /currencies
      ignores anonymous request
      ignores advisor request
      adheres to admin request
    GET /currencies/new
      ignores anonymous request
      ignores advisor request
      adheres to admin request
    POST /currencies
      does not change Currency.count when performed by anonymous
      does not change Currency.count when performed by advisor
      changes Currency.count by 1 when performed by admin
  damage_types
    GET /damage_types
      ignores anonymous request
      ignores advisor request
      adheres to admin request
    GET /damage_types/new
      ignores anonymous request
      ignores advisor request
      adheres to admin request
    POST /damage_types
      does not change DamageType.count when performed by anonymous
      does not change DamageType.count when performed by advisor
      changes DamageType.count by 1 when performed by admin
  frame_damage_types
    GET /frame_damage_types
      ignores anonymous request
      ignores advisor request
      adheres to admin request
    GET /frame_damage_types/new
      ignores anonymous request
      ignores advisor request
      adheres to admin request
    POST /frame_damage_types
      does not change FrameDamageType.count when performed by anonymous
      does not change FrameDamageType.count when performed by advisor
      changes FrameDamageType.count by 1 when performed by admin
  frame_types
    GET /frame_types
      ignores anonymous request
      ignores advisor request
      adheres to admin request
    GET /frame_types/new
      ignores anonymous request
      ignores advisor request
      adheres to admin request
    POST /frame_types
      does not change FrameType.count when performed by anonymous
      does not change FrameType.count when performed by advisor
      changes FrameType.count by 1 when performed by admin
  media
    GET /media
      ignores anonymous request
      ignores advisor request
      adheres to admin request
    GET /media/new
      ignores anonymous request
      ignores advisor request
      adheres to admin request
    POST /media
      does not change Medium.count when performed by anonymous
      does not change Medium.count when performed by advisor
      changes Medium.count by 1 when performed by admin
  object_categories
    GET /object_categories
      ignores anonymous request
      ignores advisor request
      adheres to admin request
    GET /object_categories/new
      ignores anonymous request
      ignores advisor request
      adheres to admin request
    POST /object_categories
      does not change ObjectCategory.count when performed by anonymous
      does not change ObjectCategory.count when performed by advisor
      changes ObjectCategory.count by 1 when performed by admin
  placeabilities
    GET /placeabilities
      ignores anonymous request
      ignores advisor request
      adheres to admin request
    GET /placeabilities/new
      ignores anonymous request
      ignores advisor request
      adheres to admin request
    POST /placeabilities
      does not change Placeability.count when performed by anonymous
      does not change Placeability.count when performed by advisor
      changes Placeability.count by 1 when performed by admin
  sources
    GET /sources
      ignores anonymous request
      ignores advisor request
      adheres to admin request
    GET /sources/new
      ignores anonymous request
      ignores advisor request
      adheres to admin request
    POST /sources
      does not change Source.count when performed by anonymous
      does not change Source.count when performed by advisor
      changes Source.count by 1 when performed by admin
  subsets
    GET /subsets
      ignores anonymous request
      ignores advisor request
      adheres to admin request
    GET /subsets/new
      ignores anonymous request
      ignores advisor request
      adheres to admin request
    POST /subsets
      does not change Subset.count when performed by anonymous
      does not change Subset.count when performed by advisor
      changes Subset.count by 1 when performed by admin
  techniques
    GET /techniques
      ignores anonymous request
      ignores advisor request
      adheres to admin request
    GET /techniques/new
      ignores anonymous request
      ignores advisor request
      adheres to admin request
    POST /techniques
      does not change Technique.count when performed by anonymous
      does not change Technique.count when performed by advisor
      changes Technique.count by 1 when performed by admin
  themes
    GET /themes
      ignores anonymous request
      ignores advisor request
      adheres to admin request
    GET /themes/new
      ignores anonymous request
      ignores advisor request
      adheres to admin request
    POST /themes
      does not change Theme.count when performed by anonymous
      does not change Theme.count when performed by advisor
      changes Theme.count by 1 when performed by admin
  work_statuses
    GET /work_statuses
      ignores anonymous request
      ignores advisor request
      adheres to admin request
    GET /work_statuses/new
      ignores anonymous request
      ignores advisor request
      adheres to admin request
    POST /work_statuses
      does not change WorkStatus.count when performed by anonymous
      does not change WorkStatus.count when performed by advisor
      changes WorkStatus.count by 1 when performed by admin

Reminders
  GET /reminders
    redirects

Stages
  GET /stages
    rejects

Works
  PATCH /collections/:collection_id/works/:id
    should render the edit form when changing location fails
    should allow for updating work status
  DELETE /collections/:colletion_id/work_id
    allows access for admin
    denies access for facility_manager
    denies access for appraiser
    denies access for compliance
    denies access for advisor
  GET /collections/:id/works
    shouldn't be publicly accessible!
    admin
      should be accessible when logged in as admin
      admin should be able to access edit page
      should be able to get an index
      sorting and grouping
        should be able to get a grouped index
        should be able to sort
        should be able to filter and sort
        should be able to search
      downloading
        xlsx
          should be able to get an zip file
        csv
          should be able to get an zip file
          should include alt_number_4
        zip
          should be able to get an zip file
          should be able to get an zip file with photos
          should be able to get an zip file with only front photos
        xml
          requires login
          rejects facility
          downloads for admin
          doesn't include work twice
          with public audience
            respects audience public setting
    filtering & searching
      tag filtering
        should return no works when tags do not exist
        should use AND for tags
    user with no rights
      should not be accessible when logged in as an anonymous user
    facility
      should not be able to see a work from another collection
      should be able to see the work when work is in an accessible collection
      should not be able to edit the work
      should be able to edit the location
      should be able to update the location
      should not render the edit form
    read only user
      should allow accesss to the single collection the user has access to
      should not allow accesss to a work in another collection by accessing it through another collection the user has access to
      should not allow accesss to a work in collection the user has no access to
      should redirect to the root when accessing anohter collection
  GET /collections/:colletion_id/works/modified
    allows access for admin
    allows access for compliance
    allows access for advisor
    denies access for facility_manager
    denies access for appraiser

AppraisalsController
  routing
    routes to #new
    routes to #edit
    routes to #create
    routes to #update via PUT
    routes to #update via PATCH
    routes to #destroy

AttachmentsController
  routing
    routes to #index
    routes to #new
    routes to #show
    routes to #edit
    routes to #create
    routes to #update via PUT
    routes to #update via PATCH
    routes to #destroy

CustomReportTemplatesController
  routing
    routes to #index
    routes to #new
    routes to #show
    routes to #edit
    routes to #create
    routes to #update via PUT
    routes to #update via PATCH
    routes to #destroy

CustomReportsController
  routing
    routes to #index
    routes to #new
    routes to #show
    routes to #edit
    routes to #create
    routes to #update via PUT
    routes to #update via PATCH
    routes to #destroy

FrameTypesController
  routing
    routes to #index
    routes to #new
    routes to #show
    routes to #edit
    routes to #create
    routes to #update via PUT
    routes to #update via PATCH
    routes to #destroy

InvolvementsController
  routing
    routes to #index
    routes to #new
    routes to #show
    routes to #edit
    routes to #create
    routes to #update via PUT
    routes to #update via PATCH
    routes to #destroy

LibraryItemsController
  routing
    routes to #index
    routes to #new
    routes to #show
    routes to #edit
    routes to #create
    routes to #update via PUT
    routes to #update via PATCH
    routes to #destroy

MessagesController
  routing
    routes to #index
    routes to #new
    routes to #show
    routes to #edit
    routes to #create
    routes to #update via PUT
    routes to #update via PATCH
    routes to #destroy

RemindersController
  routing
    routes to #index
    routes to #new
    routes to #show
    routes to #edit
    routes to #create
    routes to #update via PUT
    routes to #update via PATCH
    routes to #destroy

StagesController
  routing
    routes to #index
    routes to #new
    routes to #show
    routes to #edit
    routes to #create
    routes to #update via PUT
    routes to #update via PATCH
    routes to #destroy

UnsecureTmpBasicPictureUploader
  instance methods
    #work
      returns nil by default
      returns a work when it matches a work id
      returns a work with id Q001 with when filename = Q001-back.jpg
      returns a work with id Q001 with when filename = Q001-front
      returns a work with id Q001 with when filename = Q001-voorkant
      returns a work with id Q001 with when filename = Q001 voor
      returns a work with alt number 7201284 with when filename = 7201284.jpg

artists/show
  renders attributes in <p>

collections/show
  Stages
    renders stages for admin
    renders stages for admin also for childs
    renders no stages when no stages are present for collection, even when admin
    renders no stages when read only
    renders no stages when read only, not even when in a subcollection

frame_types/edit
  renders the edit frame_type form

frame_types/new
  renders new frame_type form

frame_types/show
  renders attributes in <p>

works/edit_tags
  allows_to_edit_tags

works/show
  renders attributes in <p>
  renders attachments

CollectionDownloadWorker
  performs

Pending: (Failures listed here are expected and do not affect your suite's status)

  1) CustomReportTemplatesController PUT #update with valid params updates the requested custom_report_template
     # Add a hash of attributes valid for your model
     # ./spec/controllers/custom_report_templates_controller_spec.rb:114

  2) CustomReportsController POST #create with invalid params returns a success response (i.e. to display the 'new' template)
     # Add a hash of attributes invalid for your model
     # ./spec/controllers/custom_reports_controller_spec.rb:109

  3) CustomReportsController PUT #update with valid params updates the requested custom_report
     # Add a hash of attributes valid for your model
     # ./spec/controllers/custom_reports_controller_spec.rb:122

  4) CustomReportsController PUT #update with invalid params returns a success response (i.e. to display the 'edit' template)
     # Add a hash of attributes invalid for your model
     # ./spec/controllers/custom_reports_controller_spec.rb:139

  5) CustomReportTemplate add some examples to (or delete) /Users/murb/Documents/Zakelijk/Projecten/QKunst/source-collectiemanagement/spec/models/custom_report_template_spec.rb
     # Not yet implemented
     # ./spec/models/custom_report_template_spec.rb:6

  6) Geoname add some examples to (or delete) /Users/murb/Documents/Zakelijk/Projecten/QKunst/source-collectiemanagement/spec/models/geoname_spec.rb
     # Not yet implemented
     # ./spec/models/geoname_spec.rb:6

  7) GeonamesAdmindiv add some examples to (or delete) /Users/murb/Documents/Zakelijk/Projecten/QKunst/source-collectiemanagement/spec/models/geonames_admindiv_spec.rb
     # Not yet implemented
     # ./spec/models/geonames_admindiv_spec.rb:6

  8) GeonamesCountry add some examples to (or delete) /Users/murb/Documents/Zakelijk/Projecten/QKunst/source-collectiemanagement/spec/models/geonames_country_spec.rb
     # Not yet implemented
     # ./spec/models/geonames_country_spec.rb:6

  9) WorkSetType add some examples to (or delete) /Users/murb/Documents/Zakelijk/Projecten/QKunst/source-collectiemanagement/spec/models/work_set_type_spec.rb
     # Not yet implemented
     # ./spec/models/work_set_type_spec.rb:4

Finished in 1 minute 48.23 seconds (files took 4.55 seconds to load)
1067 examples, 0 failures, 9 pending


```