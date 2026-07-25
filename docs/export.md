# Export

QKunst supports several export formats. Which fields end up in an export depends
on the caller's authorization: only fields the current user is allowed to see
(server-side `@fields_to_expose`) are included. As a result, many rows below are
conditional in practice even when their cardinality lower bound is 0.

## EDM XML Export

Our EDM XML Export follows the [European Data Model](https://pro.europeana.eu/page/edm-documentation),
a European recommendation originating from [Europeana](https://www.europeana.eu/en).
Note that not all internal fields are exported; the goal is primarily to support
dissemination of heritage information.

### Document structure

A single export is a `<works>` element wrapping one `<edm:ProvidedCHO>` element
per artwork. All namespace declarations live on the root:

```xml
<works
  xmlns="https://qkunst.nl/work"
  xmlns:qkunst="https://qkunst.nl/work"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  xmlns:dcterms="http://purl.org/dc/terms/"
  xmlns:edm="http://www.europeana.eu/schemas/edm/"
  xmlns:ore="http://www.openarchives.org/ore/terms/"
  xmlns:owl="http://www.w3.org/2002/07/owl#"
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:foaf="http://xmlns.com/foaf/0.1/"
  xmlns:skos="http://www.w3.org/2004/02/skos/core#"
  xmlns:rdau="http://www.rdaregistry.info/Elements/u/"
  xmlns:wgs84_pos="http://www.w3.org/2003/01/geo/wgs84_pos#"
  xmlns:crm="http://www.cidoc-crm.org/cidoc-crm/"
  xmlns:cc="http://creativecommons.org/ns#"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
  <edm:ProvidedCHO>...</edm:ProvidedCHO>
  <edm:ProvidedCHO>...</edm:ProvidedCHO>
</works>
```

### edm:ProvidedCHO

The actual work.

| tag                                         | description                                                      | cardinality |
| ------------------------------------------- | ---------------------------------------------------------------- | ----------- |
| `dc:title`                                  | Title of the artwork                                             | 1..1        |
| `dcterms:alternative`                       | Free-form description (often used when title lacking)            | 0..1        |
| `dc:description`                            | Public description                                               | 1..1        |
| `dc:identifier`                             | Identifiers, each carrying an `xsi:scheme` attribute (see below) | 5..5        |
| `dcterms:creator` > `edm:Agent`             | Creator; see [edm:Agent](#edmagent)                              | 0..n        |
| `edm:isShownBy`                             | Photo file references (front, back, detail 1, detail 2)          | 0..4        |
| `edm:currentLocation`                       | Joined location string (`location;floor;detail`)                 | 0..1        |
| `edm:hasMet`                                | Locality, linked to a GeoNames resource                          | 0..1        |
| `dc:date`                                   | Object creation year                                             | 1..1        |
| `dc:type`                                   | Object categories (non-hidden)                                   | 0..n        |
| `dc:subject`                                | Free-form public tags                                            | 0..n        |
| `dcterms:extent`                            | Sizing information; see [Dimensions](#dimensions)                | 0..11       |
| `qkunst:technique`                          | Techniques (no AAT linkage)                                      | 0..n        |
| `qkunst:medium` / `medium`                  | Medium name (see notes)                                          | 0..2        |
| `qkunst:photo_file_name`                    | Original photo filename                                          | 0..1        |
| `qkunst:signature_comments`                 | Signature comments, with `not_present` attribute                 | 0..1        |
| `print` / `qkunst:print`                    | Print flag, with `unknown` attribute                             | 0..1        |
| `qkunst:market_value` (`_min`/`_max`)       | Market value                                                     | 0..3        |
| `qkunst:replacement_value` (`_min`/`_max`)  | Replacement value                                                | 0..3        |
| `qkunst:purchase_price`                     | Purchase price (raw value)                                       | 0..1        |
| `qkunst:purchase_price_in_eur`              | Purchase price converted to EUR                                  | 0..1        |
| `qkunst:purchase_price_currency_id`         | Currency ID for the raw purchase price                           | 0..1        |
| `qkunst:selling_price_minimum_bid_comments` | Comments on selling price / minimum bid                          | 0..1        |
| See [Free-form fields](#free-form-fields)   | Additional `qkunst:*` free-form fields                           | 0..n        |

#### dc:identifier schemes

Each `dc:identifier` carries an `xsi:scheme` attribute identifying its origin:

- `qkunst:stock_number`
- `qkunst:stock_number_file_safe` (when exported as .zip, photo files are renamed to match this number)
- `qkunst:alt_number_1`
- `qkunst:alt_number_2`
- `qkunst:alt_number_3`

#### Dimensions

Dimensions are exported as `dcterms:extent` elements. Each has a
`qkunst:describes` attribute at the top level and four nested children that
carry the actual payload:

```xml
<dcterms:extent qkunst:describes="work">
  <qkunst:describes>work</qkunst:describes>
  <qkunst:dimension>height</qkunst:dimension>
  <qkunst:value>42.5</qkunst:value>
  <qkunst:unit>cm</qkunst:unit>
</dcterms:extent>
```

Up to eleven dimension elements can be emitted per work, corresponding to:

| `describes` | `dimension` values             |
| ----------- | ------------------------------ |
| `work`      | height, width, depth, diameter |
| `frame`     | width, depth, diameter         |
| `outer`     | height, width, depth, diameter |

### edm:Agent

Creator. Wrapped inside a `dcterms:creator` element, one per artist.

| tag              | description                                                                       | cardinality |
| ---------------- | --------------------------------------------------------------------------------- | ----------- |
| `skos:prefLabel` | Name                                                                              | 0..1        |
| `edm:begin`      | Date (or year) of birth                                                           | 0..1        |
| `edm:end`        | Date (or year) of death                                                           | 0..1        |
| `rdau:P60599`    | Date (or year) of birth (RDA vocabulary; duplicate of `edm:begin` for consumers)  | 0..1        |
| `rdau:P60598`    | Date (or year) of death (RDA vocabulary; duplicate of `edm:end` for consumers)    | 0..1        |
| `dc:identifier`  | RKD Artist ID                                                                     | 0..1        |
| `rdau:P60594`    | Place of birth; when available accompanied by a GeoNames `rdf:resource` attribute | 0..1        |
| `rdau:P60592`    | Place of death; when available accompanied by a GeoNames `rdf:resource` attribute | 0..1        |

Dates of birth/death are intentionally emitted in both the `edm` and `rdau`
vocabularies, so consumers that only know one of the two still receive the
data.

### Related records

For linked lookup tables the export emits a `qkunst:<name>` element containing a
`dc:title` (the label) and a `qkunst:id` (the internal ID). This applies to:

`source`, `collection`, `condition_work`, `condition_frame`, `style`, `subset`,
`created_by`, `medium`, `placeability`, `owner`, `cluster`, `frame_type`.

Example:

```xml
<qkunst:collection>
  <dc:title>Municipal Collection</dc:title>
  <qkunst:id>17</qkunst:id>
</qkunst:collection>
```

### Free-form fields

The following fields are exported as `qkunst:<field_name>` elements with their
raw string value, when non-blank and authorized:

`condition_work_comments`, `condition_frame_comments`, `information_back`,
`other_comments`, `source_comments`, `grade_within_collection`, `created_at`,
`updated_at`, `medium_comments`, `abstract_or_figurative`, `valuation_on`,
`internal_comments`, `external_inventory`, `purchased_on`, `main_collection`,
`image_rights`, `publish`, `purchase_year`, `inventoried_at`, `refound_at`,
`new_found_at`, `price_reference`, `minimum_bid`, `selling_price`.

## XLSX Export

Next to the XML export we offer downloads in Excel (OOXML `.xlsx`) format. The
XLSX export contains a flat, one-row-per-work representation of the same field
set as the JSON export, again filtered by the caller's authorization.

## JSON Export

A close-to-internal representation of the data. The full schema is described in the API documentation
[schema.yaml](schema.yaml) (The API returns the same JSON payload).

## API based Export

Refer to [our API documentation](api.md).
