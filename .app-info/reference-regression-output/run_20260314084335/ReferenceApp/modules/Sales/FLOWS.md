# Flows: Sales

## Flow Catalogue

### Action Flows (ACT_*)

| Flow | Nodes | Key Actions | Pages Shown |
|---|---:|---|---|
| ACT_Order_Create | 3 | Sales.Order | Sales.Order_NewEdit |

### Data Sources (DS_*)

| Flow | Nodes | Key Actions | Returns |
|---|---:|---|---|
| none | 0 | none | none |

### Validation Flows (VAL_*)

| Flow | Nodes | Key Actions |
|---|---:|---|
| VAL_Order_Check | 1 | Sales.Order |

### Other Flows

| Flow | Type | Nodes | Key Actions |
|---|---|---:|---|
| none | none | 0 | none |

## Cross-Module Calls

| Flow | Calls | Target Module |
|---|---|---|
| ACT_Order_Create | Support.SUB_HandleOrder | Support |

## Tier 1 Shortlist

| Flow | Shown Pages | Entities |
|---|---|---|
| Sales.ACT_Order_Create | Sales.Order_NewEdit | Sales.Order |
| Sales.VAL_Order_Check | none | Sales.Order |

## Flow Links

| Flow | Type | Tier | L0 | L1 | L2 |
|---|---|---:|---|---|---|
| Sales.ACT_Order_Create | Microflow | 1 | [L0](flows/sales-act-order-create.abstract.md) | [L1](flows/sales-act-order-create.overview.md) | [L2](../../../../../../tests/reference/app-overview/current/modules/Sales/flows/sales-act-order-create.json) |
| Sales.VAL_Order_Check | Microflow | 1 | [L0](flows/sales-val-order-check.abstract.md) | [L1](flows/sales-val-order-check.overview.md) | [L2](../../../../../../tests/reference/app-overview/current/modules/Sales/flows/sales-val-order-check.json) |
