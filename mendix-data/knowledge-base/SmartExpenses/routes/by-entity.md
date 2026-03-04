# Entity Index

Cross-reference of all entities with the flows and pages that use them.

## SmartExpenses Entities

| Entity | Flows That Use It | Pages That Display It |
|--------|-------------------|-----------------------|
| SmartExpenses.Balance | ACT_Balance_Create (create), ACT_Balance_NewEdit (commit), SUB_Balance_Recalculate (retrieve, change), ACT_Transaction_Recalculate_all (retrieve, commit), ACT_Transaction_BulkEditSave (retrieve), DS_TotalBalance_Calculate (retrieve, aggregate) | Balance_NewEdit, Balance_MasterNewEdit, Balance_MasterOverview, BalanceType_Overview |
| SmartExpenses.BudgetTerm | ACT_BudgetTerm_New (create), ACT_BudgetType_New (create), ACT_BudgetType_Save (commit), DS_BudgetTerm_New (create, retrieve), DS_BudgetTerm_Retrieve_current (retrieve), SUB_BudgetTerm_Recalculate (retrieve, change), ACT_Transaction_Recalculate_all (retrieve, commit), ACR_FBGProfile_setStandardBudgets (create list) | BudgetTerm_NewEdit, BudgetTerm_EditQuick, BudgetTerm_MasterNewEdit, BudgetTerm_MasterOverview, BudgetTerm_Overview |
| SmartExpenses.BudgetType | ACT_BudgetTerm_BudgetType_Edit (retrieve), ACT_BudgetTerm_New (retrieve), ACT_BudgetType_New (create), ACT_BudgetType_Save (commit), ACR_FBGProfile_setStandardBudgets (create), DS_BudgetType_Retrieve (retrieve), ACT_Transaction_Recalculate_all (retrieve, commit) | BudgetType_Overview, BudgetType_Overview_2, BudgetType_NewEdit_Master, BudgetTerm_NewEdit |
| SmartExpenses.BulkEditHelper | ACT_Transaction_BulkEditCreate (create), ACT_Transaction_BulkEditSave (retrieve associations) | Transaction_BulkEdit |
| SmartExpenses.DateHelper | ACT_DateHelper_Create (create) | BudgetType_Overview |
| SmartExpenses.FBGProfile | DS_FBGProfile_Retreive_current (retrieve/create), ACT_FBGProfile_showParentPage (retrieve), ACT_Transaction_Recalculate_all (change) | FBGProfile_NewEdit, FBGProfile_Overview, FBGProfile_Overview_2, Home_Parent, BalanceType_Overview, BudgetType_Overview, Transaction_Overview, Transaction_BulkEdit |
| SmartExpenses.Logo | ACT_BudgetType_New (create), ACT_StandardBudget_Edit (create), ACT_StandardBudget_New (create), ACT_BudgetTerm_BudgetType_Edit (create) | — |
| SmartExpenses.New_entity | — | — |
| SmartExpenses.StandardBudget | ACR_FBGProfile_setStandardBudgets (retrieve), ACT_StandardBudget_Edit (show/create), ACT_StandardBudget_New (create) | StandardBudget_NewEdit, StandardBudget_Overview |
| SmartExpenses.Transaction | ACT_Transaction_Create (create), ACT_Transaction_NewEdit_Save (commit), ACT_Transaction_BulkEditSave (change list), SUB_Transaction_setStatus (change), SUB_Balance_Recalculate (retrieve), SUB_BudgetTerm_Recalculate (retrieve), BCO_Transaction (event), BD_Transaction (event), ImporterHelper.ACT_ImportTransaction_AcceptTransactions (create) | Transaction_New, Transaction_Edit, Transaction_EditQuick, Transaction_NewEdit, Transaction_Overview, Transaction_Overview_2, Transaction_BulkEdit |

## ImporterHelper Entities

| Entity | Flows That Use It | Pages That Display It |
|--------|-------------------|-----------------------|
| ImporterHelper.ExcelFileImport | ACT_ExcelFileImport_Create (create), ACT_ExcelFileImport_ImportToNP (commit) | ExcelFileImport_Upload |
| ImporterHelper.ImportTransaction | ACT_ImportTransaction_AcceptTransactions (retrieve, delete), SUB_ImportTemplateDocument (import target) | ImportTransaction_Edit, ImportTransaction_Overview |
| ImporterHelper.ImportTransactionHelper | ACT_ImportTransaction_ShowPage (create), ACT_ExcelFileImport_ImportToNP (retrieve, commit) | ImportTransaction_Overview |
