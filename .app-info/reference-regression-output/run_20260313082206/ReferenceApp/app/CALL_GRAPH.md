# Call Graph

## Cross-Module Dependency Table

| Source module | Target module | Call edges | Key flows |
|---|---|---:|---|
| Sales | Support | 1 | Sales.ACT_Order_Create -> Support.SUB_HandleOrder |

Confidence: Export-backed

## Custom Module Boundary

| Custom module | Outbound dependencies | Inbound dependencies |
|---|---|---|
| Sales | Support | none |

Confidence: Export-backed

## Source

- Export flow call edges: 1
- Derived cross-module edges: 1
