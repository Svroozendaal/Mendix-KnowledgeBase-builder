# Domain Model: SmartExpenses

## Entities

### Balance
- Persistence: persistent
- Attributes:
  | Name | Type |
  |------|------|
  | Active | Boolean |
  | CurrentAmount | Decimal |
  | Description | String |
  | Name | String |
- Access rules:
  | Role(s) | Create | Delete | Default | XPath |
  |---------|--------|--------|---------|-------|
  | Admin | yes | yes | ReadWrite | — |
  | Parent | no | no | None | Only balances of linked child profile |
  | Admin, User | yes | yes | ReadWrite | Only own balances (via FBGProfile_Account) |

### BudgetTerm
- Persistence: persistent
- Attributes:
  | Name | Type |
  |------|------|
  | BudgetAmount | Decimal |
  | CurrentAmount | Decimal |
  | EndDate | DateTime |
  | Name | String |
  | StartDate | DateTime |
- Access rules:
  | Role(s) | Create | Delete | Default | XPath |
  |---------|--------|--------|---------|-------|
  | Admin | yes | yes | ReadWrite | — |
  | Parent | no | no | ReadOnly | Via BudgetType -> FBGProfile -> Account_Parent chain |
  | User | yes | yes | ReadWrite | Via BudgetType -> FBGProfile -> Account chain |

### BudgetType
- Persistence: persistent
- Attributes:
  | Name | Type |
  |------|------|
  | Description | String |
  | Interval | Enumeration (ENUM_BudgetInterval) |
  | Name | String |
- Access rules:
  | Role(s) | Create | Delete | Default | XPath |
  |---------|--------|--------|---------|-------|
  | Admin | yes | yes | ReadWrite | — |
  | User | yes | yes | ReadWrite | Own profile |
  | Parent | no | no | ReadOnly | Child profile |

### BulkEditHelper
- Persistence: **non-persistent** (transient helper object)
- Attributes:
  | Name | Type |
  |------|------|
  | InOut | Enumeration (ENUM_TransactionSort) |
- Access rules: Admin, User — full access
- Purpose: temporary object for bulk-editing multiple transactions at once

### DateHelper
- Persistence: **non-persistent** (transient helper object)
- Attributes:
  | Name | Type |
  |------|------|
  | SelectedDate | DateTime |
- Access rules: Admin, User (ReadWrite), Parent (ReadOnly)
- Purpose: date selection helper for filtering views

### FBGProfile
- Persistence: persistent
- Attributes:
  | Name | Type |
  |------|------|
  | BalanceTotal | Decimal |
  | Description | String |
- Access rules:
  | Role(s) | Create | Delete | Default | XPath |
  |---------|--------|--------|---------|-------|
  | Admin | yes | yes | ReadWrite | — |
  | User | yes | yes | ReadWrite | Own profile (FBGProfile_Account = CurrentUser) |
  | Parent | no | no | None | Child profile (FBGProfile_Account_Parent = CurrentUser) |
- Purpose: central user profile linking accounts to budgets, balances, and transactions

### Logo
- Persistence: persistent
- Generalisation: System.Image
- Access rules: Admin, User (ReadWrite), Parent (ReadOnly via BudgetType chain)
- Purpose: image/logo for budget types and standard budgets

### New_entity
- Persistence: persistent
- Attributes: newAttribute (String)
- Access rules: none defined
- Note: appears to be a placeholder/test entity

### StandardBudget
- Persistence: persistent
- Attributes:
  | Name | Type |
  |------|------|
  | Description | String |
  | Interval | Enumeration (ENUM_BudgetInterval) |
  | Name | String |
- Access rules: Admin (ReadWrite), User (ReadOnly)
- Purpose: template budgets used to initialise new user profiles

### Transaction
- Persistence: persistent
- Attributes:
  | Name | Type |
  |------|------|
  | Description | String |
  | EntryDate | DateTime |
  | InOut | Enumeration (ENUM_TransactionSort) |
  | Name | String |
  | Status | Enumeration (ENUM_TransactionStatus) |
  | TransactionCode | String |
  | TransactionDate | DateTime |
  | Value | Decimal |
- Access rules:
  | Role(s) | Create | Delete | Default | XPath |
  |---------|--------|--------|---------|-------|
  | Admin | yes | yes | ReadWrite | — |
  | Parent | no | no | None | Via FBGProfile -> Account_Parent (read-only) |
  | Admin, User | yes | yes | ReadWrite | Own transactions via FBGProfile_Account |

## Associations

| Association | Parent | Child | Cardinality |
|-------------|--------|-------|-------------|
| Balance_FBGProfile | Balance | FBGProfile | *-1 |
| BudgetTerm_BudgetType | BudgetTerm | BudgetType | *-1 |
| BudgetType_FBGProfile | BudgetType | FBGProfile | *-1 |
| BulkEditHelper_Balance | BulkEditHelper | Balance | *-1 |
| BulkEditHelper_BudgetTerm | BulkEditHelper | BudgetTerm | *-1 |
| BulkEditHelper_Transaction | BulkEditHelper | Transaction | *-* |
| DateHelper_FBGProfile | DateHelper | FBGProfile | *-1 |
| Logo_BudgetType | Logo | BudgetType | 1-1 |
| Logo_StandardBudget | Logo | StandardBudget | 1-1 |
| Transaction_Balance | Transaction | Balance | *-1 |
| Transaction_BudgetTerm | Transaction | BudgetTerm | *-1 |
| Transaction_FBGProfile | Transaction | FBGProfile | *-1 |

## Enumerations

| Enumeration | Values |
|-------------|--------|
| ENUM_BudgetIcons | Chisel, fabric, hamburger, machine, paint, sewing, supplies, test, zip |
| ENUM_BudgetInterval | Month, Week, Year |
| ENUM_BudgetStatus | Active, Archived |
| ENUM_TransactionSort | expenditure, income |
| ENUM_TransactionStatus | Archived, Pending, Processed |
| NEW_name_NEUM | (empty — appears to be a placeholder) |
