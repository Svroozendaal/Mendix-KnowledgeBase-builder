# Flows: SmartExpenses

Total: 42 (Microflows: 34, Nanoflows: 7, Workflows: 1)

## Flow Catalogue

### Action Flows (ACT_*)

| Flow | Nodes | Key Actions | Pages Shown |
|------|-------|-------------|-------------|
| ACT_Balance_Create | 9 | Create Balance, retrieve session user, commit | Balance_NewEdit |
| ACT_Balance_NewEdit | 11 | Validate -> commit Balance -> close page | — |
| ACT_BudgetTerm_BudgetType_Edit | 12 | Retrieve BudgetType, check Logo exists, create if missing | BudgetTerm_NewEdit |
| ACT_BudgetTerm_New | 10 | Loop BudgetTypes, create BudgetTerms, commit | — |
| ACT_BudgetType_New | 8 | Create Logo + BudgetType + BudgetTerm | BudgetTerm_NewEdit |
| ACT_BudgetType_OpenOverviewPAge | 6 | Create DateHelper, show overview | BudgetType_Overview |
| ACT_BudgetType_Save | 12 | Validate -> set name by interval -> commit | — |
| ACT_DateHelper_Create | 5 | Create DateHelper with current date | — |
| ACT_FBGProfile_showParentPage | 4 | Retrieve FBGProfile, show parent home | Home_Parent |
| ACT_StandardBudget_Edit | 12 | Check existence, ensure Logo, show edit | StandardBudget_NewEdit |
| ACT_StandardBudget_New | 5 | Create Logo + StandardBudget | StandardBudget_NewEdit |
| ACT_Transaction_BulkEditCreate | 7 | Create BulkEditHelper, show bulk edit | Transaction_BulkEdit |
| ACT_Transaction_BulkEditSave | 16 | Loop transactions, apply changes, recalculate balance/budget | — |
| ACT_Transaction_Create | 7 | Create Transaction with defaults | Transaction_New |
| ACT_Transaction_NewEdit_Save | 10 | Validate -> set status -> commit -> close | — |
| ACT_Transaction_Recalculate_all | 13 | Loop all budgets + balances, recalculate totals | — |

### After-Commit / Before-Delete Event Flows

| Flow | Nodes | Key Actions |
|------|-------|-------------|
| ACR_FBGProfile_setStandardBudgets | 10 | Copy StandardBudgets to new FBGProfile as BudgetTypes + BudgetTerms |
| BCO_Transaction | 6 | After commit: recalculate balance + budget term |
| BD_Transaction | 6 | Before delete: recalculate balance + budget term |

### Data Source Flows (DS_*)

| Flow | Nodes | Key Actions | Returns |
|------|-------|-------------|---------|
| DS_BudgetTerm_New | 11 | Retrieve existing, create new BudgetTerm with interval-based dates | BudgetTerm |
| DS_BudgetTerm_Retrieve_current | 6 | Retrieve current BudgetTerm | BudgetTerm |
| DS_BudgetType_Retrieve | 6 | Retrieve all BudgetTypes | BudgetTypeList |
| DS_FBGProfile_Retreive_current | 8 | Retrieve or create FBGProfile for current user | FBGProfile |
| DS_TotalBalance_Calculate | 6 | Sum all balance amounts | Decimal |

### Sub-Microflows (SUB_*)

| Flow | Nodes | Key Actions |
|------|-------|-------------|
| SUB_Balance_Recalculate | 10 | Sum income - expenditure transactions, update Balance.CurrentAmount |
| SUB_BudgetTerm_Recalculate | 10 | Sum expenditure - income transactions, update BudgetTerm.CurrentAmount |
| SUB_Transaction_CalculateBalance | 8 | Find transaction's balance, recalculate if exists |
| SUB_Transaction_CalculateBudgetTerm | 8 | Find transaction's budget term, recalculate if exists |
| SUB_Transaction_setStatus | 5 | Set status: Pending if no balance, else income/expenditure-based |

### Validation Flows (VAL_*)

| Flow | Nodes | Key Actions |
|------|-------|-------------|
| VAL_Balance_NewEdit | 13 | Validate Name and Description not empty |
| VAL_BudgetTypeTerm_New | 21 | Validate Name not empty, BudgetAmount > 0 |
| VAL_Transaction_NewEdit | 28 | Validate Name, InOut, Value > 0, TransactionDate not empty |

### Test / Miscellaneous Flows

| Flow | Type | Nodes | Key Actions |
|------|------|-------|-------------|
| NEW_MICROFLOW_test | Microflow | 8 | Test decision, session change |
| NEW_WORKFLOW | Workflow | 0 | Empty workflow (placeholder) |

### Nanoflows

| Flow | Nodes | Key Actions |
|------|-------|-------------|
| ACT_BudgetTerm_setStartdateOnInterval | 6 | Set start/end date based on BudgetType interval |
| Nanoflow | 6 | Show toast + open BudgetType_Overview |
| NEW_NANOFLOW | 4 | Empty/test nanoflow with decision |
| OCH_BulkEditHelper_setBalance | 5 | On-change handler: set BulkEditHelper.Balance |
| OCH_BulkEditHelper_setBudgetTerm | 5 | On-change handler: set BulkEditHelper.BudgetTerm |
| OCH_Transaction_setBalance | 5 | On-change handler: set Transaction.Balance |
| OCH_Transaction_setBudgetTerm | 5 | On-change handler: set Transaction.BudgetTerm |
| OCH_Transaction_setBudgetTerm_och_BudgetType | 6 | On-change handler: retrieve + set BudgetTerm from BudgetType |

## Cross-Module Calls

| Flow | Calls | Target Module |
|------|-------|---------------|
| (none outbound) | — | — |

SmartExpenses is self-contained — all 19 internal call edges stay within the module.

**Inbound calls from other modules:**
| Source | Flow | Calls |
|--------|------|-------|
| ImporterHelper | ACT_ImportTransaction_AcceptTransactions | SUB_Transaction_setStatus |

## Key Flow Details

### ACR_FBGProfile_setStandardBudgets
When a new FBGProfile is created (after-commit), this flow copies all StandardBudget templates into actual BudgetType + BudgetTerm objects for the user. This bootstraps new users with a default budget configuration.

### ACT_Transaction_BulkEditSave
The most complex action flow (16 nodes). Applies BulkEditHelper settings (Balance, BudgetTerm, InOut) to multiple selected transactions, then recalculates affected balances and budget terms.

### BCO_Transaction / BD_Transaction
Event handlers on Transaction commit and delete — both trigger recalculation of the associated Balance and BudgetTerm to keep running totals accurate.

### SUB_Balance_Recalculate / SUB_BudgetTerm_Recalculate
Core calculation flows: aggregate income and expenditure transactions to compute current amounts. Called from multiple places to keep totals in sync.
