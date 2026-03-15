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

## Flow Details

| Flow | Kind | Nodes | Tier | Calls Out | Called By |
|---|---|---:|---:|---:|---:|
| ACT_Order_Create | Microflow | 3 | 1 | 1 | 0 |
| VAL_Order_Check | Microflow | 1 | 1 | 0 | 0 |

## Tier 1 Deep Narratives

### Sales.ACT_Order_Create

- Intent: User action flow.
- Trigger/entry: microflow/nanoflow entry based on caller or UI action.
- Inputs/outputs: derived from flow node graph; explicit parameter typing is not fully exported.
- Read/write entities: Sales.Order.
- UI interactions (shown pages): Sales.Order_NewEdit.
- Calls/called-by: out=1, in=0.
- Security constraints touched: module roles derived via page permissions and entity access rules.
- Failure/rollback notes: No rollback behaviour was explicitly indicated in exported node detail.

### Sales.VAL_Order_Check

- Intent: Validation flow.
- Trigger/entry: microflow/nanoflow entry based on caller or UI action.
- Inputs/outputs: derived from flow node graph; explicit parameter typing is not fully exported.
- Read/write entities: Sales.Order.
- UI interactions (shown pages): none.
- Calls/called-by: out=0, in=0.
- Security constraints touched: module roles derived via page permissions and entity access rules.
- Failure/rollback notes: No rollback behaviour was explicitly indicated in exported node detail.

## Flow Links

| Flow | Type | Tier | L0 | L1 | L2 |
|---|---|---:|---|---|---|
| Sales.ACT_Order_Create | Microflow | 1 | [L0](flows/sales-act-order-create.abstract.md) | [L1](flows/sales-act-order-create.overview.md) | [L2](../../../../../../tests/reference/app-overview/current/modules/Sales/flows/sales-act-order-create.json) |
| Sales.VAL_Order_Check | Microflow | 1 | [L0](flows/sales-val-order-check.abstract.md) | [L1](flows/sales-val-order-check.overview.md) | [L2](../../../../../../tests/reference/app-overview/current/modules/Sales/flows/sales-val-order-check.json) |
