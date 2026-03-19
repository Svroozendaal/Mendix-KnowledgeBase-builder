# Domain: Atlas_Web_Content

## Entities

| Entity | Persistable | Attribute count | Access rule count |
|---|---|---:|---:|
| Atlas_Web_Content.LoginContext | True | 4 | 0 |

Confidence: Export-backed

## Entity Lifecycle Matrix

| Entity | Create flows | Update flows | Delete flows | Read flows |
|---|---|---|---|---|
| Atlas_Web_Content.LoginContext | Atlas_Web_Content.DS_LoginContext [members unknown] | none | none | none |

Confidence: Inferred

## Role impacts per sensitive entity

| Entity | Module roles | Default member rights | XPath constraint |
|---|---|---|---|
| none | none | none | none |

Confidence: Export-backed

## Associations

| Association | Parent | Child | Cardinality | Type | Owner |
|---|---|---|---|---|---|
| none | none | none | none | none | none |

## Enumerations

| Enumeration | Value count | Sample values |
|---|---:|---|
| none | 0 | none |

## Entity Index

<a id="entity-atlas-web-content-logincontext"></a>
### Atlas_Web_Content.LoginContext

- Generalization: none.
- Lifecycle: create=Atlas_Web_Content.DS_LoginContext; update=none; delete=none; read=none.
- Security/XPath summary: none.
- Source: [domain-model.pseudo.txt](../../../../../mendix-data-p05-legacy/app-overview/cli_2026-03-18T20-44-56.522Z/modules/marketplace/Atlas_Web_Content/domain-model.pseudo.txt) / [domain-model.json](../../../../../mendix-data-p05-legacy/app-overview/cli_2026-03-18T20-44-56.522Z/modules/marketplace/Atlas_Web_Content/domain-model.json).

| Attribute | Type | Length/Precision | Default | Validation |
|---|---|---|---|---|
| Password | String | 200 | — | — |
| RememberMe | Boolean | — | false | — |
| Username | String | 200 | — | — |
| ValidationMessage | String | 200 | — | — |

## Source

- Domain export pseudo: [domain-model.pseudo.txt](../../../../../mendix-data-p05-legacy/app-overview/cli_2026-03-18T20-44-56.522Z/modules/marketplace/Atlas_Web_Content/domain-model.pseudo.txt)
- Domain export json: [domain-model.json](../../../../../mendix-data-p05-legacy/app-overview/cli_2026-03-18T20-44-56.522Z/modules/marketplace/Atlas_Web_Content/domain-model.json)
