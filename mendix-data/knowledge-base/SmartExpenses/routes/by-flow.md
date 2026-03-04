# Flow Index

Cross-reference of all flows with their call relationships, pages shown, and entities touched.

## SmartExpenses Microflows

| Flow | Calls | Called By | Shows Pages | Key Entities |
|------|-------|----------|-------------|--------------|
| ACR_FBGProfile_setStandardBudgets | DS_BudgetTerm_New | — | — | StandardBudget, BudgetType, BudgetTerm |
| ACT_Balance_Create | — | — | Balance_NewEdit | Balance |
| ACT_Balance_NewEdit | VAL_Balance_NewEdit | — | — | Balance |
| ACT_BudgetTerm_BudgetType_Edit | — | — | BudgetTerm_NewEdit | BudgetType, Logo |
| ACT_BudgetTerm_New | DS_BudgetTerm_New | — | — | BudgetType, BudgetTerm |
| ACT_BudgetType_New | — | — | BudgetTerm_NewEdit | Logo, BudgetType, BudgetTerm |
| ACT_BudgetType_OpenOverviewPAge | ACT_DateHelper_Create | — | BudgetType_Overview | DateHelper |
| ACT_BudgetType_Save | VAL_BudgetTypeTerm_New | — | — | BudgetType, BudgetTerm |
| ACT_DateHelper_Create | — | ACT_BudgetType_OpenOverviewPAge | — | DateHelper |
| ACT_FBGProfile_showParentPage | — | — | Home_Parent | FBGProfile |
| ACT_StandardBudget_Edit | — | — | StandardBudget_NewEdit | StandardBudget, Logo |
| ACT_StandardBudget_New | — | — | StandardBudget_NewEdit | Logo, StandardBudget |
| ACT_Transaction_BulkEditCreate | — | — | Transaction_BulkEdit | BulkEditHelper |
| ACT_Transaction_BulkEditSave | SUB_Transaction_setStatus, SUB_Balance_Recalculate, SUB_BudgetTerm_Recalculate | — | — | Transaction, Balance, BudgetTerm |
| ACT_Transaction_Create | — | — | Transaction_New | Transaction |
| ACT_Transaction_NewEdit_Save | VAL_Transaction_NewEdit, SUB_Transaction_setStatus | — | — | Transaction |
| ACT_Transaction_Recalculate_all | SUB_BudgetTerm_Recalculate, SUB_Balance_Recalculate, DS_TotalBalance_Calculate | — | — | BudgetType, BudgetTerm, Balance, FBGProfile |
| BCO_Transaction | SUB_Transaction_CalculateBalance, SUB_Transaction_CalculateBudgetTerm | — | — | Transaction |
| BD_Transaction | SUB_Transaction_CalculateBalance, SUB_Transaction_CalculateBudgetTerm | — | — | Transaction |
| DS_BudgetTerm_New | — | ACR_FBGProfile_setStandardBudgets, ACT_BudgetTerm_New | — | BudgetTerm |
| DS_BudgetTerm_Retrieve_current | — | — | — | BudgetTerm |
| DS_BudgetType_Retrieve | — | — | — | BudgetType |
| DS_FBGProfile_Retreive_current | — | — | — | FBGProfile, Account |
| DS_TotalBalance_Calculate | — | ACT_Transaction_Recalculate_all | — | Balance |
| NEW_MICROFLOW_test | — | — | — | — |
| SUB_Balance_Recalculate | — | ACT_Transaction_BulkEditSave, ACT_Transaction_Recalculate_all, SUB_Transaction_CalculateBalance | — | Transaction, Balance |
| SUB_BudgetTerm_Recalculate | — | ACT_Transaction_BulkEditSave, ACT_Transaction_Recalculate_all, SUB_Transaction_CalculateBudgetTerm | — | Transaction, BudgetTerm |
| SUB_Transaction_CalculateBalance | — | BCO_Transaction, BD_Transaction | — | Transaction, Balance |
| SUB_Transaction_CalculateBudgetTerm | — | BCO_Transaction, BD_Transaction | — | Transaction, BudgetTerm |
| SUB_Transaction_setStatus | — | ACT_Transaction_BulkEditSave, ACT_Transaction_NewEdit_Save, IH.ACT_ImportTransaction_AcceptTransactions | — | Transaction |
| VAL_Balance_NewEdit | — | ACT_Balance_NewEdit | — | Balance |
| VAL_BudgetTypeTerm_New | — | ACT_BudgetType_Save | — | BudgetType, BudgetTerm |
| VAL_Transaction_NewEdit | — | ACT_Transaction_NewEdit_Save | — | Transaction |

## SmartExpenses Nanoflows

| Flow | Calls | Called By | Shows Pages | Key Entities |
|------|-------|----------|-------------|--------------|
| ACT_BudgetTerm_setStartdateOnInterval | — | — | — | BudgetTerm |
| Nanoflow | — | — | BudgetType_Overview | — |
| NEW_NANOFLOW | — | — | — | — |
| OCH_BulkEditHelper_setBalance | — | — | — | BulkEditHelper |
| OCH_BulkEditHelper_setBudgetTerm | — | — | — | BulkEditHelper |
| OCH_Transaction_setBalance | — | — | — | Transaction |
| OCH_Transaction_setBudgetTerm | — | — | — | Transaction |
| OCH_Transaction_setBudgetTerm_och_BudgetType | — | — | — | Transaction, BudgetTerm |

## ImporterHelper Flows

| Flow | Calls | Called By | Shows Pages | Key Entities |
|------|-------|----------|-------------|--------------|
| ACT_ExcelFileImport_Create | — | — | ExcelFileImport_Upload | ExcelFileImport, ImportTransactionHelper |
| ACT_ExcelFileImport_ImportToNP | SUB_ImportTemplateDocument | — | — | ExcelFileImport, ImportTransactionHelper |
| ACT_ImportTransaction_AcceptTransactions | SmartExpenses.SUB_Transaction_setStatus | ACT_ImportTransaction_Refreshpage | — | ImportTransaction, SmartExpenses.Transaction |
| ACT_ImportTransaction_ShowPage | — | — | ImportTransaction_Overview | ImportTransactionHelper |
| CWS_GetProducts | — | — | — | — |
| SUB_ImportTemplateDocument | — | ACT_ExcelFileImport_ImportToNP | — | ExcelFileImport |
| ACT_ImportTransaction_Refreshpage (NF) | ACT_ImportTransaction_AcceptTransactions | — | — | — |
