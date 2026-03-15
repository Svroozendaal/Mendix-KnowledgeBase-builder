# Cross-Module Dependencies

## Dependency matrix

| Source module | Target module | Flow call count | Association link count |
|---|---|---:|---:|
| Sales | Support | 1 | 1 |

## Flow-call edges

| Source flow | Target flow | Source module | Target module |
|---|---|---|---|
| Sales.ACT_Order_Create | Support.SUB_HandleOrder | Sales | Support |

## Hub/leaf module classification

| Module | Outbound edges | Inbound edges | Classification |
|---|---:|---:|---|
| Sales | 1 | 0 | source-leaf |
| Support | 0 | 1 | sink-leaf |

## Hub Modules

- none

## Leaf Modules

- Sales (source-leaf), Support (sink-leaf)

## Association Links

| Association | From module | To module | Parent entity | Child entity |
|---|---|---|---|---|
| Sales.Order_SupportTicket | Sales | Support | Sales.Order | Support.Ticket |

## Custom-boundary dependency lens

| Custom module | Depends on | Used by |
|---|---|---|
| Sales | Support | none |
