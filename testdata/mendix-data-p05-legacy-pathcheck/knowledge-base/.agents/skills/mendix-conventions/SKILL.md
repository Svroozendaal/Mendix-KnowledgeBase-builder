# SKILL: Mendix Conventions

## Purpose

Reference guide for Mendix naming conventions, structural patterns, and best practices used during reviews and recommendations.

## Used By

Best Practice Recommender, Mendix Developer, Planner

## Naming Conventions

### Entities
- PascalCase, singular noun: `Customer`, `OrderLine`, `Invoice`.
- Avoid prefixes or suffixes: not `tblCustomer` or `CustomerEntity`.

### Attributes
- PascalCase, descriptive: `FirstName`, `OrderDate`, `TotalAmount`.
- Boolean attributes: `Is` or `Has` prefix: `IsActive`, `HasDiscount`.
- Date attributes: suffix with `Date` or `DateTime`: `CreatedDate`, `ModifiedDateTime`.

### Associations
- Format: `Entity_Entity` with owner on the left.
- One-to-many: `Order_OrderLine` (Order owns the association).
- Reference set (many-to-many): `Product_Category`.

### Microflows
- Prefix indicates purpose:
  - `ACT_` — Action (user-triggered business logic).
  - `DS_` — Data source (feeds a page widget).
  - `VAL_` — Validation (before-commit or explicit check).
  - `SUB_` — Sub-microflow (reusable, called by other flows).
  - `SE_` — Scheduled event handler.
  - `OCH_` — On-change handler.
  - `OAF_` — On-after-fill handler.
- Format: `PREFIX_Entity_Action` (e.g., `ACT_Customer_Activate`, `DS_Order_GetByStatus`).

### Nanoflows
- Same prefix conventions as microflows.
- Suffix `_NF` if needed to distinguish: `ACT_Cart_AddItem_NF`.

### Pages
- Format: `Entity_Action` or descriptive purpose.
- Examples: `Customer_Overview`, `Customer_Edit`, `Dashboard_Home`.
- Avoid generic names: not `Page1`, `NewPage`.

### Modules
- PascalCase, business-domain name: `OrderManagement`, `CustomerPortal`.
- Avoid technical names: not `BackendLogic`, `DatabaseLayer`.

## Structural Patterns

### CRUD Module Pattern
A well-structured module typically contains:
1. Domain model with entities and associations.
2. `DS_` flows for each page data source.
3. `ACT_` flows for create, save, and delete operations.
4. `VAL_` flows for before-commit validation.
5. Overview page (list), detail page (view), and edit page (form).
6. Access rules per entity per role.

### Separation of Concerns
- **Domain modules**: Entities and CRUD logic.
- **Process modules**: Multi-step business processes spanning entities.
- **Integration modules**: External API calls and data sync.
- **Utility modules**: Shared helpers, constants, email templates.

### Module Independence
- Modules should minimise cross-module associations.
- Use microflow APIs (sub-microflows) for cross-module interaction.
- Never modify marketplace module internals.
