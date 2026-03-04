# Flow Call Graph

## Cross-Module Dependencies

| Source Module | Target Module | Call Count | Key Flows |
|--------------|---------------|------------|-----------|
| ImporterHelper | SmartExpenses | 1 | ACT_ImportTransaction_AcceptTransactions -> SUB_Transaction_setStatus |

ImporterHelper is the only module that calls into SmartExpenses. All other calls within the selected modules are internal to SmartExpenses.

## SmartExpenses Internal Call Map

### Most Called (Fan-In)
| Flow | Called By | Count |
|------|----------|-------|
| SUB_Balance_Recalculate | ACT_Transaction_BulkEditSave, ACT_Transaction_Recalculate_all, SUB_Transaction_CalculateBalance | 3 |
| SUB_BudgetTerm_Recalculate | ACT_Transaction_BulkEditSave, ACT_Transaction_Recalculate_all, SUB_Transaction_CalculateBudgetTerm | 3 |
| SUB_Transaction_setStatus | ACT_Transaction_BulkEditSave, ACT_Transaction_NewEdit_Save, ImporterHelper.ACT_ImportTransaction_AcceptTransactions | 3 |
| DS_BudgetTerm_New | ACR_FBGProfile_setStandardBudgets, ACT_BudgetTerm_New | 2 |
| SUB_Transaction_CalculateBalance | BCO_Transaction, BD_Transaction | 2 |
| SUB_Transaction_CalculateBudgetTerm | BCO_Transaction, BD_Transaction | 2 |

### Most Calling (Fan-Out)
| Flow | Calls | Count |
|------|-------|-------|
| ACT_Transaction_BulkEditSave | SUB_Transaction_setStatus, SUB_Balance_Recalculate, SUB_BudgetTerm_Recalculate | 3 |
| ACT_Transaction_Recalculate_all | SUB_BudgetTerm_Recalculate, SUB_Balance_Recalculate, DS_TotalBalance_Calculate | 3 |
| BCO_Transaction | SUB_Transaction_CalculateBalance, SUB_Transaction_CalculateBudgetTerm | 2 |
| BD_Transaction | SUB_Transaction_CalculateBalance, SUB_Transaction_CalculateBudgetTerm | 2 |

## ImporterHelper Internal Call Map

| Flow | Calls | Direction |
|------|-------|-----------|
| ACT_ExcelFileImport_ImportToNP | SUB_ImportTemplateDocument | internal |
| ACT_ImportTransaction_Refreshpage | ACT_ImportTransaction_AcceptTransactions | internal |
| ACT_ImportTransaction_AcceptTransactions | SmartExpenses.SUB_Transaction_setStatus | cross-module |

## Module Clusters
- **SmartExpenses**: 19 internal call edges, 0 outbound (self-contained core)
- **ImporterHelper**: 2 internal call edges, 1 outbound to SmartExpenses (import bridge)
