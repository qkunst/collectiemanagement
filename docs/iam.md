# Identity Access Management

## Identification

A user may authenticate him or herself to the application through a username and password login, provided by the application itself, or by using an external authentication solution.
When an external authentication solution is used for a particular user account, username and password login is blocked for this user.

In case of a username / password registration, or an external authentication solution that does not allow for direct coupling between organization and/or roles, the identity
will be verified by either a QKunst-administrator or someone with a role manager function within the organization.

## Access

To see works within the application you both need collection access and a functional role.

### Collection-access

Collections are hierarchically organized. Someone with access to a collection as automatically access to the underlying collections. Access to certain works within a collection cannot be managed on work-level.

### Functional access (roles)

QKunst Collection Management has a relatively simple role-model. Roles discerned are:

* Administrator
* Advisor - like an administrator, but limited to the collections
* Appraiser - has access to valuations and can appraise
* Compliance - has access to everything, like and Advisor, but read-only.
* Registrar - can add works (in detail), edit and view works, but has no access to valuations
* Facility Manager - can update location, view works and view valuations
* Read only - has a limited view of the works
* Inactive worker (typically a read only user without access to any collection)

A user can only have one base-role; the functionality of the roles has functionality in common.

As of late 2020 roles can be extended with the role *role manager*, which allows individual users within the organization to update roles and access to collections to users within
their organization.

## Management

Management is performed by either a QKunst-administrator or a regular user with a role-management add-on role.

Administrators have access to all collections and can change all roles. Users with a role-management role can only manage roles up to the advisor role and are only able
to change collection access to collections in their scope.

All mutations in role and collection access are automatically logged by the system.