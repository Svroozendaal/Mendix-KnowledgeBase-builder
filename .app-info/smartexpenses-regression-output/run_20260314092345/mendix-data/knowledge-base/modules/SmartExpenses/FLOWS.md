# Flows: SmartExpenses

## Flow Catalogue

### Action Flows (ACT_*)

| Flow | Nodes | Key Actions | Pages Shown |
|---|---:|---|---|
| ACT_Balance_Create | 9 | SmartExpenses.Balance | SmartExpenses.Balance_NewEdit |
| ACT_Balance_NewEdit | 11 | none | none |
| ACT_BudgetTerm_BudgetType_Edit | 12 | SmartExpenses.Logo | SmartExpenses.BudgetTerm_NewEdit |
| ACT_BudgetTerm_New | 12 | SmartExpenses.BudgetTerm | none |
| ACT_BudgetTerm_setStartdateOnInterval | 6 | none | none |
| ACT_BudgetType_New | 8 | SmartExpenses.BudgetTerm, SmartExpenses.BudgetType, SmartExpenses.Logo | SmartExpenses.BudgetTerm_NewEdit |
| ACT_BudgetType_OpenOverviewPAge | 6 | none | SmartExpenses.BudgetType_Overview |
| ACT_BudgetType_Save | 12 | none | none |
| ACT_DateHelper_Create | 5 | SmartExpenses.DateHelper | none |
| ACT_FBGProfile_showParentPage | 4 | SmartExpenses.FBGProfile | SmartExpenses.Home_Parent |
| ACT_StandardBudget_Edit | 12 | SmartExpenses.Logo, SmartExpenses.StandardBudget | SmartExpenses.StandardBudget_NewEdit |
| ACT_StandardBudget_New | 5 | SmartExpenses.Logo, SmartExpenses.StandardBudget | SmartExpenses.StandardBudget_NewEdit |
| ACT_Transaction_BulkEditCreate | 7 | SmartExpenses.BulkEditHelper | SmartExpenses.Transaction_BulkEdit |
| ACT_Transaction_BulkEditSave | 18 | SmartExpenses.Transaction | none |
| ACT_Transaction_Create | 7 | SmartExpenses.Transaction | SmartExpenses.Transaction_New |
| ACT_Transaction_NewEdit_Save | 10 | none | none |
| ACT_Transaction_Recalculate_all | 18 | SmartExpenses.Balance, SmartExpenses.BudgetType | none |

### Data Sources (DS_*)

| Flow | Nodes | Key Actions | Returns |
|---|---:|---|---|
| DS_BudgetTerm_New | 11 | SmartExpenses.BudgetTerm | inferred from node actions |
| DS_BudgetTerm_Retrieve_current | 6 | SmartExpenses.BudgetTerm | inferred from node actions |
| DS_BudgetType_Retrieve | 6 | SmartExpenses.BudgetType | inferred from node actions |
| DS_FBGProfile_Retreive_current | 8 | Administration.Account, SmartExpenses.FBGProfile | inferred from node actions |
| DS_TotalBalance_Calculate | 6 | SmartExpenses.Balance | inferred from node actions |

### Validation Flows (VAL_*)

| Flow | Nodes | Key Actions |
|---|---:|---|
| VAL_Balance_NewEdit | 13 | none |
| VAL_BudgetTypeTerm_New | 21 | none |
| VAL_Transaction_NewEdit | 28 | none |

### Other Flows

| Flow | Type | Nodes | Key Actions |
|---|---|---:|---|
| ACR_FBGProfile_setStandardBudgets | Microflow | 14 | SmartExpenses.BudgetTerm, SmartExpenses.BudgetType, SmartExpenses.StandardBudget |
| BCO_Transaction | Microflow | 6 | none |
| BD_Transaction | Microflow | 6 | none |
| Nanoflow | Nanoflow | 6 | none |
| OCH_BulkEditHelper_setBalance | Nanoflow | 5 | none |
| OCH_BulkEditHelper_setBudgetTerm | Nanoflow | 5 | none |
| OCH_Transaction_setBalance | Nanoflow | 5 | none |
| OCH_Transaction_setBudgetTerm | Nanoflow | 5 | none |
| OCH_Transaction_setBudgetTerm_och_BudgetType | Nanoflow | 6 | SmartExpenses.BudgetTerm |
| SUB_Balance_Recalculate | Microflow | 10 | SmartExpenses.Transaction |
| SUB_BudgetTerm_Recalculate | Microflow | 10 | SmartExpenses.Transaction |
| SUB_Transaction_CalculateBalance | Microflow | 8 | none |
| SUB_Transaction_CalculateBudgetTerm | Microflow | 8 | none |
| SUB_Transaction_setStatus | Microflow | 5 | none |

## Cross-Module Calls

| Flow | Calls | Target Module |
|---|---|---|
| none | none | none |

## Tier 1 Shortlist

| Flow | Shown Pages | Entities |
|---|---|---|
| SmartExpenses.ACR_FBGProfile_setStandardBudgets | none | SmartExpenses.BudgetTerm, SmartExpenses.BudgetType, SmartExpenses.StandardBudget |
| SmartExpenses.ACT_Balance_Create | SmartExpenses.Balance_NewEdit | SmartExpenses.Balance |
| SmartExpenses.ACT_Balance_NewEdit | none | none |
| SmartExpenses.ACT_BudgetTerm_BudgetType_Edit | SmartExpenses.BudgetTerm_NewEdit | SmartExpenses.Logo |
| SmartExpenses.ACT_BudgetTerm_New | none | SmartExpenses.BudgetTerm |
| SmartExpenses.ACT_BudgetTerm_setStartdateOnInterval | none | none |
| SmartExpenses.ACT_BudgetType_New | SmartExpenses.BudgetTerm_NewEdit | SmartExpenses.BudgetTerm, SmartExpenses.BudgetType, SmartExpenses.Logo |
| SmartExpenses.ACT_BudgetType_OpenOverviewPAge | SmartExpenses.BudgetType_Overview | none |
| SmartExpenses.ACT_BudgetType_Save | none | none |
| SmartExpenses.ACT_DateHelper_Create | none | SmartExpenses.DateHelper |
| SmartExpenses.ACT_FBGProfile_showParentPage | SmartExpenses.Home_Parent | SmartExpenses.FBGProfile |
| SmartExpenses.ACT_StandardBudget_Edit | SmartExpenses.StandardBudget_NewEdit | SmartExpenses.Logo, SmartExpenses.StandardBudget |
| SmartExpenses.ACT_StandardBudget_New | SmartExpenses.StandardBudget_NewEdit | SmartExpenses.Logo, SmartExpenses.StandardBudget |
| SmartExpenses.ACT_Transaction_BulkEditCreate | SmartExpenses.Transaction_BulkEdit | SmartExpenses.BulkEditHelper |
| SmartExpenses.ACT_Transaction_BulkEditSave | none | SmartExpenses.Transaction |
| SmartExpenses.ACT_Transaction_Create | SmartExpenses.Transaction_New | SmartExpenses.Transaction |
| SmartExpenses.ACT_Transaction_NewEdit_Save | none | none |
| SmartExpenses.ACT_Transaction_Recalculate_all | none | SmartExpenses.Balance, SmartExpenses.BudgetType |
| SmartExpenses.BCO_Transaction | none | none |
| SmartExpenses.BD_Transaction | none | none |
| SmartExpenses.DS_BudgetTerm_New | none | SmartExpenses.BudgetTerm |
| SmartExpenses.DS_FBGProfile_Retreive_current | none | Administration.Account, SmartExpenses.FBGProfile |
| SmartExpenses.Nanoflow | SmartExpenses.BudgetType_Overview | none |
| SmartExpenses.OCH_Transaction_setBudgetTerm_och_BudgetType | none | SmartExpenses.BudgetTerm |
| SmartExpenses.SUB_Balance_Recalculate | none | SmartExpenses.Transaction |
| SmartExpenses.SUB_BudgetTerm_Recalculate | none | SmartExpenses.Transaction |
| SmartExpenses.SUB_Transaction_CalculateBalance | none | none |
| SmartExpenses.SUB_Transaction_CalculateBudgetTerm | none | none |
| SmartExpenses.SUB_Transaction_setStatus | none | none |
| SmartExpenses.VAL_Balance_NewEdit | none | none |
| SmartExpenses.VAL_BudgetTypeTerm_New | none | none |
| SmartExpenses.VAL_Transaction_NewEdit | none | none |

## Flow Details

| Flow | Kind | Nodes | Tier | Calls Out | Called By |
|---|---|---:|---:|---:|---:|
| ACR_FBGProfile_setStandardBudgets | Microflow | 14 | 1 | 1 | 0 |
| ACT_Balance_Create | Microflow | 9 | 1 | 0 | 0 |
| ACT_Balance_NewEdit | Microflow | 11 | 1 | 1 | 0 |
| ACT_BudgetTerm_BudgetType_Edit | Microflow | 12 | 1 | 0 | 0 |
| ACT_BudgetTerm_New | Microflow | 12 | 1 | 1 | 0 |
| ACT_BudgetTerm_setStartdateOnInterval | Nanoflow | 6 | 1 | 0 | 0 |
| ACT_BudgetType_New | Microflow | 8 | 1 | 0 | 0 |
| ACT_BudgetType_OpenOverviewPAge | Microflow | 6 | 1 | 1 | 0 |
| ACT_BudgetType_Save | Microflow | 12 | 1 | 1 | 0 |
| ACT_DateHelper_Create | Microflow | 5 | 1 | 0 | 1 |
| ACT_FBGProfile_showParentPage | Microflow | 4 | 1 | 0 | 0 |
| ACT_StandardBudget_Edit | Microflow | 12 | 1 | 0 | 0 |
| ACT_StandardBudget_New | Microflow | 5 | 1 | 0 | 0 |
| ACT_Transaction_BulkEditCreate | Microflow | 7 | 1 | 0 | 0 |
| ACT_Transaction_BulkEditSave | Microflow | 18 | 1 | 3 | 0 |
| ACT_Transaction_Create | Microflow | 7 | 1 | 0 | 0 |
| ACT_Transaction_NewEdit_Save | Microflow | 10 | 1 | 2 | 0 |
| ACT_Transaction_Recalculate_all | Microflow | 18 | 1 | 3 | 0 |
| BCO_Transaction | Microflow | 6 | 1 | 2 | 0 |
| BD_Transaction | Microflow | 6 | 1 | 2 | 0 |
| DS_BudgetTerm_New | Microflow | 11 | 1 | 0 | 2 |
| DS_BudgetTerm_Retrieve_current | Microflow | 6 | 2 | 0 | 0 |
| DS_BudgetType_Retrieve | Microflow | 6 | 2 | 0 | 0 |
| DS_FBGProfile_Retreive_current | Microflow | 8 | 1 | 0 | 0 |
| DS_TotalBalance_Calculate | Microflow | 6 | 2 | 0 | 1 |
| Nanoflow | Nanoflow | 6 | 1 | 0 | 0 |
| OCH_BulkEditHelper_setBalance | Nanoflow | 5 | 2 | 0 | 0 |
| OCH_BulkEditHelper_setBudgetTerm | Nanoflow | 5 | 2 | 0 | 0 |
| OCH_Transaction_setBalance | Nanoflow | 5 | 2 | 0 | 0 |
| OCH_Transaction_setBudgetTerm | Nanoflow | 5 | 2 | 0 | 0 |
| OCH_Transaction_setBudgetTerm_och_BudgetType | Nanoflow | 6 | 1 | 0 | 0 |
| SUB_Balance_Recalculate | Microflow | 10 | 1 | 0 | 3 |
| SUB_BudgetTerm_Recalculate | Microflow | 10 | 1 | 0 | 3 |
| SUB_Transaction_CalculateBalance | Microflow | 8 | 1 | 1 | 2 |
| SUB_Transaction_CalculateBudgetTerm | Microflow | 8 | 1 | 1 | 2 |
| SUB_Transaction_setStatus | Microflow | 5 | 1 | 0 | 3 |
| VAL_Balance_NewEdit | Microflow | 13 | 1 | 0 | 1 |
| VAL_BudgetTypeTerm_New | Microflow | 21 | 1 | 0 | 1 |
| VAL_Transaction_NewEdit | Microflow | 28 | 1 | 0 | 1 |

## Tier 1 Deep Narratives

### SmartExpenses.ACR_FBGProfile_setStandardBudgets

- Intent: General behavioural flow.
- Trigger/entry: microflow/nanoflow entry based on caller or UI action.
- Inputs/outputs: derived from flow node graph; explicit parameter typing is not fully exported.
- Read/write entities: SmartExpenses.BudgetTerm, SmartExpenses.BudgetType, SmartExpenses.StandardBudget.
- UI interactions (shown pages): none.
- Calls/called-by: out=1, in=0.
- Security constraints touched: module roles derived via page permissions and entity access rules.
- Failure/rollback notes: Rollback hint detected in flow node detail.

### SmartExpenses.ACT_Balance_Create

- Intent: User action flow.
- Trigger/entry: microflow/nanoflow entry based on caller or UI action.
- Inputs/outputs: derived from flow node graph; explicit parameter typing is not fully exported.
- Read/write entities: SmartExpenses.Balance.
- UI interactions (shown pages): SmartExpenses.Balance_NewEdit.
- Calls/called-by: out=0, in=0.
- Security constraints touched: module roles derived via page permissions and entity access rules.
- Failure/rollback notes: No rollback behaviour was explicitly indicated in exported node detail.

### SmartExpenses.ACT_Balance_NewEdit

- Intent: User action flow.
- Trigger/entry: microflow/nanoflow entry based on caller or UI action.
- Inputs/outputs: derived from flow node graph; explicit parameter typing is not fully exported.
- Read/write entities: none.
- UI interactions (shown pages): none.
- Calls/called-by: out=1, in=0.
- Security constraints touched: module roles derived via page permissions and entity access rules.
- Failure/rollback notes: No rollback behaviour was explicitly indicated in exported node detail.

### SmartExpenses.ACT_BudgetTerm_BudgetType_Edit

- Intent: User action flow.
- Trigger/entry: microflow/nanoflow entry based on caller or UI action.
- Inputs/outputs: derived from flow node graph; explicit parameter typing is not fully exported.
- Read/write entities: SmartExpenses.Logo.
- UI interactions (shown pages): SmartExpenses.BudgetTerm_NewEdit.
- Calls/called-by: out=0, in=0.
- Security constraints touched: module roles derived via page permissions and entity access rules.
- Failure/rollback notes: No rollback behaviour was explicitly indicated in exported node detail.

### SmartExpenses.ACT_BudgetTerm_New

- Intent: User action flow.
- Trigger/entry: microflow/nanoflow entry based on caller or UI action.
- Inputs/outputs: derived from flow node graph; explicit parameter typing is not fully exported.
- Read/write entities: SmartExpenses.BudgetTerm.
- UI interactions (shown pages): none.
- Calls/called-by: out=1, in=0.
- Security constraints touched: module roles derived via page permissions and entity access rules.
- Failure/rollback notes: Rollback hint detected in flow node detail.

### SmartExpenses.ACT_BudgetTerm_setStartdateOnInterval

- Intent: User action flow.
- Trigger/entry: microflow/nanoflow entry based on caller or UI action.
- Inputs/outputs: derived from flow node graph; explicit parameter typing is not fully exported.
- Read/write entities: none.
- UI interactions (shown pages): none.
- Calls/called-by: out=0, in=0.
- Security constraints touched: module roles derived via page permissions and entity access rules.
- Failure/rollback notes: No rollback behaviour was explicitly indicated in exported node detail.

### SmartExpenses.ACT_BudgetType_New

- Intent: User action flow.
- Trigger/entry: microflow/nanoflow entry based on caller or UI action.
- Inputs/outputs: derived from flow node graph; explicit parameter typing is not fully exported.
- Read/write entities: SmartExpenses.BudgetTerm, SmartExpenses.BudgetType, SmartExpenses.Logo.
- UI interactions (shown pages): SmartExpenses.BudgetTerm_NewEdit.
- Calls/called-by: out=0, in=0.
- Security constraints touched: module roles derived via page permissions and entity access rules.
- Failure/rollback notes: No rollback behaviour was explicitly indicated in exported node detail.

### SmartExpenses.ACT_BudgetType_OpenOverviewPAge

- Intent: User action flow.
- Trigger/entry: microflow/nanoflow entry based on caller or UI action.
- Inputs/outputs: derived from flow node graph; explicit parameter typing is not fully exported.
- Read/write entities: none.
- UI interactions (shown pages): SmartExpenses.BudgetType_Overview.
- Calls/called-by: out=1, in=0.
- Security constraints touched: module roles derived via page permissions and entity access rules.
- Failure/rollback notes: No rollback behaviour was explicitly indicated in exported node detail.

### SmartExpenses.ACT_BudgetType_Save

- Intent: User action flow.
- Trigger/entry: microflow/nanoflow entry based on caller or UI action.
- Inputs/outputs: derived from flow node graph; explicit parameter typing is not fully exported.
- Read/write entities: none.
- UI interactions (shown pages): none.
- Calls/called-by: out=1, in=0.
- Security constraints touched: module roles derived via page permissions and entity access rules.
- Failure/rollback notes: No rollback behaviour was explicitly indicated in exported node detail.

### SmartExpenses.ACT_DateHelper_Create

- Intent: User action flow.
- Trigger/entry: microflow/nanoflow entry based on caller or UI action.
- Inputs/outputs: derived from flow node graph; explicit parameter typing is not fully exported.
- Read/write entities: SmartExpenses.DateHelper.
- UI interactions (shown pages): none.
- Calls/called-by: out=0, in=1.
- Security constraints touched: module roles derived via page permissions and entity access rules.
- Failure/rollback notes: No rollback behaviour was explicitly indicated in exported node detail.

### SmartExpenses.ACT_FBGProfile_showParentPage

- Intent: User action flow.
- Trigger/entry: microflow/nanoflow entry based on caller or UI action.
- Inputs/outputs: derived from flow node graph; explicit parameter typing is not fully exported.
- Read/write entities: SmartExpenses.FBGProfile.
- UI interactions (shown pages): SmartExpenses.Home_Parent.
- Calls/called-by: out=0, in=0.
- Security constraints touched: module roles derived via page permissions and entity access rules.
- Failure/rollback notes: No rollback behaviour was explicitly indicated in exported node detail.

### SmartExpenses.ACT_StandardBudget_Edit

- Intent: User action flow.
- Trigger/entry: microflow/nanoflow entry based on caller or UI action.
- Inputs/outputs: derived from flow node graph; explicit parameter typing is not fully exported.
- Read/write entities: SmartExpenses.Logo, SmartExpenses.StandardBudget.
- UI interactions (shown pages): SmartExpenses.StandardBudget_NewEdit.
- Calls/called-by: out=0, in=0.
- Security constraints touched: module roles derived via page permissions and entity access rules.
- Failure/rollback notes: No rollback behaviour was explicitly indicated in exported node detail.

### SmartExpenses.ACT_StandardBudget_New

- Intent: User action flow.
- Trigger/entry: microflow/nanoflow entry based on caller or UI action.
- Inputs/outputs: derived from flow node graph; explicit parameter typing is not fully exported.
- Read/write entities: SmartExpenses.Logo, SmartExpenses.StandardBudget.
- UI interactions (shown pages): SmartExpenses.StandardBudget_NewEdit.
- Calls/called-by: out=0, in=0.
- Security constraints touched: module roles derived via page permissions and entity access rules.
- Failure/rollback notes: No rollback behaviour was explicitly indicated in exported node detail.

### SmartExpenses.ACT_Transaction_BulkEditCreate

- Intent: User action flow.
- Trigger/entry: microflow/nanoflow entry based on caller or UI action.
- Inputs/outputs: derived from flow node graph; explicit parameter typing is not fully exported.
- Read/write entities: SmartExpenses.BulkEditHelper.
- UI interactions (shown pages): SmartExpenses.Transaction_BulkEdit.
- Calls/called-by: out=0, in=0.
- Security constraints touched: module roles derived via page permissions and entity access rules.
- Failure/rollback notes: No rollback behaviour was explicitly indicated in exported node detail.

### SmartExpenses.ACT_Transaction_BulkEditSave

- Intent: User action flow.
- Trigger/entry: microflow/nanoflow entry based on caller or UI action.
- Inputs/outputs: derived from flow node graph; explicit parameter typing is not fully exported.
- Read/write entities: SmartExpenses.Transaction.
- UI interactions (shown pages): none.
- Calls/called-by: out=3, in=0.
- Security constraints touched: module roles derived via page permissions and entity access rules.
- Failure/rollback notes: No rollback behaviour was explicitly indicated in exported node detail.

### SmartExpenses.ACT_Transaction_Create

- Intent: User action flow.
- Trigger/entry: microflow/nanoflow entry based on caller or UI action.
- Inputs/outputs: derived from flow node graph; explicit parameter typing is not fully exported.
- Read/write entities: SmartExpenses.Transaction.
- UI interactions (shown pages): SmartExpenses.Transaction_New.
- Calls/called-by: out=0, in=0.
- Security constraints touched: module roles derived via page permissions and entity access rules.
- Failure/rollback notes: No rollback behaviour was explicitly indicated in exported node detail.

### SmartExpenses.ACT_Transaction_NewEdit_Save

- Intent: User action flow.
- Trigger/entry: microflow/nanoflow entry based on caller or UI action.
- Inputs/outputs: derived from flow node graph; explicit parameter typing is not fully exported.
- Read/write entities: none.
- UI interactions (shown pages): none.
- Calls/called-by: out=2, in=0.
- Security constraints touched: module roles derived via page permissions and entity access rules.
- Failure/rollback notes: No rollback behaviour was explicitly indicated in exported node detail.

### SmartExpenses.ACT_Transaction_Recalculate_all

- Intent: User action flow.
- Trigger/entry: microflow/nanoflow entry based on caller or UI action.
- Inputs/outputs: derived from flow node graph; explicit parameter typing is not fully exported.
- Read/write entities: SmartExpenses.Balance, SmartExpenses.BudgetType.
- UI interactions (shown pages): none.
- Calls/called-by: out=3, in=0.
- Security constraints touched: module roles derived via page permissions and entity access rules.
- Failure/rollback notes: No rollback behaviour was explicitly indicated in exported node detail.

### SmartExpenses.BCO_Transaction

- Intent: General behavioural flow.
- Trigger/entry: microflow/nanoflow entry based on caller or UI action.
- Inputs/outputs: derived from flow node graph; explicit parameter typing is not fully exported.
- Read/write entities: none.
- UI interactions (shown pages): none.
- Calls/called-by: out=2, in=0.
- Security constraints touched: module roles derived via page permissions and entity access rules.
- Failure/rollback notes: No rollback behaviour was explicitly indicated in exported node detail.

### SmartExpenses.BD_Transaction

- Intent: General behavioural flow.
- Trigger/entry: microflow/nanoflow entry based on caller or UI action.
- Inputs/outputs: derived from flow node graph; explicit parameter typing is not fully exported.
- Read/write entities: none.
- UI interactions (shown pages): none.
- Calls/called-by: out=2, in=0.
- Security constraints touched: module roles derived via page permissions and entity access rules.
- Failure/rollback notes: No rollback behaviour was explicitly indicated in exported node detail.

### SmartExpenses.DS_BudgetTerm_New

- Intent: Datasource flow.
- Trigger/entry: microflow/nanoflow entry based on caller or UI action.
- Inputs/outputs: derived from flow node graph; explicit parameter typing is not fully exported.
- Read/write entities: SmartExpenses.BudgetTerm.
- UI interactions (shown pages): none.
- Calls/called-by: out=0, in=2.
- Security constraints touched: module roles derived via page permissions and entity access rules.
- Failure/rollback notes: No rollback behaviour was explicitly indicated in exported node detail.

### SmartExpenses.DS_FBGProfile_Retreive_current

- Intent: Datasource flow.
- Trigger/entry: microflow/nanoflow entry based on caller or UI action.
- Inputs/outputs: derived from flow node graph; explicit parameter typing is not fully exported.
- Read/write entities: Administration.Account, SmartExpenses.FBGProfile.
- UI interactions (shown pages): none.
- Calls/called-by: out=0, in=0.
- Security constraints touched: module roles derived via page permissions and entity access rules.
- Failure/rollback notes: No rollback behaviour was explicitly indicated in exported node detail.

### SmartExpenses.Nanoflow

- Intent: General behavioural flow.
- Trigger/entry: microflow/nanoflow entry based on caller or UI action.
- Inputs/outputs: derived from flow node graph; explicit parameter typing is not fully exported.
- Read/write entities: none.
- UI interactions (shown pages): SmartExpenses.BudgetType_Overview.
- Calls/called-by: out=0, in=0.
- Security constraints touched: module roles derived via page permissions and entity access rules.
- Failure/rollback notes: No rollback behaviour was explicitly indicated in exported node detail.

### SmartExpenses.OCH_Transaction_setBudgetTerm_och_BudgetType

- Intent: General behavioural flow.
- Trigger/entry: microflow/nanoflow entry based on caller or UI action.
- Inputs/outputs: derived from flow node graph; explicit parameter typing is not fully exported.
- Read/write entities: SmartExpenses.BudgetTerm.
- UI interactions (shown pages): none.
- Calls/called-by: out=0, in=0.
- Security constraints touched: module roles derived via page permissions and entity access rules.
- Failure/rollback notes: No rollback behaviour was explicitly indicated in exported node detail.

### SmartExpenses.SUB_Balance_Recalculate

- Intent: General behavioural flow.
- Trigger/entry: microflow/nanoflow entry based on caller or UI action.
- Inputs/outputs: derived from flow node graph; explicit parameter typing is not fully exported.
- Read/write entities: SmartExpenses.Transaction.
- UI interactions (shown pages): none.
- Calls/called-by: out=0, in=3.
- Security constraints touched: module roles derived via page permissions and entity access rules.
- Failure/rollback notes: Rollback hint detected in flow node detail.

### SmartExpenses.SUB_BudgetTerm_Recalculate

- Intent: General behavioural flow.
- Trigger/entry: microflow/nanoflow entry based on caller or UI action.
- Inputs/outputs: derived from flow node graph; explicit parameter typing is not fully exported.
- Read/write entities: SmartExpenses.Transaction.
- UI interactions (shown pages): none.
- Calls/called-by: out=0, in=3.
- Security constraints touched: module roles derived via page permissions and entity access rules.
- Failure/rollback notes: Rollback hint detected in flow node detail.

### SmartExpenses.SUB_Transaction_CalculateBalance

- Intent: General behavioural flow.
- Trigger/entry: microflow/nanoflow entry based on caller or UI action.
- Inputs/outputs: derived from flow node graph; explicit parameter typing is not fully exported.
- Read/write entities: none.
- UI interactions (shown pages): none.
- Calls/called-by: out=1, in=2.
- Security constraints touched: module roles derived via page permissions and entity access rules.
- Failure/rollback notes: No rollback behaviour was explicitly indicated in exported node detail.

### SmartExpenses.SUB_Transaction_CalculateBudgetTerm

- Intent: General behavioural flow.
- Trigger/entry: microflow/nanoflow entry based on caller or UI action.
- Inputs/outputs: derived from flow node graph; explicit parameter typing is not fully exported.
- Read/write entities: none.
- UI interactions (shown pages): none.
- Calls/called-by: out=1, in=2.
- Security constraints touched: module roles derived via page permissions and entity access rules.
- Failure/rollback notes: No rollback behaviour was explicitly indicated in exported node detail.

### SmartExpenses.SUB_Transaction_setStatus

- Intent: General behavioural flow.
- Trigger/entry: microflow/nanoflow entry based on caller or UI action.
- Inputs/outputs: derived from flow node graph; explicit parameter typing is not fully exported.
- Read/write entities: none.
- UI interactions (shown pages): none.
- Calls/called-by: out=0, in=3.
- Security constraints touched: module roles derived via page permissions and entity access rules.
- Failure/rollback notes: No rollback behaviour was explicitly indicated in exported node detail.

### SmartExpenses.VAL_Balance_NewEdit

- Intent: Validation flow.
- Trigger/entry: microflow/nanoflow entry based on caller or UI action.
- Inputs/outputs: derived from flow node graph; explicit parameter typing is not fully exported.
- Read/write entities: none.
- UI interactions (shown pages): none.
- Calls/called-by: out=0, in=1.
- Security constraints touched: module roles derived via page permissions and entity access rules.
- Failure/rollback notes: Rollback hint detected in flow node detail.

### SmartExpenses.VAL_BudgetTypeTerm_New

- Intent: Validation flow.
- Trigger/entry: microflow/nanoflow entry based on caller or UI action.
- Inputs/outputs: derived from flow node graph; explicit parameter typing is not fully exported.
- Read/write entities: none.
- UI interactions (shown pages): none.
- Calls/called-by: out=0, in=1.
- Security constraints touched: module roles derived via page permissions and entity access rules.
- Failure/rollback notes: Rollback hint detected in flow node detail.

### SmartExpenses.VAL_Transaction_NewEdit

- Intent: Validation flow.
- Trigger/entry: microflow/nanoflow entry based on caller or UI action.
- Inputs/outputs: derived from flow node graph; explicit parameter typing is not fully exported.
- Read/write entities: none.
- UI interactions (shown pages): none.
- Calls/called-by: out=0, in=1.
- Security constraints touched: module roles derived via page permissions and entity access rules.
- Failure/rollback notes: Rollback hint detected in flow node detail.

## Flow Links

| Flow | Type | Tier | L0 | L1 | L2 |
|---|---|---:|---|---|---|
| SmartExpenses.ACR_FBGProfile_setStandardBudgets | Microflow | 1 | [L0](flows/smartexpenses-acr-fbgprofile-setstandardbudgets.abstract.md) | [L1](flows/smartexpenses-acr-fbgprofile-setstandardbudgets.overview.md) | [L2](../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-acr-fbgprofile-setstandardbudgets.json) |
| SmartExpenses.ACT_Balance_Create | Microflow | 1 | [L0](flows/smartexpenses-act-balance-create.abstract.md) | [L1](flows/smartexpenses-act-balance-create.overview.md) | [L2](../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-act-balance-create.json) |
| SmartExpenses.ACT_Balance_NewEdit | Microflow | 1 | [L0](flows/smartexpenses-act-balance-newedit.abstract.md) | [L1](flows/smartexpenses-act-balance-newedit.overview.md) | [L2](../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-act-balance-newedit.json) |
| SmartExpenses.ACT_BudgetTerm_BudgetType_Edit | Microflow | 1 | [L0](flows/smartexpenses-act-budgetterm-budgettype-edit.abstract.md) | [L1](flows/smartexpenses-act-budgetterm-budgettype-edit.overview.md) | [L2](../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-act-budgetterm-budgettype-edit.json) |
| SmartExpenses.ACT_BudgetTerm_New | Microflow | 1 | [L0](flows/smartexpenses-act-budgetterm-new.abstract.md) | [L1](flows/smartexpenses-act-budgetterm-new.overview.md) | [L2](../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-act-budgetterm-new.json) |
| SmartExpenses.ACT_BudgetTerm_setStartdateOnInterval | Nanoflow | 1 | [L0](flows/smartexpenses-act-budgetterm-setstartdateoninterval.abstract.md) | [L1](flows/smartexpenses-act-budgetterm-setstartdateoninterval.overview.md) | [L2](../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-act-budgetterm-setstartdateoninterval.json) |
| SmartExpenses.ACT_BudgetType_New | Microflow | 1 | [L0](flows/smartexpenses-act-budgettype-new.abstract.md) | [L1](flows/smartexpenses-act-budgettype-new.overview.md) | [L2](../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-act-budgettype-new.json) |
| SmartExpenses.ACT_BudgetType_OpenOverviewPAge | Microflow | 1 | [L0](flows/smartexpenses-act-budgettype-openoverviewpage.abstract.md) | [L1](flows/smartexpenses-act-budgettype-openoverviewpage.overview.md) | [L2](../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-act-budgettype-openoverviewpage.json) |
| SmartExpenses.ACT_BudgetType_Save | Microflow | 1 | [L0](flows/smartexpenses-act-budgettype-save.abstract.md) | [L1](flows/smartexpenses-act-budgettype-save.overview.md) | [L2](../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-act-budgettype-save.json) |
| SmartExpenses.ACT_DateHelper_Create | Microflow | 1 | [L0](flows/smartexpenses-act-datehelper-create.abstract.md) | [L1](flows/smartexpenses-act-datehelper-create.overview.md) | [L2](../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-act-datehelper-create.json) |
| SmartExpenses.ACT_FBGProfile_showParentPage | Microflow | 1 | [L0](flows/smartexpenses-act-fbgprofile-showparentpage.abstract.md) | [L1](flows/smartexpenses-act-fbgprofile-showparentpage.overview.md) | [L2](../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-act-fbgprofile-showparentpage.json) |
| SmartExpenses.ACT_StandardBudget_Edit | Microflow | 1 | [L0](flows/smartexpenses-act-standardbudget-edit.abstract.md) | [L1](flows/smartexpenses-act-standardbudget-edit.overview.md) | [L2](../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-act-standardbudget-edit.json) |
| SmartExpenses.ACT_StandardBudget_New | Microflow | 1 | [L0](flows/smartexpenses-act-standardbudget-new.abstract.md) | [L1](flows/smartexpenses-act-standardbudget-new.overview.md) | [L2](../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-act-standardbudget-new.json) |
| SmartExpenses.ACT_Transaction_BulkEditCreate | Microflow | 1 | [L0](flows/smartexpenses-act-transaction-bulkeditcreate.abstract.md) | [L1](flows/smartexpenses-act-transaction-bulkeditcreate.overview.md) | [L2](../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-act-transaction-bulkeditcreate.json) |
| SmartExpenses.ACT_Transaction_BulkEditSave | Microflow | 1 | [L0](flows/smartexpenses-act-transaction-bulkeditsave.abstract.md) | [L1](flows/smartexpenses-act-transaction-bulkeditsave.overview.md) | [L2](../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-act-transaction-bulkeditsave.json) |
| SmartExpenses.ACT_Transaction_Create | Microflow | 1 | [L0](flows/smartexpenses-act-transaction-create.abstract.md) | [L1](flows/smartexpenses-act-transaction-create.overview.md) | [L2](../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-act-transaction-create.json) |
| SmartExpenses.ACT_Transaction_NewEdit_Save | Microflow | 1 | [L0](flows/smartexpenses-act-transaction-newedit-save.abstract.md) | [L1](flows/smartexpenses-act-transaction-newedit-save.overview.md) | [L2](../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-act-transaction-newedit-save.json) |
| SmartExpenses.ACT_Transaction_Recalculate_all | Microflow | 1 | [L0](flows/smartexpenses-act-transaction-recalculate-all.abstract.md) | [L1](flows/smartexpenses-act-transaction-recalculate-all.overview.md) | [L2](../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-act-transaction-recalculate-all.json) |
| SmartExpenses.BCO_Transaction | Microflow | 1 | [L0](flows/smartexpenses-bco-transaction.abstract.md) | [L1](flows/smartexpenses-bco-transaction.overview.md) | [L2](../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-bco-transaction.json) |
| SmartExpenses.BD_Transaction | Microflow | 1 | [L0](flows/smartexpenses-bd-transaction.abstract.md) | [L1](flows/smartexpenses-bd-transaction.overview.md) | [L2](../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-bd-transaction.json) |
| SmartExpenses.DS_BudgetTerm_New | Microflow | 1 | [L0](flows/smartexpenses-ds-budgetterm-new.abstract.md) | [L1](flows/smartexpenses-ds-budgetterm-new.overview.md) | [L2](../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-ds-budgetterm-new.json) |
| SmartExpenses.DS_BudgetTerm_Retrieve_current | Microflow | 2 | [L0](flows/smartexpenses-ds-budgetterm-retrieve-current.abstract.md) | [L1](flows/smartexpenses-ds-budgetterm-retrieve-current.overview.md) | [L2](../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-ds-budgetterm-retrieve-current.json) |
| SmartExpenses.DS_BudgetType_Retrieve | Microflow | 2 | [L0](flows/smartexpenses-ds-budgettype-retrieve.abstract.md) | [L1](flows/smartexpenses-ds-budgettype-retrieve.overview.md) | [L2](../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-ds-budgettype-retrieve.json) |
| SmartExpenses.DS_FBGProfile_Retreive_current | Microflow | 1 | [L0](flows/smartexpenses-ds-fbgprofile-retreive-current.abstract.md) | [L1](flows/smartexpenses-ds-fbgprofile-retreive-current.overview.md) | [L2](../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-ds-fbgprofile-retreive-current.json) |
| SmartExpenses.DS_TotalBalance_Calculate | Microflow | 2 | [L0](flows/smartexpenses-ds-totalbalance-calculate.abstract.md) | [L1](flows/smartexpenses-ds-totalbalance-calculate.overview.md) | [L2](../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-ds-totalbalance-calculate.json) |
| SmartExpenses.Nanoflow | Nanoflow | 1 | [L0](flows/smartexpenses-nanoflow.abstract.md) | [L1](flows/smartexpenses-nanoflow.overview.md) | [L2](../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-nanoflow.json) |
| SmartExpenses.OCH_BulkEditHelper_setBalance | Nanoflow | 2 | [L0](flows/smartexpenses-och-bulkedithelper-setbalance.abstract.md) | [L1](flows/smartexpenses-och-bulkedithelper-setbalance.overview.md) | [L2](../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-och-bulkedithelper-setbalance.json) |
| SmartExpenses.OCH_BulkEditHelper_setBudgetTerm | Nanoflow | 2 | [L0](flows/smartexpenses-och-bulkedithelper-setbudgetterm.abstract.md) | [L1](flows/smartexpenses-och-bulkedithelper-setbudgetterm.overview.md) | [L2](../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-och-bulkedithelper-setbudgetterm.json) |
| SmartExpenses.OCH_Transaction_setBalance | Nanoflow | 2 | [L0](flows/smartexpenses-och-transaction-setbalance.abstract.md) | [L1](flows/smartexpenses-och-transaction-setbalance.overview.md) | [L2](../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-och-transaction-setbalance.json) |
| SmartExpenses.OCH_Transaction_setBudgetTerm | Nanoflow | 2 | [L0](flows/smartexpenses-och-transaction-setbudgetterm.abstract.md) | [L1](flows/smartexpenses-och-transaction-setbudgetterm.overview.md) | [L2](../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-och-transaction-setbudgetterm.json) |
| SmartExpenses.OCH_Transaction_setBudgetTerm_och_BudgetType | Nanoflow | 1 | [L0](flows/smartexpenses-och-transaction-setbudgetterm-och-budgettype.abstract.md) | [L1](flows/smartexpenses-och-transaction-setbudgetterm-och-budgettype.overview.md) | [L2](../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-och-transaction-setbudgetterm-och-budgettype.json) |
| SmartExpenses.SUB_Balance_Recalculate | Microflow | 1 | [L0](flows/smartexpenses-sub-balance-recalculate.abstract.md) | [L1](flows/smartexpenses-sub-balance-recalculate.overview.md) | [L2](../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-sub-balance-recalculate.json) |
| SmartExpenses.SUB_BudgetTerm_Recalculate | Microflow | 1 | [L0](flows/smartexpenses-sub-budgetterm-recalculate.abstract.md) | [L1](flows/smartexpenses-sub-budgetterm-recalculate.overview.md) | [L2](../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-sub-budgetterm-recalculate.json) |
| SmartExpenses.SUB_Transaction_CalculateBalance | Microflow | 1 | [L0](flows/smartexpenses-sub-transaction-calculatebalance.abstract.md) | [L1](flows/smartexpenses-sub-transaction-calculatebalance.overview.md) | [L2](../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-sub-transaction-calculatebalance.json) |
| SmartExpenses.SUB_Transaction_CalculateBudgetTerm | Microflow | 1 | [L0](flows/smartexpenses-sub-transaction-calculatebudgetterm.abstract.md) | [L1](flows/smartexpenses-sub-transaction-calculatebudgetterm.overview.md) | [L2](../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-sub-transaction-calculatebudgetterm.json) |
| SmartExpenses.SUB_Transaction_setStatus | Microflow | 1 | [L0](flows/smartexpenses-sub-transaction-setstatus.abstract.md) | [L1](flows/smartexpenses-sub-transaction-setstatus.overview.md) | [L2](../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-sub-transaction-setstatus.json) |
| SmartExpenses.VAL_Balance_NewEdit | Microflow | 1 | [L0](flows/smartexpenses-val-balance-newedit.abstract.md) | [L1](flows/smartexpenses-val-balance-newedit.overview.md) | [L2](../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-val-balance-newedit.json) |
| SmartExpenses.VAL_BudgetTypeTerm_New | Microflow | 1 | [L0](flows/smartexpenses-val-budgettypeterm-new.abstract.md) | [L1](flows/smartexpenses-val-budgettypeterm-new.overview.md) | [L2](../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-val-budgettypeterm-new.json) |
| SmartExpenses.VAL_Transaction_NewEdit | Microflow | 1 | [L0](flows/smartexpenses-val-transaction-newedit.abstract.md) | [L1](flows/smartexpenses-val-transaction-newedit.overview.md) | [L2](../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-val-transaction-newedit.json) |
