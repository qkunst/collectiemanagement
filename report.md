# Test report QKunst Collectiemanagement

Date: 2025-06-18 21:51:26 +0200

This report gives an overview of the test ran. This report is automatically created.

## Statistics

In total **93.94%** of the lines are covered by automated test. The code base consists of **13786** lines of code.

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
|*Toon cluster rapportage*|✔|✔|✔|✔|✔|✘|✔|✘|
|*API toegang (alleen lezen)*|✔|✔|✔|✔|✔|✔|✘|✔|
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
|*Tijdsfilter*|✔|✔|✔|✘|✘|✘|✘|✘|
|*Download titel-bordjes (pdf)*|✔|✔|✘|✘|✘|✘|✘|✘|
|*Toegang tot beheer*|✔|✔|✔|✘|✘|✘|✘|✘|
|**Gebeurtenis**||
|*Beheren*|✔|✔|✘|✔|✔|✔|✘|✘|
|*Zien*|✔|✔|✔|✔|✔|✔|✘|✘|
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
|*Zien*|✔|✔|✔|✔|✔|✔|✘|✘|
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
|*Zien*|✔|✔|✔|✘|✔|✔|✘|✘|
|*Bijwerken*|✔|✔|✘|✘|✔|✘|✘|✘|
|**Contact**||
|*Beheren*|✔|✔|✘|✘|✘|✘|✘|✘|
|*Zien*|✔|✔|✔|✘|✘|✘|✘|✘|
|**Eenvoudige Import**||
|*Beheren*|✔|✔|✘|✘|✘|✘|✘|✘|
|**Import**||
|*Zien*|✔|✔|✔|✘|✘|✘|✘|✘|
|*Overzicht tonen in collectie-context*|✔|✔|✔|✘|✘|✘|✘|✘|
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
|*main_location_id*|✔|✔|✘|✔|✔|✔|✘|✘|
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
|*checked*|✔|✔|✘|✔|✔|✘|✘|✘|
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
|*highlight_priority*|✔|✔|✘|✔|✔|✘|✘|✘|
|*grade_within_collection*|✔|✔|✘|✔|✔|✘|✘|✘|
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
|*removed_from_collection*|✔|✔|✘|✘|✘|✘|✘|✘|
|*cluster*|✔|✔|✘|✘|✘|✘|✘|✘|
|*selling_price*|✔|✔|✘|✘|✔|✘|✘|✘|
|*publish_selling_price*|✔|✔|✘|✘|✔|✘|✘|✘|
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
  Admin can start a time span for a group

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

Finished in 1 minute 10.48 seconds (files took 4.08 seconds to load)
70 examples, 0 failures


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
    should not allow an advisor to edit a message not belonging to a collection he/she manages (PENDING: Temporarily skipped with xit)

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
    translate works set uuid into an id
    fixes the current collection

WorksController
  GET /collections/:collection_id/works (#index)
    not signed in
      it is inaccessible by users who are not signed in
    advisor
      renders pdf titles
      renders pdf titles
  PATCH/PUT /collections/:collection_id/works/:id (#update)
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
  Admin can remove a work from a group
  Admin can start a time span for a group

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
    doesn't render javascript
  #data_to_hidden_inputs
    renders key-value
    renders array
    renders nested structure

CollectionReportHelper
  #filter_check_box
    renders a checkbox for location
    renders a checkbox for an missing value
  #render_report_column
    should render a empt report when no values are given
    should render location tree
    should render a simple report (with missing)
    should render a report with numbers
    should render a report with a string/key
    should created the proper nested urls
  #iterate_report_sections
    should display a 7 column table; with a 6 col wide fields (header should span 6 cols) and 1 col count
  #render_range
    works with simple example
    works with complex example

JsonHelper
  render_hash
    should return an nothing when empty
    should return a list when given a list
    should return a dl if kvs
    should combine

UitleenHelper
  #uitleen_work_url
    return nil by default
    uitleen site set
      returns a work url in uitleen if uitleen config is present
  #uitleen_new_draft_invoice_url
    returns nil by default
    uitleen site set
      returns a new url with no params
      returns a new url with params when given

WorksHelper
  filter_checkbox
    should return an nothing when empty

LabelsSupport
  LabelsSupport::Grid
    3 x 3
      returns the right bounding box
      has the cells correctly sorted
      returns the right bounding box for a range of cells
      4x4
        has width and height
        has the cells correctly sorted

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
  #viewable_work_fields
    returns all fields in DISPLAYED_PROPERTIES for admin

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
  class
    .new
      creates an with a once failing import hash
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
    should move the collection specific atributes over
  #human_name
    should return human name
    should return human name with prefix
  #search_name
    should return search name
    should return search name with prefix
  #combined_name_variants
    returns basic name variants
    includes name variants
  #store_collectie_nederland_summary
    fetches and stores a summary of the results
  #collectie_nederland_summary
    returns nil by default
    returns collectie nl when present
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
  #import_rkd_artist_as_artist
    should import RKD artist data
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
  Scopes
    .without_works
      should return attachments without works
    .without_artists
      should return attachments without works
      should only return attache less when combined with .without_works
    .for_role
      should return all for advisor
      should return all for admin
      should filter compliance
      should filter facility_manager
      should filter appraiser
      should filter qkunst
      should show none for readonly
    .for_me
      should always work for admin
      should always work for admin
      should always work correctly for readonly
  Instance methods
    #export_file_name
      works for a simple filename
      works for complex filenames

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
    .for_user (currently not used)
      does not return parent collection's data if the user does not have access to that collection
      does return parent collection's data if the user has access to that collection
    .for_collection
      returns one for the stages collection
    default scope
      always renders nl before en
  validations
    only accepts dutch and english
    only accepts dutch and english
  callbacks
    set significantly updated at on update for works when artist is updated
    set significantly updated at on update for works when work attribute is updated

Collection
  callbacks
    after save
      doesn't touch child works if nothing has changed
      touches child works when name has changed
      doesn't change collection_locality_artist_involvements_texts_cache
      does change collection_locality_artist_involvements_texts_cache when locality has been updated
    before save
      #attach_sub_collection_ownables_when_base
  validations
    validates validity of pdf_title_export_variants_text
      is valid by default
      is valid when nil or empty
      is valid with valid contents
      is invalid with invalid contents
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
    #base_collection
      should return self if no main collection exists
      should return the parent collection marked as base when it exists
      should return the first parent collection marked as base when it exists
    #base_collections
      should return an empty array if no main collection exists
      should return the parent collection marked as base when it exists
      should return the first parent collection marked as base when it exists
    #pdf_title_export_variants
      has a default variant
      s default can be overwritten
      can contain other settings
    #super_base_collection
      should return self if no main collection exists
      should return the parent collection marked as base when it exists
      should return the first parent collection marked as base when it exists
    #search_works
      should return works for this collection
      should not return works outside this collection when skipping elastic search
      uses elastic search when searching for text
      should not return works outside this collection when involving elastic search
    #sort_works_by
      should not accept noise
      should not valid value
    #show_availability_status
      returns false for collection1
      returns false for sub_collection_with_inherited_availability
      returns false for collection_with_availability
    #unique_short_code_from_self_or_base
      will return its own short code
      will return base collection short code if none set
    #works_including_child_works
      should return all child works
      should return child collections' works
    #work_attributes_present
      should return all the attributes used
      s cached equivalent should also return symbols
    #derived_work_attributes_present
      should return derived attributes used
      s cached equivalent should also return symbols
    #displayable_work_attributes_present
      returns only work attributes that are presented and available
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

Contact
  #name
    returns external contact if type is external
    returns name when set, even if type is external
    can save without an name when external

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

IdsHash
  .store
    creates or retrieves
  .init
    creates a hash
  .to_ranges
    returns ranges
  #ids
    returns ranges
    returns ranges complex

ImportCollection
  instance methods
    #write_json_work
      creates a simple work
      creates a new artist if id is given
      adds techniques
      works also for this

ImportCollection::Workbook
  instance methods
    #internal_header_row_offset
      should work humanely
    #workbook
      should update import settings
    #import_file_to_workbook_table
      should return the table
    #columns_for_select
      should not expose unsupported options
      should include must have appraisal keys
    #update
      should allow for updating import settings
    #read
      should work
      should import into a different collection when sub
      should not import into a different collection when not a child

ImportCollection
  instance methods
    #name
      should return a name even when no file has been uploaded

ImportCollection::Strategies::SplitStrategies
  class methods
    .split_space
      should work

Location
  #name
    is required
    is required to have more than white spaces
    is ok to be a word
    splits to address if not persisted
    does not split to address if persisted

Message
  callbacks
    should not mark initial message as actioned upon when not qkunst
    should not mark initial message as actioned upon when qkunst
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

OAuthGroupMapping
  .for
    returns nothing when data is empty
    returns relevant when existing
  .role_mappings_exists_for?
    returns false when none
    returns false when none
  .collection_mappings_exists_for?
    returns false when none
    returns false when none
  .create
    creates with valid data

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
  .fields_without_aggregates
    doesn't contain any aggregation fields
    does contain basic fields
  .aggregations
    expected build result

SimpleArtist
  instance methods
    #name
      should return no name given string by default
      should return full name (with years when given)
      can render places as well
      should allow for human rendering
    #to_json_for_simple_artist
      should work

SimpleImportCollection
  initialization
    sets defaults
  #import_settings
    only matches a single field
    doesn't split
    replaces
    reproduces system names
    reproduces human names of attributes
    reproduces human names of has and belongs to manies (PENDING: Temporarily skipped with xit)
    ods file
      reproduces system names
      reproduces human names of attributes
  #write
    writes
    adds missing works
    adds updated fields
    import_collection_file.ods
      imports correctly
    import_collection_file.xlsx
      imports correctly

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

TimeSpan
  .new & validations
    concept
      is valid when subject, collection and contact are set
      is not valid when work is no longer available, collection and contact are set
      is not valid when classification is false, but subject, collection and contact are set
      is valid when classification is reservation and work is in use
      is valid when work was reserved but will now be lent
      is is not valid when work was lent but will now be lent
    finished
      doesn't override end time
    import failurs
      should work for all examples
  Callbacks
    #remove_work_from_collection_when_purchase_active
    #sync_time_spans_for_works_when_work_set
      creates none when a work
      creates time spans when for works in a work_set
      results in underlying works to be no longer available
      updates contact when time span is updated and time span is connected
      updates the status when work set's time span is updated and time span is connected
      doesn't update contact when time span is updated and time span is not connected
      disconnects time spans if work is removed from work set
      #significantly_update_works!
        significantly updates edit status of works
        triggers async reindex of work
      rental outgoing
        results in underlying works to become available when returned
        results in underlying works to become available when converted to concept
        results in underlying works to become available when ended
  instance methods
    #current?
      is expected to be truthy
      is expected to be truthy
      is expected to be truthy
      is expected to be truthy
      is expected not to be truthy
      is expected not to be truthy
      should include expired, active time spans
    #finished?
      is expected to be falsey
      is expected to be falsey
      is expected to be falsey
      is expected to be falsey
      is expected to be falsey
      is expected to be falsey
      is expected not to be falsey
      is expected to be falsey
    #next_time_span
      returns the next one for the same subject
      returns nil when no next time span exist
  scopes
    .current / .period
      is expected to include #<TimeSpan id: 900254696, starts_at: "2000-01-02 01:00:00.000000000 +0100", ends_at: nil, contact_id:...06-18 21:45:37.761378000 +0200", uuid: "time_span1", time_span_id: nil, comments: nil, old_data: {}>
      is expected to include #<TimeSpan id: 900254696, starts_at: "2000-01-02 01:00:00.000000000 +0100", ends_at: nil, contact_id:...06-18 21:45:37.761378000 +0200", uuid: "time_span1", time_span_id: nil, comments: nil, old_data: {}>
      is expected to include #<TimeSpan id: 748788316, starts_at: "2000-01-03 01:00:00.000000000 +0100", ends_at: nil, contact_id:...06-18 21:45:37.761378000 +0200", uuid: "time_span2", time_span_id: nil, comments: nil, old_data: {}>
      is expected to include #<TimeSpan id: 748788316, starts_at: "2000-01-03 01:00:00.000000000 +0100", ends_at: nil, contact_id:...06-18 21:45:37.761378000 +0200", uuid: "time_span2", time_span_id: nil, comments: nil, old_data: {}>
      is expected to include #<TimeSpan id: 463907531, starts_at: "2000-01-04 01:00:00.000000000 +0100", ends_at: "2400-01-01 01:0...06-18 21:45:37.761378000 +0200", uuid: "time_span3", time_span_id: nil, comments: nil, old_data: {}>
      is expected to include #<TimeSpan id: 463907531, starts_at: "2000-01-04 01:00:00.000000000 +0100", ends_at: "2400-01-01 01:0...06-18 21:45:37.761378000 +0200", uuid: "time_span3", time_span_id: nil, comments: nil, old_data: {}>
      is expected to include #<TimeSpan id: 96616300, starts_at: "2000-01-01 01:00:00.000000000 +0100", ends_at: "2400-01-01 01:00...06-18 21:45:37.761378000 +0200", uuid: "time_span4", time_span_id: nil, comments: nil, old_data: {}>
      is expected to include #<TimeSpan id: 96616300, starts_at: "2000-01-01 01:00:00.000000000 +0100", ends_at: "2400-01-01 01:00...06-18 21:45:37.761378000 +0200", uuid: "time_span4", time_span_id: nil, comments: nil, old_data: {}>
      is expected not to include #<TimeSpan id: 524174866, starts_at: "1950-01-01 01:00:00.000000000 +0100", ends_at: "1982-01-01 01:0...:45:37.761378000 +0200", uuid: "time_span_historic", time_span_id: nil, comments: nil, old_data: {}>
      is expected not to include #<TimeSpan id: 524174866, starts_at: "1950-01-01 01:00:00.000000000 +0100", ends_at: "1982-01-01 01:0...:45:37.761378000 +0200", uuid: "time_span_historic", time_span_id: nil, comments: nil, old_data: {}>
      is expected not to include #<TimeSpan id: 116402804, starts_at: "2100-01-01 01:00:00.000000000 +0100", ends_at: "2105-01-01 01:0...21:45:37.761378000 +0200", uuid: "time_span_future", time_span_id: nil, comments: nil, old_data: {}>
      is expected not to include #<TimeSpan id: 116402804, starts_at: "2100-01-01 01:00:00.000000000 +0100", ends_at: "2105-01-01 01:0...21:45:37.761378000 +0200", uuid: "time_span_future", time_span_id: nil, comments: nil, old_data: {}>
      should include expired, active time spans
      should include all when period is extreme
      should include only future and when period is extreme future
      should include only past and current when period is extreme history till now
    .active
      is expected not to include #<TimeSpan id: 900254696, starts_at: "2000-01-02 01:00:00.000000000 +0100", ends_at: nil, contact_id:...06-18 21:45:37.761378000 +0200", uuid: "time_span1", time_span_id: nil, comments: nil, old_data: {}>
      is expected not to include #<TimeSpan id: 748788316, starts_at: "2000-01-03 01:00:00.000000000 +0100", ends_at: nil, contact_id:...06-18 21:45:37.761378000 +0200", uuid: "time_span2", time_span_id: nil, comments: nil, old_data: {}>
      is expected not to include #<TimeSpan id: 463907531, starts_at: "2000-01-04 01:00:00.000000000 +0100", ends_at: "2400-01-01 01:0...06-18 21:45:37.761378000 +0200", uuid: "time_span3", time_span_id: nil, comments: nil, old_data: {}>
      is expected not to include #<TimeSpan id: 96616300, starts_at: "2000-01-01 01:00:00.000000000 +0100", ends_at: "2400-01-01 01:00...06-18 21:45:37.761378000 +0200", uuid: "time_span4", time_span_id: nil, comments: nil, old_data: {}>
      is expected to include #<TimeSpan id: 764037225, starts_at: "2020-01-01 01:00:00.000000000 +0100", ends_at: "2021-01-01 01:0...1:45:37.761378000 +0200", uuid: "time_span_expired", time_span_id: nil, comments: nil, old_data: {}>
      is expected to include #<TimeSpan id: 84273152, starts_at: "2010-01-01 01:00:00.000000000 +0100", ends_at: nil, contact_id: ...21:45:37.761378000 +0200", uuid: "time_span_active", time_span_id: nil, comments: nil, old_data: {}>
      is expected to include #<TimeSpan id: 942982376, starts_at: "2021-01-01 13:00:00.000000000 +0100", ends_at: nil, contact_id:...e_span_collection_with_availability_sold_with_t...", time_span_id: nil, comments: nil, old_data: {}>
    .expired
      is expected not to include #<TimeSpan id: 900254696, starts_at: "2000-01-02 01:00:00.000000000 +0100", ends_at: nil, contact_id:...06-18 21:45:37.761378000 +0200", uuid: "time_span1", time_span_id: nil, comments: nil, old_data: {}>
      is expected not to include #<TimeSpan id: 748788316, starts_at: "2000-01-03 01:00:00.000000000 +0100", ends_at: nil, contact_id:...06-18 21:45:37.761378000 +0200", uuid: "time_span2", time_span_id: nil, comments: nil, old_data: {}>
      is expected not to include #<TimeSpan id: 463907531, starts_at: "2000-01-04 01:00:00.000000000 +0100", ends_at: "2400-01-01 01:0...06-18 21:45:37.761378000 +0200", uuid: "time_span3", time_span_id: nil, comments: nil, old_data: {}>
      is expected not to include #<TimeSpan id: 96616300, starts_at: "2000-01-01 01:00:00.000000000 +0100", ends_at: "2400-01-01 01:00...06-18 21:45:37.761378000 +0200", uuid: "time_span4", time_span_id: nil, comments: nil, old_data: {}>
      is expected not to include #<TimeSpan id: 524174866, starts_at: "1950-01-01 01:00:00.000000000 +0100", ends_at: "1982-01-01 01:0...:45:37.761378000 +0200", uuid: "time_span_historic", time_span_id: nil, comments: nil, old_data: {}>
      is expected not to include #<TimeSpan id: 116402804, starts_at: "2100-01-01 01:00:00.000000000 +0100", ends_at: "2105-01-01 01:0...21:45:37.761378000 +0200", uuid: "time_span_future", time_span_id: nil, comments: nil, old_data: {}>
      should include expired, active time spans

User
  methods
    #accessible_collections
      should return all collections when admin (except when not qkunst managed)
      should return all collections when the user is a super admin
      should return all collections and sub(sub)collections the user has access to
      should restrict find
    #accessible_artists
      should return all artists for admin
      should return a subset for users with a single collection
    #accessible_works
      should return all works for admin
      should return a subset for users with a single collection
    #accessible_time_spans
      should return all timespans for admin
      should not return all timespans for admin
      should return all timespans for subcollections
      should return timespans from parent collections of collection_with_works_child
    #accessible_work_sets
      should return all timespans for admin
      should not return timespans for collection with works child user
      should return a timespan for qkunst_with_collection
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
      auto subscribes a user to a role when configured as such
      auto subscribes a user to a role and group when configured as such
      auto overides a user's memberschip when configured as such
      auto overides a user's memberschip when configured as such
      leaves a user's memberschip as is when not configured as such
      it updates account, even when case doesn't match
      always accepts the highest role
  Callbacks
    name change should result in name changes with work
      should change

Validators::CollectionScopeValidator
  validates properly
    works with theme in own collection
    works with theme in super collection
    works with theme in hidden super collection
    should fail on theme in other collection

Work::CustomParameterRendering
  #business_rent_price_ex_vat
    doesn't return anything when selling price is nil
    works for other pairs
  #default_rent_price_ex_vat
    doesn't return anything when selling price is nil
    works for other pairs

Work::Export
  class methods
    .possible_exposable_fields
      should return possible_exposable_fields
    .to_workbook
      should be callable and return a workbook
      should be work even with complex fieldset
      should work with tags
      should return basic types
      should allow for sorting by location
  Instance methods
    #artist_#{index}_methods
      should have a first artist
      should return nil when no artist is found at index

Work::ParameterRendering
  constants
    DISPLAYED_PROPERTIES
      contains all the fields from the detailed data erb
  artist_name
    should keep a log of changed artists
  #artist_name_rendered
    should not fail on an empty name
    should summarize the artists nicely
    should respect include_years option
  #artist_name_rendered_without_years_nor_locality
    should summarize the artist nicely
    should summarize the artists nicely
  #artist_name_rendered_without_years_nor_locality_semicolon_separated
    should summarize the artist nicely
    should summarize the artists nicely
  #location_raw, #location_floor_raw, #location_detail_raw
    returns not set when nil
    returns values when set
  #ppid_url
    returns nil by default
    returns a ppid url when code is present on collection
    returns a ppid url when code contains spaces

Work::Search
  instance methods
    #as_indexed_json
      returns an empty hash when nothing is set
      returns an empty hash when nothing is set
      doesn't include availability_status if not active for collection
      does include availability status when active
  class methods
    .build_search_and_filter_query
      returns a hash
      filters for ids

Work::SizingRendering
  #three_dimensional?
    returns false for an empty work
    returns false for a 2d work
    returns false for a 2d work with a 9cm deep frame
    returns false for a 3d work
  #floor_bound?
    returns false for an empty work
    returns false for a 2d work
    returns false for a 2d work with a 9cm deep frame
    returns false for a 3d work
  #wall_surface
    returns false for an empty work
    returns square meter for a 2d work
    returns square meter for a 2d work
    returns nil for a 3d work
  #wall_surface
    returns nil for an empty work
    returns nil  for a 2d work
    returns values for a 3d work
  #object_format_code
    should return proper format code
  .whd_to_s
    should render nil if all are nil
    should render w x h x d if set
    should round w x h x d
    should add diameter if set
    should add diameter if set
  .frame_size
    should use whd_to_s
  #work_size
    should return work size
  #frame_size
    should return frame size
  #frame_size_with_fallback
    should return frame size by default
    should return work size if frame size is not present
  #orientation
    should return  for  x

Work::TimeSpans
  instance methods
    #current_active_time_span
      returns nil by default
      returns active time span by default
      returns reservation if none active
      returns active time span by default even when reservation is later
    #available?
      is available by default
      is not available when sold
      is not available when it is actively rented
      is available when it is concept rented

WorkSet
  has and belongs to many works
  requires a type
  scopes
    .accepts_appraisals
      should return only diptych
  validations
    cannot have works exist in two appraisable sets
    can have works exist in a multiple sets that are not all appraisable
  class methods
    .find_by_uuid_or_id!
      raises when not found
    .find_by_uuid_or_id
      returns nothing when nothing is present
      returns nil when nil is sent
      finds by uuid
      finds by id
  instance methods
    #appraisable?
    #current_active_time_span
      may not have a current active time span
      will only return active workset
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
    #save
      significantly updates edit status of works
      triggers async reindex of work
    #update_with_works_filter_params
      shouldn't do anything when nothing is set
      should filter by ids
    #dynamic?
      should return false when filter is present with collection
      should return true when filter is defined wit collection

WorkSetType
  add some examples to (or delete) /Users/murb/Documents/Zakelijk/Projecten/QKunst/source-collectiemanagement/spec/models/work_set_type_spec.rb (PENDING: Not yet implemented)

Work
  callbacks
    significantly_updated_at
      does not update when nothing changed
      does update on create
      does update on a title change
      does update on a publish
      does update on a artist change
  instance methods
    #all_work_ids_in_collection
      sorts by default on inventory and id
      can sort on super collection
    #appraisable?
      should return true by default
      should return false on a work part of a diptych
    #appraised?
      should return false by default
      should return true for an appraised work
    #balance_category
      returns nil none is set, balance category when set, and nil when appraised, but set
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
    #highlight, #highlight_priority
      defaults to false
      returns true when > 0
      returns nil for prio 0
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
    #main_location=
      updates location
    #main_location_id=
      sets the location id when number
      updates location
      sets the location id when numberstring
      creates a new location when main_location_id is not a number
      reuses an existing location when main_location_id is not a number, but the same location is found by the name
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
    .count_as_whole_works
      should return all works uniquele
      should return all works uniquely even when in two work sets
    .fast_aggregations
      should allow to be initialized
    .update
      updates collection
      throws error when updating a work that doesn't validate
    .column_types
      returns a hash
      should return  for {inventoried: :boolean, title: :string}
    .significantly_updated!
      marks all works as significantly updated
      schedules reindex jobs
  Scopes
    .by_group
      has and belongs to many
        returns works when id is passed in array
        returns relationless works when :not_set is passed in array
        returns relationless works and works with relations when both :not_set and and id is passed
      belongs to
        returns works when id is passed in array
        returns relationless works when :not_set is passed in array
        returns relationless works and works with relations when both :not_set and and id is passed
      string to
        returns works when id is passed in array
        returns relationless works when :not_set is passed in array
        returns relationless works and works with relations when both :not_set and and id is passed
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
    .significantly_updated_since
      returns nothing when future
      returns only matching work
    .created_at_between
      works
    .sold_between
      doesn't find a work when time period doesn't match any
      does find a work if it is before a certain end date
      does find a work matching a very short period around the selling date
      does not find a work matching a very short period just before the selling date
    .outgoing_rental_between
      expect period to include current and past lendings if < Time.now
      expect period to include only active and expired lendings if 1.day.ago < Time.now
      expect period to include only historic lendings if < active

WorkStatus
  #set_work_as_removed_from_collection's impact on work
    doesn't result in a work being set as removed from collection if not set
    does result in a work being set as removed from collection if set
    doesn't update an already removed work if set

Api::V1::CollectionsController
  GET /api/v1/collections
    shouldn't be publicly accessible!
    an api user without advisor role should be access the collection
    an api user with advisor role should be access the collection
    an allowed user should be able to get a single work through the api
    even an allowed user shouldn't be able to mess with the url
    not allowed user should be not be able to get an index

Api::V1::TimeSpansController
  POST api/v1/work/:work_id/time_spans
    returns a 404, even as an admin, no writing
  GET api/v1/work/:work_id/time_spans
    returns unauthorized when not logged in
    admin
      returns all as an admin
      allows for filtering on external contact url
      subject_type
        allows for filtering on subject typed
      ends_at_lt
        allows for filtering on end date
        returns more when filtering on future end date
    advisor
      allows for filtering on external contact url

Api::V1::WorkEventsController
  POST api/v1/work/:work_id/work_events
    unauthorized when not signed in
    signed in
      starts a rental
      starts a reservation
      starts a rental from a reservation
      cannot start a rental twice when signed in
      can start a reservation after a rental when signed in
      ends a rental when signed in

Api::V1::TimeSpansController
  GET api/v1/work_sets/:id
    returns a 404, even as an admin, when not found
    returns a 200, even when found
  GET api/v1/work/:work_id/time_spans
    returns unauthorized when not logged in
    admin
      returns all as an admin
      allows for filtering on external contact url
      subject_type
        allows for filtering on subject typed
      ends_at_lt
        allows for filtering on end date
        returns more when filtering on future end date
    advisor
      allows for filtering on external contact url

Api::V1::WorksController
  anonymously
    GET api/v1/works/
      returns unauthorized
  advisor
    GET api/v1/works/:id
      includes time_spans
  facility_manager
    GET api/v1/works/
      returns ok
      doesn't return works outside own collections
      returns meta
      modifies total_count when filter is present
      allows for sorting on id
      allows for pagination based on id
      returns all desired fields
      plucks
  admin
    GET /api/v1/collections/:collection_id/works #index
      allows for filtering on currently rent
      returns a work set with work set type
      only returns published works, when set, even when admin is true
    GET /api/v1/collections/:collection_id/works/:id #show
      only returns published works, when set, even when admin is true
      api_setting_expose_only_published_works: true
        only returns published works, when set, even when admin is true

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
  Collection
    GET collection/id/artists
      shouldn't be publicly accessible
      should be accessible by QKunst having access to collection
    GET collection/:collection_id/artists/:id
      shouldn't be publicly accessible
      should be accessible by QKunst having access to collection
      should not give access to artists not visible in collection
      should not expose attachments outside original collection

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
    redirects when no user is logged in
  POST /batch_photo_uploads
    redirects when no user is logged in
    creates thumbs when upload is started (PENDING: Temporarily skipped with xit)

WorkBatchs
  GET /collections/:id/batch/
    Collection defense
      shouldn't be publicly accessible!
      should be accessible when logged in as admin
      should not be accessible when logged in as an anonymous user
      should not be accessible when logged in as an registrator user
      should not allow accesss to the batch editor for non qkunst user has access to
      should redirect to the root when accessing anohter collection
    Selection of works
      by ids
        should work for get with selected_works array
        should work for post with selected_works array
      with filter
        off
        on
          works
      with search
        off
        on
          works
      by cluster group
        should work for post with cluster ids
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
      allows for group selections
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

/contacts
  GET /index
    renders a successful response
  GET /show
    renders a successful response
  GET /new
    renders a successful response
  GET /edit
    doesn't allow for an anonymous request
    doesn't allow a user without acces to the collection to edit the contact
    does allow an advisor with access to the collection to edit the the contact
  POST /create
    with valid parameters
      creates a new Contact
      redirects to the created contact
    with invalid parameters
      does not create a new Contact
  PATCH /update
    with valid parameters
      updates the requested contact
      redirects to the contact
  DELETE /destroy
    destroys the requested contact
    redirects to the contacts list

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

RKD::Artists
  GET /rkd_artists
    shouldn't be publicly accessible
    should be accessible by QKunst
    should not be accessible by facility_manager
    should be accessible by admin
  GET /rkd_artists/123
    shouldn't be publicly accessible
    should be accessible by QKunst
    should not be accessible by facility_manager
    should be accessible by admin

ShortCodeResolvers
  GET /resolve
    returns http not found for unknown collection code
    returns http not found for unknown work code
    redirects when known combi is given

SimpleImportCollections
  when not logged in
    GET #new
      returns http redirect
    POST #create
      returns http redirect
  when logged in as advisor
    GET #new
      returns http success
    POST #create
      will evaluat the params

Stages
  GET /stages
    rejects

/collection/:id/time_spans
  GET /index
    renders a successful response
    renders a successful response form
    renders an authorized response for advisor
    renders an unauthorized response for registrator
  POST /create
    as admin
      with valid parameters and a workset
        creates a new TimeSpan
        redirects to the created time_span
      with invalid parameters
        does not create a new TimeSpan
        renders a successful response (i.e. to display the 'new' template)

/collection/:id/work_sets
  signed in
    GET #index
      responds
    GET #show
      responds in collection context
      responds outside collection context
      highlights works that do not belong to the same contact

Works
  PATCH /collections/:collection_id/works/:id
    should render the edit form when changing location fails
    should allow for updating work status
    collection attributes
      should allow for updating collection attributes
  DELETE /collections/:colletion_id/work_id
    allows access for admin
    denies access for facility_manager
    denies access for appraiser
    denies access for compliance
    denies access for advisor
  GET /collections/:id/works/:id/edit
    admin should be able to access edit page
  GET /collections/:id/works
    shouldn't be publicly accessible!
    admin
      should be accessible when logged in as admin
      should be able to get an index
      sorting and grouping
        should be able to get a grouped index
        should be able to sort
        should be able to filter and sort
        should be able to search
      downloading
        xlsx
          facility_manager
            should not be able to get the file
          admin
            should be able to get the file
        csv
          admin
            should be able to get the file
            should include alt_number_4
        zip
          admin
            should be able to get an zip file
            should be able to get an zip file with photos
            should be able to get an zip file with only front photos
        pdf
          schedules
          as=title_labels
            generates directly when as_labels
        xml
          anonymous
            requires login
          facility_manager
            rejects facility
          admin
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
  GET /collections/:collection_id/works/new
    allows access for admin
    allows access for advisor
    allows access for appraiser
    allows access for read_only
    allows access for compliance
    allows access for facility_manager
  GET /collections/:colletion_id/works/modified
    allows access for admin
    allows access for compliance
    allows access for advisor
    allows access for facility_manager
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

ContactsController
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
  renders attributes

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
  renders attributes

works/edit_tags
  allows_to_edit_tags

works/show
  renders attributes
  renders display price
  renders attachments
  display modes
    complete
      renders correctly
    detailed
      renders correctly
    detailed_discreet
      renders correctly

Collection::DownloadWorker
  works for xlsx
  works for csv

Collection::HtmlRendererWorker
  performs a basic renderer
  includes full urls; not just paths
  performs a filtered render
  accepts work_display_form
  doesn't export internal comments to facility manager
  doesn't show complete data to read only user
  does show basic data to read only
  does not render any data when none
  performs a grouped render
  triggers generation of a pdf

PdfPrinterWorker
  works for /

Pending: (Failures listed here are expected and do not affect your suite's status)

  1) CustomReportTemplatesController PUT #update with valid params updates the requested custom_report_template
     # Add a hash of attributes valid for your model
     # ./spec/controllers/custom_report_templates_controller_spec.rb:114

  2) MessagesController PUT #update should not allow an advisor to edit a message not belonging to a collection he/she manages
     # Temporarily skipped with xit
     # ./spec/controllers/messages_controller_spec.rb:55

  3) CustomReportTemplate add some examples to (or delete) /Users/murb/Documents/Zakelijk/Projecten/QKunst/source-collectiemanagement/spec/models/custom_report_template_spec.rb
     # Not yet implemented
     # ./spec/models/custom_report_template_spec.rb:19

  4) Geoname add some examples to (or delete) /Users/murb/Documents/Zakelijk/Projecten/QKunst/source-collectiemanagement/spec/models/geoname_spec.rb
     # Not yet implemented
     # ./spec/models/geoname_spec.rb:33

  5) GeonamesAdmindiv add some examples to (or delete) /Users/murb/Documents/Zakelijk/Projecten/QKunst/source-collectiemanagement/spec/models/geonames_admindiv_spec.rb
     # Not yet implemented
     # ./spec/models/geonames_admindiv_spec.rb:23

  6) GeonamesCountry add some examples to (or delete) /Users/murb/Documents/Zakelijk/Projecten/QKunst/source-collectiemanagement/spec/models/geonames_country_spec.rb
     # Not yet implemented
     # ./spec/models/geonames_country_spec.rb:33

  7) SimpleImportCollection#import_settings reproduces human names of has and belongs to manies
     # Temporarily skipped with xit
     # ./spec/models/simple_import_collection_spec.rb:53

  8) WorkSetType add some examples to (or delete) /Users/murb/Documents/Zakelijk/Projecten/QKunst/source-collectiemanagement/spec/models/work_set_type_spec.rb
     # Not yet implemented
     # ./spec/models/work_set_type_spec.rb:18

  9) BatchPhotoUploads POST /batch_photo_uploads creates thumbs when upload is started
     # Temporarily skipped with xit
     # ./spec/requests/batch_photo_uploads_spec.rb:23

Finished in 5 minutes 49 seconds (files took 4.92 seconds to load)
1495 examples, 0 failures, 9 pending


```