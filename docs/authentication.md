# Authentication

## SSO

QKunst Collectiemanagement supports Single Signon using the OAuth2 based OpenID protocol.

When your organization applies for SSO, your SSO solution will be connected to a base collection in the collection hierarchy.

This will allow you to automatically connect all or a subset of collection ids within that scope to users signing in with your SSO solution.
What these credentials are will be discussed while setting up the connection.

### The levels of authorization

#### No authorization

If nothing is configured regarding mapping user's roles or groups to a role within QKunst Collectiemanagement a a user will end up in a pending state. Roles and
collections connected to the user can be configured who has been assigned the role-manager authorization within QKunst Collectiemanagment.

#### Role based authorization

The user's role, see [Identity Access Management](iam.md), is derived from groups/roles or other information contained in the [JSON Web Token](https://en.wikipedia.org/wiki/JSON_Web_Token) (JWT).
The user will not yet have any organizations associated to their role (unless it is decided that every user will have full access to the organizations main collection), which have to be asigned by a
role-manager or administrator from QKunst. When signing in the JWToken's information is processed and QKunst Collection management will adhere to the status received
(ie. if the role is updated in the organizations IAM-solution, the exposed functions in QKunst Collectionmanagement will update accordingly)

#### Role and collection based authorization

Like above, but complemented with logic that automatically couples users to subcollections.

