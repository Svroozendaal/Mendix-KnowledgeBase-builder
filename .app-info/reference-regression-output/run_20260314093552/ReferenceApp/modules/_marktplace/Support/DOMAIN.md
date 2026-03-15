# Domain: Support

## Entities

| Entity | Persistable | Attribute count | Access rule count |
|---|---|---:|---:|
| Support.Ticket | True | 1 | 1 |

Confidence: Export-backed

## Entity Lifecycle Matrix

| Entity | Create flows | Update flows | Delete flows | Read flows |
|---|---|---|---|---|
| Support.Ticket | none | Support.SUB_HandleOrder | none | none |

Confidence: Inferred

## Role impacts per sensitive entity

| Entity | Module roles | Default member rights | XPath constraint |
|---|---|---|---|
| Support.Ticket | Support.Operator | ReadWrite | none |

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

<a id="entity-support-ticket"></a>
### Support.Ticket

- Generalization: none.
- Lifecycle: create=none; update=Support.SUB_HandleOrder; delete=none; read=none.
- Security/XPath summary: none.
- Source: none / [domain-model.json](../../../../../../../tests/reference/app-overview/cli_reference_minimal/modules/Support/domain-model.json).

## Source

- Domain export pseudo: none
- Domain export json: [domain-model.json](../../../../../../../tests/reference/app-overview/cli_reference_minimal/modules/Support/domain-model.json)
