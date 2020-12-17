## Identity Access Management

### Identificatie

Identificatie geschied door invoer van een e-mail/wachtwoord inlog. De identiteit
wordt na registratie geverifieerd door een administrator. Pas daarna krijgt een
geregistreerde gebruiker toegang tot enige collectie.

### Toegang

#### Tot collecties

Administratoren hebben toegang tot alle collecties, en zijn ook in staat de rollen
van gebruikers aan te passen. Alle rol- en collectieaanpassingen worden op gebruikersmodel niveau automatisch gelogd.

Collecties zijn hierarchisch georganiseerd. Er zijn dus super- en sub-collecties.
Iemand met toegang tot een een collectie hoger in de hierarchie heeft automatisch
toegang tot alle onderliggende collecties.

Toegang tot een bepaald werk kan niet op het niveau van het individuele werk worden bepaald.

#### Tot functionaliteit

QKunst collectiemanagement kent een simpel rollenmodel. De rollen die worden onderscheiden zijn:

* Administrator
* Adviseur - als een administrator, maar dan beperkt tot collecties
* Taxateur - heeft toegang tot waarderingen en kan waarderen
* Compliance - heeft toegang als een adviseur, maar dan read-only
* Registrator - kan werken toevoegen, bewerken en bekijken
* Facility Manager - kan locaties muteren, en werken bekijken, kan ook waarderingen zien
* Read only - Kan alleen werken beperkt zien
* Inactieve gebruiker (read only gebruiker zonder toegang tot enige collectie)

Een gebruiker heeft slechts 1 basisrol, al is de functionaliteit van de rollen overlappend.

Al deze rollen kunnen worden uitgebreid met de rol *rollen beheerder*, waarmee die persoon in diens domein rollen kan toekennen aan gebruikers.

### Management

Het beheer van rollen en koppeling aan een collectie kan slechts gedaan worden door een administrator, of door een reguliere gebruiker met een rollenbeheer add-on rol.
