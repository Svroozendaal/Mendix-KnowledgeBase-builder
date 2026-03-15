# Pages: Sales

## Page Inventory

| Page | Title | Allowed roles | Parameters | Popup |
|---|---|---|---|---|
| Sales.Order_NewEdit | Order New/Edit | Sales.Admin, Sales.User | Order:Sales.Order | False |

## Page-Flow Links

| Page | Shown by flows |
|---|---|
| Sales.Order_NewEdit | Sales.ACT_Order_Create |

## Journey Groups

| User intent group | Pages |
|---|---|
| Order | Sales.Order_NewEdit |

## Page Links

| Page | Entry provenance | L0 | L1 | L2 |
|---|---|---|---|---|
| Sales.Order_NewEdit | ShowPageAction | [L0](pages/sales-order-newedit.abstract.md) | [L1](pages/sales-order-newedit.overview.md) | [L2](../../../../../../tests/reference/app-overview/current/modules/Sales/pages/sales-order-newedit.json) |
