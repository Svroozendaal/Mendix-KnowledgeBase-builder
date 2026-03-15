# Domain: NanoflowCommons

## Entities

| Entity | Persistable | Attribute count | Access rule count |
|---|---|---:|---:|
| NanoflowCommons.Geolocation | False | 8 | 1 |
| NanoflowCommons.Position | False | 2 | 1 |

Confidence: Export-backed

## Entity Lifecycle Matrix

| Entity | Create flows | Update flows | Delete flows | Read flows |
|---|---|---|---|---|
| NanoflowCommons.Geolocation | none | none | none | none |
| NanoflowCommons.Position | none | none | none | none |

Confidence: Inferred

## Role impacts per sensitive entity

| Entity | Module roles | Default member rights | XPath constraint |
|---|---|---|---|
| NanoflowCommons.Geolocation | NanoflowCommons.User | ReadWrite | none |
| NanoflowCommons.Position | NanoflowCommons.User | ReadWrite | none |

Confidence: Export-backed

## Associations

| Association | Parent | Child | Cardinality | Type | Owner |
|---|---|---|---|---|---|
| none | none | none | none | none | none |

## Enumerations

| Enumeration | Value count | Sample values |
|---|---:|---|
| NanoflowCommons.Enum_DistanceUnit | 3 | KILOMETER, NAUTICAL_MILE, STATUTE_MILE |
| NanoflowCommons.GeocodingProvider | 4 | Geocodio, Google, LocationIQ, MapQuest |
| NanoflowCommons.Platform | 3 | Hybrid_mobile, Native_mobile, Web |

## Entity Index

<a id="entity-nanoflowcommons-geolocation"></a>
### NanoflowCommons.Geolocation

- Generalization: none.
- Lifecycle: create=none; update=none; delete=none; read=none.
- Security/XPath summary: none.
- Source: [domain-model.pseudo.txt](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/NanoflowCommons/domain-model.pseudo.txt) / [domain-model.json](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/NanoflowCommons/domain-model.json).
<a id="entity-nanoflowcommons-position"></a>
### NanoflowCommons.Position

- Generalization: none.
- Lifecycle: create=none; update=none; delete=none; read=none.
- Security/XPath summary: none.
- Source: [domain-model.pseudo.txt](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/NanoflowCommons/domain-model.pseudo.txt) / [domain-model.json](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/NanoflowCommons/domain-model.json).

## Source

- Domain export pseudo: [domain-model.pseudo.txt](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/NanoflowCommons/domain-model.pseudo.txt)
- Domain export json: [domain-model.json](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/NanoflowCommons/domain-model.json)
