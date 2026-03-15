# Security

## Role-to-Module-Role Matrix

| Project role | Custom module roles | All module roles |
|---|---|---|
| Manager | Sales.Admin | Sales.Admin, Support.Operator |
| Employee | Sales.User | Sales.User |

Confidence: Export-backed

## Entity Access Summary (Custom Entities)

| Entity | Rule module roles | Allow create | Allow delete | XPath constraint |
|---|---|---|---|---|
| Sales.Order | Sales.Admin, Sales.User | True | False | [%CurrentUser%] |

Confidence: Export-backed

## XPath Constraints (Plain Language)

| Entity | Module roles | XPath | Access meaning |
|---|---|---|---|
| Sales.Order | Sales.Admin, Sales.User | [%CurrentUser%] | current user |

Confidence: Inferred

## Source

- Security level: Production
- Guest access: False
