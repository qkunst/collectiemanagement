# Test report QKunst Collectiebeheer

Date: 2020-02-18 16:48:03 +0100

This report gives an overview of the test ran. This report is automatically created.

## Statistics

In total **92.74%** of the lines are covered by automated test. The code base consists of **8076** lines of code.

## Abilities

As a general note: except for administrators, user access is limited to a a selected set of collections.

### General abilities

This lists what a user can do per object-type.

a|Administrator | Kunstadviseur | Compliance | Taxateur | Facility Manager | Read-only
---|---|---|---|---|---|---
**Alles**|
*Beheren*|✔|✘|✘|✘|✘|✘
*Beheer (inclusief aanmaken) collectie in collectie-context*|✔|✔|✘|✘|✘|✘
*Overzicht tonen in collectie-context*|✔|✔|✘|✘|✘|✘
*Bewerk collectie in collectie-context*|✔|✔|✘|✘|✘|✘
**Rapport**|
*Beheren*|✔|✔|✘|✘|✘|✘
*Beheer (inclusief aanmaken) collectie in collectie-context*|✔|✔|✘|✘|✘|✘
*Overzicht tonen in collectie-context*|✔|✔|✔|✘|✘|✘
*Bewerk collectie in collectie-context*|✔|✔|✘|✘|✘|✘
*Lezen*|✔|✔|✔|✔|✘|✘
*Overzicht zien*|✔|✔|✔|✔|✘|✘
*Tonen*|✔|✔|✔|✔|✘|✘
**Bericht**|
*Beheren*|✔|✔|✘|✘|✘|✘
*Lezen*|✔|✔|✔|✔|✔|✘
*Overzicht zien*|✔|✔|✔|✔|✔|✘
*Tonen*|✔|✔|✔|✔|✔|✘
*Aanmaken & opslaan*|✔|✔|✘|✔|✔|✘
*Aanmaken*|✔|✔|✘|✔|✔|✘
*Bewerken*|✔|✔|✘|✔|✘|✘
**Collectie**|
*Beheren*|✔|✔|✘|✘|✘|✘
*Beheer (inclusief aanmaken) collectie in collectie-context*|✔|✔|✘|✘|✘|✘
*Overzicht tonen in collectie-context*|✔|✔|✔|✘|✘|✘
*Bewerk collectie in collectie-context*|✔|✔|✘|✘|✘|✘
*Toegang tot de batch-editor*|✔|✔|✘|✔|✔|✘
*Kan foto's downloaden*|✔|✔|✔|✘|✔|✘
*Kan gegevens downloaden*|✔|✔|✔|✘|✘|✘
*Kan waardering zien*|✔|✔|✔|✘|✘|✘
*Rapportage lezen*|✔|✔|✔|✔|✔|✘
*Uitgebreide rapportage lezen*|✔|✔|✔|✔|✘|✘
*Waardering zien*|✔|✔|✔|✔|✔|✘
*Status inzien*|✔|✔|✔|✔|✔|✘
*Waarderingsreferentie lezen*|✔|✔|✔|✔|✘|✘
*Zoekmachine verversen*|✔|✔|✘|✔|✘|✘
*translation missing: nl.abilities.update_status*|✔|✔|✘|✘|✘|✘
*Aanmaken & opslaan*|✔|✔|✘|✘|✘|✘
*Aanmaken*|✔|✔|✘|✘|✘|✘
*Lezen*|✔|✔|✔|✔|✔|✔
*Overzicht zien*|✔|✔|✔|✔|✔|✔
*Tonen*|✔|✔|✔|✔|✔|✔
*Toegang tot beheer*|✔|✔|✔|✘|✘|✘
**Vervaardiger**|
*Opschonen*|✔|✘|✘|✘|✘|✘
*Combineren*|✔|✘|✘|✘|✘|✘
*Beheer (inclusief aanmaken) collectie in collectie-context*|✔|✔|✘|✔|✘|✘
*Overzicht tonen in collectie-context*|✔|✔|✔|✔|✘|✘
*Bewerk collectie in collectie-context*|✔|✔|✘|✔|✘|✘
*Aanmaken & opslaan*|✔|✔|✘|✔|✘|✘
*Aanmaken*|✔|✔|✘|✔|✘|✘
*Bijwerken*|✔|✔|✘|✔|✘|✘
*Bewerken*|✔|✔|✘|✔|✘|✘
*Lezen*|✔|✔|✔|✔|✔|✔
*Overzicht zien*|✔|✔|✔|✔|✔|✔
*Tonen*|✔|✔|✔|✔|✔|✔
**Cluster**|
*Beheer (inclusief aanmaken) collectie in collectie-context*|✔|✔|✘|✘|✘|✘
*Overzicht tonen in collectie-context*|✔|✔|✔|✘|✘|✘
*Bewerk collectie in collectie-context*|✔|✔|✘|✘|✘|✘
**RKD Artist**|
*Lezen*|✔|✔|✔|✔|✘|✘
*Overzicht zien*|✔|✔|✔|✔|✘|✘
*Tonen*|✔|✔|✔|✔|✘|✘
*Kopieer*|✔|✔|✘|✔|✘|✘
**Bijlage**|
*Pas zichtbaarheid aan*|✔|✔|✘|✘|✘|✘
*Aanmaken & opslaan*|✔|✔|✘|✘|✘|✘
*Aanmaken*|✔|✔|✘|✘|✘|✘
*Bijwerken*|✔|✔|✘|✘|✘|✘
*Bewerken*|✔|✔|✘|✘|✘|✘
*Lezen*|✔|✘|✔|✘|✘|✘
*Overzicht zien*|✔|✘|✔|✘|✘|✘
*Tonen*|✔|✘|✔|✘|✘|✘
**Werk**|
*Foto's bewerken*|✔|✔|✘|✔|✘|✘
*Toon informatie achterzijde*|✔|✔|✔|✔|✔|✘
*Wijzig interne opmerkingen*|✔|✔|✔|✔|✘|✘
*Toon interne opmerkingen*|✔|✔|✘|✔|✘|✘
*Beheer locatie*|✔|✔|✘|✔|✔|✘
*Toon locatie*|✔|✔|✔|✔|✔|✘
*Bewerk locatie*|✔|✔|✘|✔|✔|✘
*Taggen*|✔|✔|✘|✔|✘|✘
*Details tonen*|✔|✔|✔|✔|✔|✘
*Bewerken*|✔|✔|✘|✔|✘|✘
*Lezen*|✔|✔|✔|✔|✔|✔
*Overzicht zien*|✔|✔|✔|✔|✔|✔
*Tonen*|✔|✔|✔|✔|✔|✔
*Beheren*|✔|✔|✘|✘|✘|✘
**Gebruiker**|
*Verwijderen*|✔|✘|✘|✘|✘|✘
*Administrator rol toekennen*|✔|✘|✘|✘|✘|✘
*Bijwerken*|✔|✔|✘|✘|✘|✘
*Bewerken*|✔|✔|✘|✘|✘|✘
*Lezen*|✔|✘|✔|✘|✘|✘
*Overzicht zien*|✔|✘|✔|✘|✘|✘
*Tonen*|✔|✘|✔|✘|✘|✘
**Vervaardigersbetrekking**|
*Aanmaken & opslaan*|✔|✔|✘|✔|✘|✘
*Aanmaken*|✔|✔|✘|✔|✘|✘
*Bijwerken*|✔|✔|✘|✔|✘|✘
*Bewerken*|✔|✔|✘|✔|✘|✘
**Waardering**|
*Beheren*|✔|✔|✘|✔|✘|✘
*Lezen*|✔|✔|✔|✔|✘|✘
*Overzicht zien*|✔|✔|✔|✔|✘|✘
*Tonen*|✔|✔|✔|✔|✘|✘
**Import**|
*Lezen*|✔|✘|✔|✘|✘|✘
*Overzicht zien*|✔|✘|✔|✘|✘|✘
*Tonen*|✔|✘|✔|✘|✘|✘
*Overzicht tonen in collectie-context*|✔|✘|✔|✘|✘|✘
**Herinnering**|
*Lezen*|✔|✘|✔|✘|✘|✘
*Overzicht zien*|✔|✘|✔|✘|✘|✘
*Tonen*|✔|✘|✔|✘|✘|✘
*Overzicht tonen in collectie-context*|✔|✔|✔|✘|✘|✘
**Thema**|
*Overzicht tonen in collectie-context*|✔|✔|✔|✘|✘|✘
**Eigenaar**|
*Overzicht tonen in collectie-context*|✔|✔|✔|✘|✘|✘

### Write access

This is a list of fields a user can write to

-|Administrator | Kunstadviseur | Compliance | Taxateur | Facility Manager | Read-only
---|---|---|---|---|---|---
**works_attributes**|
*location_detail*|✔|✔|✘|✔|✔|✘
*location*|✔|✔|✘|✔|✔|✘
*location_floor*|✔|✔|✘|✔|✔|✘
*internal_comments*|✔|✔|✘|✔|✘|✘
*photo_front*|✔|✔|✘|✔|✘|✘
*photo_back*|✔|✔|✘|✔|✘|✘
*photo_detail_1*|✔|✔|✘|✔|✘|✘
*photo_detail_2*|✔|✔|✘|✔|✘|✘
*remove_photo_front*|✔|✔|✘|✔|✘|✘
*remove_photo_back*|✔|✔|✘|✔|✘|✘
*remove_photo_detail_1*|✔|✔|✘|✔|✘|✘
*remove_photo_detail_2*|✔|✔|✘|✔|✘|✘
*inventoried*|✔|✔|✘|✔|✘|✘
*refound*|✔|✔|✘|✔|✘|✘
*new_found*|✔|✔|✘|✔|✘|✘
*locality_geoname_id*|✔|✔|✘|✔|✘|✘
*imported_at*|✔|✔|✘|✔|✘|✘
*import_collection_id*|✔|✔|✘|✔|✘|✘
*stock_number*|✔|✔|✘|✔|✘|✘
*alt_number_1*|✔|✔|✘|✔|✘|✘
*alt_number_2*|✔|✔|✘|✔|✘|✘
*alt_number_3*|✔|✔|✘|✔|✘|✘
*artist_unknown*|✔|✔|✘|✔|✘|✘
*title*|✔|✔|✘|✔|✘|✘
*title_unknown*|✔|✔|✘|✔|✘|✘
*description*|✔|✔|✘|✔|✘|✘
*object_creation_year*|✔|✔|✘|✔|✘|✘
*object_creation_year_unknown*|✔|✔|✘|✔|✘|✘
*medium_id*|✔|✔|✘|✔|✘|✘
*frame_type_id*|✔|✔|✘|✔|✘|✘
*signature_comments*|✔|✔|✘|✔|✘|✘
*no_signature_present*|✔|✔|✘|✔|✘|✘
*print*|✔|✔|✘|✔|✘|✘
*print_unknown*|✔|✔|✘|✔|✘|✘
*frame_height*|✔|✔|✘|✔|✘|✘
*frame_width*|✔|✔|✘|✔|✘|✘
*frame_depth*|✔|✔|✘|✔|✘|✘
*frame_diameter*|✔|✔|✘|✔|✘|✘
*height*|✔|✔|✘|✔|✘|✘
*width*|✔|✔|✘|✔|✘|✘
*depth*|✔|✔|✘|✔|✘|✘
*diameter*|✔|✔|✘|✔|✘|✘
*condition_work_id*|✔|✔|✘|✔|✘|✘
*condition_work_comments*|✔|✔|✘|✔|✘|✘
*condition_frame_id*|✔|✔|✘|✔|✘|✘
*condition_frame_comments*|✔|✔|✘|✔|✘|✘
*information_back*|✔|✔|✘|✔|✘|✘
*other_comments*|✔|✔|✘|✔|✘|✘
*source_comments*|✔|✔|✘|✔|✘|✘
*subset_id*|✔|✔|✘|✔|✘|✘
*public_description*|✔|✔|✘|✔|✘|✘
*grade_within_collection*|✔|✔|✘|✔|✘|✘
*entry_status*|✔|✔|✘|✔|✘|✘
*entry_status_description*|✔|✔|✘|✔|✘|✘
*abstract_or_figurative*|✔|✔|✘|✔|✘|✘
*medium_comments*|✔|✔|✘|✔|✘|✘
*main_collection*|✔|✔|✘|✔|✘|✘
*image_rights*|✔|✔|✘|✔|✘|✘
*publish*|✔|✔|✘|✔|✘|✘
*cluster_name*|✔|✔|✘|✔|✘|✘
*collection_id*|✔|✔|✘|✔|✘|✘
*cluster_id*|✔|✔|✘|✔|✘|✘
*owner_id*|✔|✔|✘|✔|✘|✘
*placeability_id*|✔|✔|✘|✔|✘|✘
*artist_ids*|✔|✔|✘|✔|✘|✘
*source_ids*|✔|✔|✘|✔|✘|✘
*damage_type_ids*|✔|✔|✘|✔|✘|✘
*frame_damage_type_ids*|✔|✔|✘|✔|✘|✘
*theme_ids*|✔|✔|✘|✔|✘|✘
*object_category_ids*|✔|✔|✘|✔|✘|✘
*technique_ids*|✔|✔|✘|✔|✘|✘
*selling_price*|✔|✔|✘|✔|✘|✘
*minimum_bid*|✔|✔|✘|✔|✘|✘
*purchase_price*|✔|✔|✘|✔|✘|✘
*purchased_on*|✔|✔|✘|✔|✘|✘
*purchase_year*|✔|✔|✘|✔|✘|✘
*selling_price_minimum_bid_comments*|✔|✔|✘|✔|✘|✘
**artists_attributes**|
*_destroy*|✔|✔|✘|✔|✘|✘
*first_name*|✔|✔|✘|✔|✘|✘
*last_name*|✔|✔|✘|✔|✘|✘
*prefix*|✔|✔|✘|✔|✘|✘
*place_of_birth*|✔|✔|✘|✔|✘|✘
*place_of_death*|✔|✔|✘|✔|✘|✘
*year_of_birth*|✔|✔|✘|✔|✘|✘
*year_of_death*|✔|✔|✘|✔|✘|✘
*description*|✔|✔|✘|✔|✘|✘
**appraisals_attributes**|
*appraised_on*|✔|✔|✘|✔|✘|✘
*market_value*|✔|✔|✘|✔|✘|✘
*replacement_value*|✔|✔|✘|✔|✘|✘
*market_value_range*|✔|✔|✘|✔|✘|✘
*replacement_value_range*|✔|✔|✘|✔|✘|✘
*appraised_by*|✔|✔|✘|✔|✘|✘
*reference*|✔|✔|✘|✔|✘|✘


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
    add attachment, change name

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

View report
  as an admin
  as a facility manager (limited)

Finished in 38.24 seconds (files took 2.53 seconds to load)
49 examples, 0 failures


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
      can destroy a collection the advisor has access to
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

UsersController
  GET /users
    is inaccessible by default
    is inaccessible by default even for most users
    is accessible for admins and advisors
  PUT /users/:id
    allows for a advisor to change a collection membership he/she is part of
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
    add attachment, change name

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
  #render_report_section
    should render a empt report when no values are given
    should render a simple report (with missing)
    should render a report with numbers
    should render a report with a string/key
    should created the proper nested urls
  #iterate_report_sections
    should work

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
  advisor
    Alias workings
      can manage_collection collection(:collection_with_works)
      can review_collection collection(:collection_with_works)
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
      can edit_location work(:work1)
      can read work(:work6)
      cannot read work(:work_with_private_theme)
      can show_details work(:work1)
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
  #save
    should update artist name at work
  #import
    should import basic params
    should not import name when middle name is given
    should import artist involvements
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
    for_role
      should always work for admin
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
    #self_and_parent_collections_flattened
      should return sorted from parent to child
    #parent_collections_flattened
      should return sorted from parent to child
    #parent_collections_flattened
      should return the oldest parent, then that child .
    #possible_parent_collections
      should return all collections if new
      should not return child collections
  Class methods
    .expand_with_child_collections
      returns child collections
      returns child collections until depth 1
      works with larger start-set that includes child
      works with larger start-set that does not  include child

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
    #collection_name_extended
      should have a logical order of parents
    #fields_to_expose
      should return almost all fields when fields_to_expose(:default)
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
      returns collections with root parent for admin user
      returns only base collection for user
    .for_user_expanded
      returns collections with root parent for admin user
      returns only base collection for user
  Scopes
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

ColumnCache
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
  add some examples to (or delete) /Users/murb/Documents/Zakelijk/Projecten/QKunst/source-collectiebeheer/spec/models/custom_report_template_spec.rb (PENDING: Not yet implemented)

Geoname
  add some examples to (or delete) /Users/murb/Documents/Zakelijk/Projecten/QKunst/source-collectiebeheer/spec/models/geoname_spec.rb (PENDING: Not yet implemented)

GeonameSummary
  Class methods
    .search
      should return an empty array when nil
      should return an empty array when not found

GeonamesAdmindiv
  add some examples to (or delete) /Users/murb/Documents/Zakelijk/Projecten/QKunst/source-collectiebeheer/spec/models/geonames_admindiv_spec.rb (PENDING: Not yet implemented)

GeonamesCountry
  add some examples to (or delete) /Users/murb/Documents/Zakelijk/Projecten/QKunst/source-collectiebeheer/spec/models/geonames_country_spec.rb (PENDING: Not yet implemented)

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
  scopes
    sent_at_date
      should work
    thread_can_be_accessed_by_user
      should work
      should block facility user from accessing messages from other collections
    collections
      should not contain messages with another collection message subject
      should include message about a collection's work
      should include messages about child collections (and works in those)

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
      should return all collections when admin
      should return all collections and sub(sub)collections the user has access to
      should restrict find
    #collection_accessibility_log
      should be empty when new
      should log accessible projects with name and id on save
      should log accessible projects with name and id on update
      should log accessible projects with name and id on update with ids
      should be retrievable from an earlier version
    #name
      should return name when set
      should return email when not set
    #role
      should return read_only by default
      should return read_only by default
    #roles
      should return read_only by default
      should return read_only by default, even for admin
    #works_created
      should count 2 for admin
    #accessible_users
      should return all users when admin
      should return no users when qkunst
      should return subset of users when advisor
  Callbacks
    name change should result in name changes with work
      should change

Work
  instance methods
    #all_work_ids_in_collection
      sorts by default on inventory and id
      can sort on super collection
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
    #save
      should save, even without info
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
    an allowed user should be able to get an index
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
    it refuses by default
    it refuses by qkunst
    it works for admin

Artists
  GET /artists
    shouldn't be publicly accessible
    shouldn't be accessible by QKunst
    should be accessible by admin
  GET collection/id/artists
    shouldn't be publicly accessible
    should be accessible by QKunst having access to collection
  POST /artists/clean
    shouldn't be publicly accessible!
    should be accessible when logged in as admin
    should not be accessible when logged in as qkunst

Attachments
  GET /attachments
    redirects by default
    redirects by default when not qkunst
    redirects by default when not qkunst (fm)
    redirects by default when qkunst without access
    success when qkunst with acces
    success when admin

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
    tag_list
      should REPLACE
      should APPEND
      should REMOVE

Clusters
  GET /clusters
    not accessible by default
    accessible by admin
    is not accessible by a random registrerd user
    is not accessible by a facility manager with access to the collection

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

FrameTypes
  GET /frame_types
    works! (now write some real specs)

Involvements
  GET /involvements
    works! (now write some real specs)

Messages
  GET /messages
    shouldn't be publicly accessible!

Reminders
  GET /reminders
    redirects

Stages
  GET /stages
    rejects

WorkBatchs
  GET /collections/:id/works/batch/edit
    shouldn't be publicly accessible!
    should be accessible when logged in as admin
    should not be accessible when logged in as an anonymous user
    should not allow accesss to the batch editor for non qkunst user has access to
    should redirect to the root when accessing anohter collection

Works
  PATCH /collections/:collection_id/works/:id
    should render the edit form when changing location fails
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
      downloading
        should be able to get an zip file
        should be able to get an zip file with photos
        should be able to get an zip file with only front photos
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

Pending: (Failures listed here are expected and do not affect your suite's status)

  1) CustomReportTemplatesController PUT #update with valid params updates the requested custom_report_template
     # Add a hash of attributes valid for your model
     # ./spec/controllers/custom_report_templates_controller_spec.rb:113

  2) CustomReportsController POST #create with invalid params returns a success response (i.e. to display the 'new' template)
     # Add a hash of attributes invalid for your model
     # ./spec/controllers/custom_reports_controller_spec.rb:109

  3) CustomReportsController PUT #update with valid params updates the requested custom_report
     # Add a hash of attributes valid for your model
     # ./spec/controllers/custom_reports_controller_spec.rb:122

  4) CustomReportsController PUT #update with invalid params returns a success response (i.e. to display the 'edit' template)
     # Add a hash of attributes invalid for your model
     # ./spec/controllers/custom_reports_controller_spec.rb:139

  5) CustomReportTemplate add some examples to (or delete) /Users/murb/Documents/Zakelijk/Projecten/QKunst/source-collectiebeheer/spec/models/custom_report_template_spec.rb
     # Not yet implemented
     # ./spec/models/custom_report_template_spec.rb:6

  6) Geoname add some examples to (or delete) /Users/murb/Documents/Zakelijk/Projecten/QKunst/source-collectiebeheer/spec/models/geoname_spec.rb
     # Not yet implemented
     # ./spec/models/geoname_spec.rb:6

  7) GeonamesAdmindiv add some examples to (or delete) /Users/murb/Documents/Zakelijk/Projecten/QKunst/source-collectiebeheer/spec/models/geonames_admindiv_spec.rb
     # Not yet implemented
     # ./spec/models/geonames_admindiv_spec.rb:6

  8) GeonamesCountry add some examples to (or delete) /Users/murb/Documents/Zakelijk/Projecten/QKunst/source-collectiebeheer/spec/models/geonames_country_spec.rb
     # Not yet implemented
     # ./spec/models/geonames_country_spec.rb:6

Finished in 58.62 seconds (files took 3.29 seconds to load)
635 examples, 0 failures, 8 pending


```
