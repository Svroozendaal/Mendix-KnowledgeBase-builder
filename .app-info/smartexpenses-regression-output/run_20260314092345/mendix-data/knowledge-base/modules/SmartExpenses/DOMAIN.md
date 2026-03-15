# Domain: SmartExpenses

## Entities

| Entity | Persistable | Attribute count | Access rule count |
|---|---|---:|---:|
| SmartExpenses.Balance | True | 4 | 3 |
| SmartExpenses.BudgetTerm | True | 5 | 3 |
| SmartExpenses.BudgetType | True | 3 | 3 |
| SmartExpenses.BulkEditHelper | False | 1 | 1 |
| SmartExpenses.DateHelper | False | 1 | 2 |
| SmartExpenses.FBGProfile | True | 2 | 3 |
| SmartExpenses.Logo | True | 0 | 2 |
| SmartExpenses.New_entity | True | 1 | 0 |
| SmartExpenses.StandardBudget | True | 3 | 2 |
| SmartExpenses.Transaction | True | 8 | 3 |

Confidence: Export-backed

## Entity Lifecycle Matrix

| Entity | Create flows | Update flows | Delete flows | Read flows |
|---|---|---|---|---|
| SmartExpenses.Balance | SmartExpenses.ACT_Balance_Create | SmartExpenses.ACT_Balance_Create, SmartExpenses.ACT_Transaction_Recalculate_all | none | SmartExpenses.ACT_Balance_Create, SmartExpenses.ACT_Transaction_Recalculate_all, SmartExpenses.DS_TotalBalance_Calculate |
| SmartExpenses.BudgetTerm | SmartExpenses.ACR_FBGProfile_setStandardBudgets, SmartExpenses.ACT_BudgetTerm_New, SmartExpenses.ACT_BudgetType_New, SmartExpenses.DS_BudgetTerm_New | SmartExpenses.ACR_FBGProfile_setStandardBudgets, SmartExpenses.ACT_BudgetTerm_New, SmartExpenses.OCH_Transaction_setBudgetTerm_och_BudgetType | none | SmartExpenses.ACR_FBGProfile_setStandardBudgets, SmartExpenses.ACT_BudgetTerm_New, SmartExpenses.DS_BudgetTerm_New, SmartExpenses.DS_BudgetTerm_Retrieve_current, SmartExpenses.OCH_Transaction_setBudgetTerm_och_BudgetType |
| SmartExpenses.BudgetType | SmartExpenses.ACR_FBGProfile_setStandardBudgets, SmartExpenses.ACT_BudgetType_New | SmartExpenses.ACR_FBGProfile_setStandardBudgets, SmartExpenses.ACT_Transaction_Recalculate_all | none | SmartExpenses.ACR_FBGProfile_setStandardBudgets, SmartExpenses.ACT_Transaction_Recalculate_all, SmartExpenses.DS_BudgetType_Retrieve |
| SmartExpenses.BulkEditHelper | SmartExpenses.ACT_Transaction_BulkEditCreate | none | none | none |
| SmartExpenses.DateHelper | SmartExpenses.ACT_DateHelper_Create | none | none | none |
| SmartExpenses.FBGProfile | Administration.SaveNewAccount, SmartExpenses.DS_FBGProfile_Retreive_current | Administration.SaveNewAccount | Administration.SaveNewAccount | Administration.SaveNewAccount, SmartExpenses.ACT_FBGProfile_showParentPage, SmartExpenses.DS_FBGProfile_Retreive_current |
| SmartExpenses.Logo | SmartExpenses.ACT_BudgetTerm_BudgetType_Edit, SmartExpenses.ACT_BudgetType_New, SmartExpenses.ACT_StandardBudget_Edit, SmartExpenses.ACT_StandardBudget_New | SmartExpenses.ACT_BudgetTerm_BudgetType_Edit, SmartExpenses.ACT_StandardBudget_Edit | none | SmartExpenses.ACT_BudgetTerm_BudgetType_Edit |
| SmartExpenses.New_entity | none | none | none | none |
| SmartExpenses.StandardBudget | SmartExpenses.ACR_FBGProfile_setStandardBudgets, SmartExpenses.ACT_StandardBudget_Edit, SmartExpenses.ACT_StandardBudget_New | SmartExpenses.ACR_FBGProfile_setStandardBudgets, SmartExpenses.ACT_StandardBudget_Edit | none | SmartExpenses.ACR_FBGProfile_setStandardBudgets |
| SmartExpenses.Transaction | ImporterHelper.ACT_ImportTransaction_AcceptTransactions, SmartExpenses.ACT_Transaction_Create | ImporterHelper.ACT_ImportTransaction_AcceptTransactions, SmartExpenses.ACT_Transaction_BulkEditSave, SmartExpenses.SUB_Balance_Recalculate, SmartExpenses.SUB_BudgetTerm_Recalculate | ImporterHelper.ACT_ImportTransaction_AcceptTransactions | ImporterHelper.ACT_ImportTransaction_AcceptTransactions, SmartExpenses.ACT_Transaction_BulkEditSave, SmartExpenses.SUB_Balance_Recalculate, SmartExpenses.SUB_BudgetTerm_Recalculate |

Confidence: Inferred

## Role impacts per sensitive entity

| Entity | Module roles | Default member rights | XPath constraint |
|---|---|---|---|
| SmartExpenses.Balance | SmartExpenses.Admin | ReadWrite | none |
| SmartExpenses.Balance | SmartExpenses.Parent | None | [SmartExpenses.Balance_FBGProfile/SmartExpenses.FBGProfile/SmartExpenses.FBGProfile_Account_Parent='[%CurrentUser%]'] |
| SmartExpenses.Balance | SmartExpenses.Admin, SmartExpenses.User | ReadWrite | [SmartExpenses.Balance_FBGProfile/SmartExpenses.FBGProfile/SmartExpenses.FBGProfile_Account='[%CurrentUser%]'] |
| SmartExpenses.BudgetTerm | SmartExpenses.Admin | ReadWrite | none |
| SmartExpenses.BudgetTerm | SmartExpenses.Parent | ReadOnly | [SmartExpenses.BudgetTerm_BudgetType/SmartExpenses.BudgetType/SmartExpenses.BudgetType_FBGProfile/SmartExpenses.FBGProfile/SmartExpenses.FBGProfile_Account_Parent='[%CurrentUser%]'] |
| SmartExpenses.BudgetTerm | SmartExpenses.User | ReadWrite | [SmartExpenses.BudgetTerm_BudgetType/SmartExpenses.BudgetType/SmartExpenses.BudgetType_FBGProfile/SmartExpenses.FBGProfile/SmartExpenses.FBGProfile_Account='[%CurrentUser%]'] |
| SmartExpenses.BudgetType | SmartExpenses.Admin | ReadWrite | none |
| SmartExpenses.BudgetType | SmartExpenses.User | ReadWrite | [SmartExpenses.BudgetType_FBGProfile/SmartExpenses.FBGProfile/SmartExpenses.FBGProfile_Account='[%CurrentUser%]'] |
| SmartExpenses.BudgetType | SmartExpenses.Parent | ReadOnly | [SmartExpenses.BudgetType_FBGProfile/SmartExpenses.FBGProfile/SmartExpenses.FBGProfile_Account_Parent='[%CurrentUser%]'] |
| SmartExpenses.BulkEditHelper | SmartExpenses.Admin, SmartExpenses.User | ReadWrite | none |
| SmartExpenses.DateHelper | SmartExpenses.Admin, SmartExpenses.User | None | none |
| SmartExpenses.DateHelper | SmartExpenses.Parent | ReadOnly | none |
| SmartExpenses.FBGProfile | SmartExpenses.Admin | ReadWrite | none |
| SmartExpenses.FBGProfile | SmartExpenses.User | ReadWrite | [SmartExpenses.FBGProfile_Account='[%CurrentUser%]'] |
| SmartExpenses.FBGProfile | SmartExpenses.Parent | None | [SmartExpenses.FBGProfile_Account_Parent='[%CurrentUser%]'] |
| SmartExpenses.Logo | SmartExpenses.Admin, SmartExpenses.User | ReadWrite | none |
| SmartExpenses.Logo | SmartExpenses.Parent | None | [SmartExpenses.Logo_BudgetType/SmartExpenses.BudgetType/SmartExpenses.BudgetType_FBGProfile/SmartExpenses.FBGProfile/SmartExpenses.FBGProfile_Account_Parent='[%CurrentUser%]'] |
| SmartExpenses.StandardBudget | SmartExpenses.Admin | ReadWrite | none |
| SmartExpenses.StandardBudget | SmartExpenses.User | ReadWrite | none |
| SmartExpenses.Transaction | SmartExpenses.Admin | ReadWrite | none |
| SmartExpenses.Transaction | SmartExpenses.Parent | None | [SmartExpenses.Transaction_FBGProfile/SmartExpenses.FBGProfile/SmartExpenses.FBGProfile_Account_Parent='[%CurrentUser%]'] |
| SmartExpenses.Transaction | SmartExpenses.Admin, SmartExpenses.User | ReadWrite | [SmartExpenses.Transaction_FBGProfile/SmartExpenses.FBGProfile/SmartExpenses.FBGProfile_Account='[%CurrentUser%]'] |

Confidence: Export-backed

## Associations

| Association | Parent | Child | Cardinality | Type | Owner |
|---|---|---|---|---|---|
| SmartExpenses.Balance_FBGProfile | SmartExpenses.Balance | SmartExpenses.FBGProfile | *-1 | Reference | Default |
| SmartExpenses.BudgetTerm_BudgetType | SmartExpenses.BudgetTerm | SmartExpenses.BudgetType | *-1 | Reference | Default |
| SmartExpenses.BudgetType_FBGProfile | SmartExpenses.BudgetType | SmartExpenses.FBGProfile | *-1 | Reference | Default |
| SmartExpenses.BulkEditHelper_Balance | SmartExpenses.BulkEditHelper | SmartExpenses.Balance | *-1 | Reference | Default |
| SmartExpenses.BulkEditHelper_BudgetTerm | SmartExpenses.BulkEditHelper | SmartExpenses.BudgetTerm | *-1 | Reference | Default |
| SmartExpenses.BulkEditHelper_Transaction | SmartExpenses.BulkEditHelper | SmartExpenses.Transaction | *-* | ReferenceSet | Default |
| SmartExpenses.DateHelper_FBGProfile | SmartExpenses.DateHelper | SmartExpenses.FBGProfile | *-1 | Reference | Default |
| SmartExpenses.Logo_BudgetType | SmartExpenses.Logo | SmartExpenses.BudgetType | 1-1 | Reference | Both |
| SmartExpenses.Logo_StandardBudget | SmartExpenses.Logo | SmartExpenses.StandardBudget | 1-1 | Reference | Both |
| SmartExpenses.Transaction_Balance | SmartExpenses.Transaction | SmartExpenses.Balance | *-1 | Reference | Default |
| SmartExpenses.Transaction_BudgetTerm | SmartExpenses.Transaction | SmartExpenses.BudgetTerm | *-1 | Reference | Default |
| SmartExpenses.Transaction_FBGProfile | SmartExpenses.Transaction | SmartExpenses.FBGProfile | *-1 | Reference | Default |

## Enumerations

| Enumeration | Value count | Sample values |
|---|---:|---|
| SmartExpenses.ENUM_BudgetIcons | 9 | Chisel, fabric, hamburger, machine |
| SmartExpenses.ENUM_BudgetInterval | 3 | Month, Week, Year |
| SmartExpenses.ENUM_BudgetStatus | 2 | Active, Archived |
| SmartExpenses.ENUM_TransactionSort | 2 | expenditure, income |
| SmartExpenses.ENUM_TransactionStatus | 3 | Archived, Pending, Processed |

## Entity Index

<a id="entity-smartexpenses-balance"></a>
### SmartExpenses.Balance

- Generalization: none.
- Lifecycle: create=SmartExpenses.ACT_Balance_Create; update=SmartExpenses.ACT_Balance_Create, SmartExpenses.ACT_Transaction_Recalculate_all; delete=none; read=SmartExpenses.ACT_Balance_Create, SmartExpenses.ACT_Transaction_Recalculate_all, SmartExpenses.DS_TotalBalance_Calculate.
- Security/XPath summary: [app security](../../app/SECURITY.md).
- Source: [domain-model.pseudo.txt](../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/SmartExpenses/domain-model.pseudo.txt) / [domain-model.json](../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/SmartExpenses/domain-model.json).
<a id="entity-smartexpenses-budgetterm"></a>
### SmartExpenses.BudgetTerm

- Generalization: none.
- Lifecycle: create=SmartExpenses.ACR_FBGProfile_setStandardBudgets, SmartExpenses.ACT_BudgetTerm_New, SmartExpenses.ACT_BudgetType_New, SmartExpenses.DS_BudgetTerm_New; update=SmartExpenses.ACR_FBGProfile_setStandardBudgets, SmartExpenses.ACT_BudgetTerm_New, SmartExpenses.OCH_Transaction_setBudgetTerm_och_BudgetType; delete=none; read=SmartExpenses.ACR_FBGProfile_setStandardBudgets, SmartExpenses.ACT_BudgetTerm_New, SmartExpenses.DS_BudgetTerm_New, SmartExpenses.DS_BudgetTerm_Retrieve_current, SmartExpenses.OCH_Transaction_setBudgetTerm_och_BudgetType.
- Security/XPath summary: [app security](../../app/SECURITY.md).
- Source: [domain-model.pseudo.txt](../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/SmartExpenses/domain-model.pseudo.txt) / [domain-model.json](../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/SmartExpenses/domain-model.json).
<a id="entity-smartexpenses-budgettype"></a>
### SmartExpenses.BudgetType

- Generalization: none.
- Lifecycle: create=SmartExpenses.ACR_FBGProfile_setStandardBudgets, SmartExpenses.ACT_BudgetType_New; update=SmartExpenses.ACR_FBGProfile_setStandardBudgets, SmartExpenses.ACT_Transaction_Recalculate_all; delete=none; read=SmartExpenses.ACR_FBGProfile_setStandardBudgets, SmartExpenses.ACT_Transaction_Recalculate_all, SmartExpenses.DS_BudgetType_Retrieve.
- Security/XPath summary: [app security](../../app/SECURITY.md).
- Source: [domain-model.pseudo.txt](../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/SmartExpenses/domain-model.pseudo.txt) / [domain-model.json](../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/SmartExpenses/domain-model.json).
<a id="entity-smartexpenses-bulkedithelper"></a>
### SmartExpenses.BulkEditHelper

- Generalization: none.
- Lifecycle: create=SmartExpenses.ACT_Transaction_BulkEditCreate; update=none; delete=none; read=none.
- Security/XPath summary: none.
- Source: [domain-model.pseudo.txt](../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/SmartExpenses/domain-model.pseudo.txt) / [domain-model.json](../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/SmartExpenses/domain-model.json).
<a id="entity-smartexpenses-datehelper"></a>
### SmartExpenses.DateHelper

- Generalization: none.
- Lifecycle: create=SmartExpenses.ACT_DateHelper_Create; update=none; delete=none; read=none.
- Security/XPath summary: none.
- Source: [domain-model.pseudo.txt](../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/SmartExpenses/domain-model.pseudo.txt) / [domain-model.json](../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/SmartExpenses/domain-model.json).
<a id="entity-smartexpenses-fbgprofile"></a>
### SmartExpenses.FBGProfile

- Generalization: none.
- Lifecycle: create=Administration.SaveNewAccount, SmartExpenses.DS_FBGProfile_Retreive_current; update=Administration.SaveNewAccount; delete=Administration.SaveNewAccount; read=Administration.SaveNewAccount, SmartExpenses.ACT_FBGProfile_showParentPage, SmartExpenses.DS_FBGProfile_Retreive_current.
- Security/XPath summary: [app security](../../app/SECURITY.md).
- Source: [domain-model.pseudo.txt](../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/SmartExpenses/domain-model.pseudo.txt) / [domain-model.json](../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/SmartExpenses/domain-model.json).
<a id="entity-smartexpenses-logo"></a>
### SmartExpenses.Logo

- Generalization: System.Image.
- Lifecycle: create=SmartExpenses.ACT_BudgetTerm_BudgetType_Edit, SmartExpenses.ACT_BudgetType_New, SmartExpenses.ACT_StandardBudget_Edit, SmartExpenses.ACT_StandardBudget_New; update=SmartExpenses.ACT_BudgetTerm_BudgetType_Edit, SmartExpenses.ACT_StandardBudget_Edit; delete=none; read=SmartExpenses.ACT_BudgetTerm_BudgetType_Edit.
- Security/XPath summary: [app security](../../app/SECURITY.md).
- Source: [domain-model.pseudo.txt](../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/SmartExpenses/domain-model.pseudo.txt) / [domain-model.json](../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/SmartExpenses/domain-model.json).
<a id="entity-smartexpenses-new-entity"></a>
### SmartExpenses.New_entity

- Generalization: none.
- Lifecycle: create=none; update=none; delete=none; read=none.
- Security/XPath summary: none.
- Source: [domain-model.pseudo.txt](../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/SmartExpenses/domain-model.pseudo.txt) / [domain-model.json](../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/SmartExpenses/domain-model.json).
<a id="entity-smartexpenses-standardbudget"></a>
### SmartExpenses.StandardBudget

- Generalization: none.
- Lifecycle: create=SmartExpenses.ACR_FBGProfile_setStandardBudgets, SmartExpenses.ACT_StandardBudget_Edit, SmartExpenses.ACT_StandardBudget_New; update=SmartExpenses.ACR_FBGProfile_setStandardBudgets, SmartExpenses.ACT_StandardBudget_Edit; delete=none; read=SmartExpenses.ACR_FBGProfile_setStandardBudgets.
- Security/XPath summary: none.
- Source: [domain-model.pseudo.txt](../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/SmartExpenses/domain-model.pseudo.txt) / [domain-model.json](../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/SmartExpenses/domain-model.json).
<a id="entity-smartexpenses-transaction"></a>
### SmartExpenses.Transaction

- Generalization: none.
- Lifecycle: create=ImporterHelper.ACT_ImportTransaction_AcceptTransactions, SmartExpenses.ACT_Transaction_Create; update=ImporterHelper.ACT_ImportTransaction_AcceptTransactions, SmartExpenses.ACT_Transaction_BulkEditSave, SmartExpenses.SUB_Balance_Recalculate, SmartExpenses.SUB_BudgetTerm_Recalculate; delete=ImporterHelper.ACT_ImportTransaction_AcceptTransactions; read=ImporterHelper.ACT_ImportTransaction_AcceptTransactions, SmartExpenses.ACT_Transaction_BulkEditSave, SmartExpenses.SUB_Balance_Recalculate, SmartExpenses.SUB_BudgetTerm_Recalculate.
- Security/XPath summary: [app security](../../app/SECURITY.md).
- Source: [domain-model.pseudo.txt](../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/SmartExpenses/domain-model.pseudo.txt) / [domain-model.json](../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/SmartExpenses/domain-model.json).

## Source

- Domain export pseudo: [domain-model.pseudo.txt](../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/SmartExpenses/domain-model.pseudo.txt)
- Domain export json: [domain-model.json](../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/SmartExpenses/domain-model.json)
