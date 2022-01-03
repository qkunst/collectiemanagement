# Authentication

## Username & password

Up until recently users were only able to identify themselves using username & password. After verification by either a QKunst administrator or an organization's role manager
a user was granted access to one or more collections with a specific role.

## SSO

QKunst Collectiemanagement supports Single Signon using the OAuth2 based OpenID protocol.

When your organization applies for SSO, your SSO solution will be connected to a base collection in the collection hierarchy.

This will allow you to automatically connect all or a subset of collection ids within that scope to users signing in with your SSO solution.
What these credentials are will be discussed while setting up the connection.

### Automatic authorization

See also [Identity Access Management](iam.md).

#### No authorization

If nothing is configured regarding mapping user's roles or groups to a role within QKunst Collectiemanagement a a user will end up in a pending state. Roles and
collections connected to the user can be configured who has been assigned the role-manager authorization within QKunst Collectiemanagment.

#### Role based authorization

The user's role, see [Identity Access Management](iam.md), is derived from groups/roles or other information contained in the [JSON Web Token](https://en.wikipedia.org/wiki/JSON_Web_Token) (JWT).
The user will not yet have any organizations associated to their role, which have to be asigned by a
role-manager (a QKunst Collectiemanagement role assigned to any member(s) within the organization) or administrator from QKunst.
When signing in the JWToken's information is processed and QKunst Collection management will adhere to the status received
(ie. if the role is updated in the organizations IAM-solution, the exposed functions in QKunst Collectionmanagement will update accordingly)

Role based authorization mitigates the risk that an employee who is no longer working for an organization still has access to data from that organization, it however does not
mitigate the risk that an employee has access to collections that this employee should not (in case of poor manual configuration) or no longer (change of position) have access to.

## SSO Provider specific

### Google Login

Google does not support groups, and hence only simple sign in is supported by Google. All authorizationmanagement will be done via the QKunst Collectionmanagement application.

### Microsoft Login

Different identifiers can be used for auto-provisioning through information received in the open-id token. When applying for semi-auto provisioning, please collect:

Minimal requirement:

* Tenant ID (allows us to identify the user group/organization); to the application the *issuer*: "https://login.microsoftonline.com/#{tenant}/v2.0"

Additionally:

* Group IDs (groups) and Role IDs (wids) (and how these map to either roles and collections in Qkunst Collectionmanagement)

The QKunst application IDs are:

* production: cd4e2cd4-045b-4460-a109-b78bcc833fed (https://collectiemanagement.qkunst.nl)
* accept: 5ee084cf-0bea-48b2-83d9-09d5497096b0

QKunst Collectionmanagement is not available in the Azure Directory.

### Central Login

[CentralLogin](https://gitlab.com/murb-org/central_login/) is an open source developed by [murb](https://murb.nl) that can be run on premise. To set up Central Login authentication it is required to provide QKunst with:

* the url of the CentralLogin-instance
* the id and secret of the registered application within CentralLogin
* The resources and roles that have been defined within the groups. It is advised that resources map to collections and roles to roles.

## Technical background

The QKunst application manager will create OAuthGroupMappings

    OAuthGroupMapping.create(
      issuer: "#{issuername}/#{url_or_identifier}",
      value_type: "role",
      value: "qkunst:facility",
      role: "facility_manager",
    )

    OAuthGroupMapping.create(
      issuer: "#{issuername}/#{url_or_identifier}",
      value_type: "resource", # (or wids)
      value: "qkunst:collections:collection_name",
      collection_id: 9
    )
