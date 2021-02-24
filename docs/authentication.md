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

#### Role and collection based authorization

Like above, but complemented with logic that automatically couples users to subcollections. This logic is custom to every organization and will have to be agreed upon.

<!--#### Auto connect collection

Per collection can be configured whether:

* if SSO users are trusted without confirmation
* if users are trusted to access a single base collection without authorization based on parameters:
  - email domain match
  - sso system match
* if -->

## SSO Provider specific

### Microsoft Login

Different identifiers can be used for auto-provisioning through information received in the open-id token. When applying for semi-auto provisioning, please collect:

Minimal requirement:

* Tenant ID (allows us to identify the user group/organization)

Additionally:

* Group IDs (groups) and Role IDs (wids)

The QKunst application IDs are:

* production: cd4e2cd4-045b-4460-a109-b78bcc833fed (https://collectiemanagement.qkunst.nl)
* accept: 5ee084cf-0bea-48b2-83d9-09d5497096b0

QKunst Collectionmanagement is not available in the Azure Directory.