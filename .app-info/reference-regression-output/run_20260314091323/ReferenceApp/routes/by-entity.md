# Entity Index

| Entity | Module | KB detail | Create flows | Update flows | Delete flows | Read flows | Read evidence | Write evidence | Security/XPath evidence | Shown on pages |
|---|---|---|---|---|---|---|---|---|---|---|
| Sales.Order | [Sales](../modules/Sales/DOMAIN.md) | [detail](../modules/Sales/DOMAIN.md#entity-sales-order) | Sales.ACT_Order_Create | Sales.ACT_Order_Create | none | Sales.VAL_Order_Check | [Sales.VAL_Order_Check](../modules/Sales/flows/sales-val-order-check.overview.md) | [Sales.ACT_Order_Create](../modules/Sales/flows/sales-act-order-create.overview.md) | [security](../app/SECURITY.md) | Sales.Order_NewEdit |
| Support.Ticket | [Support](../modules/_marktplace/Support/DOMAIN.md) | [detail](../modules/_marktplace/Support/DOMAIN.md#entity-support-ticket) | none | Support.SUB_HandleOrder | none | none | none | [Support.SUB_HandleOrder](../modules/_marktplace/Support/flows/support-sub-handleorder.overview.md) | none | none |
