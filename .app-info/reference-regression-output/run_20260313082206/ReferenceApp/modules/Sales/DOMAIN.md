# Domain: Sales

## Entities

| Entity | Persistable | Attribute count | Access rule count |
|---|---|---:|---:|
| Sales.Order | True | 2 | 1 |

Confidence: Export-backed

## Entity Lifecycle Matrix

| Entity | Create flows | Update flows | Delete flows | Read flows |
|---|---|---|---|---|
| Sales.Order | Sales.ACT_Order_Create | Sales.ACT_Order_Create | none | Sales.VAL_Order_Check |

Confidence: Inferred

## Role impacts per sensitive entity

| Entity | Module roles | Default member rights | XPath constraint |
|---|---|---|---|
| Sales.Order | Sales.Admin, Sales.User | ReadWrite | [%CurrentUser%] |

Confidence: Export-backed

## Associations

| Association | Parent | Child | Cardinality | Type | Owner |
|---|---|---|---|---|---|
| Sales.Order_SupportTicket | Sales.Order | Support.Ticket | 1-* | ReferenceSet | Default |

## Enumerations

| Enumeration | Value count | Sample values |
|---|---:|---|
| Sales.OrderStatus | 2 | New, Submitted |
