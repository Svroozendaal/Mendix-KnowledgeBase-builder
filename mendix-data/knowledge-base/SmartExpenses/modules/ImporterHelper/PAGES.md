# Pages: ImporterHelper

Pages: 3, Snippets: 0

## Page Inventory

| Page | Title | Layout | Type | Roles | Parameters |
|------|-------|--------|------|-------|------------|
| ExcelFileImport_Upload | Excel file import Upload | PopupLayout | Popup | — | ExcelFileImport |
| ImportTransaction_Edit | Pas transactie aan | PopupLayout | Popup | ExcelImporter | ImportTransaction |
| ImportTransaction_Overview | Page | Atlas_TopBar | Full | ExcelImporter | ImportTransactionHelper, SmartExpenses.FBGProfile |

## Page-Flow Links

| Page | Shown by Flows |
|------|----------------|
| ExcelFileImport_Upload | ACT_ExcelFileImport_Create |
| ImportTransaction_Overview | ACT_ImportTransaction_ShowPage |
| ImportTransaction_Edit | (likely opened from overview page UI, not from a flow) |

## Page Details

### ExcelFileImport_Upload
Popup for uploading an Excel file. No explicit role restriction (likely inherited from parent context). Takes an ExcelFileImport parameter for file binding.

### ImportTransaction_Overview
Main overview page showing staged import transactions. Restricted to ExcelImporter role. Takes both ImportTransactionHelper (for the staging context) and SmartExpenses.FBGProfile (for linking accepted transactions to the user profile).

### ImportTransaction_Edit
Popup for editing a single staged import transaction before acceptance. Dutch title "Pas transactie aan" (Edit transaction). Restricted to ExcelImporter role.

## Snippets
None.
