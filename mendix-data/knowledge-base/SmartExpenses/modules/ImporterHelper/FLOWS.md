# Flows: ImporterHelper

Total: 7 (Microflows: 6, Nanoflows: 1)

## Flow Catalogue

### Action Flows (ACT_*)

| Flow | Nodes | Key Actions | Pages Shown |
|------|-------|-------------|-------------|
| ACT_ExcelFileImport_Create | 7 | Create ExcelFileImport, link to helper, show upload page | ExcelFileImport_Upload |
| ACT_ExcelFileImport_ImportToNP | 13 | Retrieve helper, call SUB_ImportTemplateDocument, commit on success | — |
| ACT_ImportTransaction_AcceptTransactions | 11 | Loop staged imports, create SmartExpenses.Transaction per row, delete staging objects | — |
| ACT_ImportTransaction_ShowPage | 5 | Create ImportTransactionHelper, show overview | ImportTransaction_Overview |

### Sub-Microflows (SUB_*)

| Flow | Nodes | Key Actions |
|------|-------|-------------|
| SUB_ImportTemplateDocument | 14 | Retrieve ExcelImporter template, call StartImportByTemplate, show result message |

### Consumed Web Service Flows (CWS_*)

| Flow | Nodes | Key Actions |
|------|-------|-------------|
| CWS_GetProducts | 10 | REST call to external endpoint, count imported transactions, show result |

### Nanoflows

| Flow | Nodes | Key Actions |
|------|-------|-------------|
| ACT_ImportTransaction_Refreshpage | 7 | Show toast notification, call ACT_ImportTransaction_AcceptTransactions |

## Cross-Module Calls

| Flow | Calls | Target Module |
|------|-------|---------------|
| ACT_ImportTransaction_AcceptTransactions | SUB_Transaction_setStatus | SmartExpenses |

| Flow | Calls | Direction |
|------|-------|-----------|
| ACT_ExcelFileImport_ImportToNP | SUB_ImportTemplateDocument | internal |
| ACT_ImportTransaction_Refreshpage | ACT_ImportTransaction_AcceptTransactions | internal |

## Key Flow Details

### ACT_ImportTransaction_AcceptTransactions
The core acceptance flow: iterates over all staged ImportTransaction objects, creates a real SmartExpenses.Transaction for each (mapping Bedrag to Value, Tegenpartij to Name, etc.), calls SUB_Transaction_setStatus to classify as income/expenditure, deletes the staging object, then commits all new transactions in batch.

### SUB_ImportTemplateDocument
Bridges to the ExcelImporter marketplace module: retrieves the configured import template, calls the Java action `ExcelImporter.StartImportByTemplate` to parse the uploaded file into ImportTransaction objects, handles errors with logging and user messages.

### CWS_GetProducts
Makes a REST call (URL from CONST_RESTTransactionURL constant) to fetch transactions from an external system. On success, counts and displays the number of imported transactions.
