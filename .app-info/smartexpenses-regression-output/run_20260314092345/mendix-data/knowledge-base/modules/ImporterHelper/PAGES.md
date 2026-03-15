# Pages: ImporterHelper

## Page Inventory

| Page | Title | Allowed roles | Parameters | Popup |
|---|---|---|---|---|
| ImporterHelper.ExcelFileImport_Upload | Excel file import Upload | none | ExcelFileImport:ImporterHelper.ExcelFileImport | True |
| ImporterHelper.ImportTransaction_Edit | Pas transactie aan | ImporterHelper.ExcelImporter | Transaction:ImporterHelper.ImportTransaction | True |
| ImporterHelper.ImportTransaction_Overview | Page | ImporterHelper.ExcelImporter | FBGProfile:SmartExpenses.FBGProfile, ImportTransactionHelper:ImporterHelper.ImportTransactionHelper | False |

## Page-Flow Links

| Page | Shown by flows |
|---|---|
| ImporterHelper.ExcelFileImport_Upload | ImporterHelper.ACT_ExcelFileImport_Create |
| ImporterHelper.ImportTransaction_Edit | none |
| ImporterHelper.ImportTransaction_Overview | ImporterHelper.ACT_ImportTransaction_ShowPage |

## Journey Groups

| User intent group | Pages |
|---|---|
| ExcelFileImport | ImporterHelper.ExcelFileImport_Upload |
| ImportTransaction | ImporterHelper.ImportTransaction_Edit, ImporterHelper.ImportTransaction_Overview |

## Page Links

| Page | Entry provenance | L0 | L1 | L2 |
|---|---|---|---|---|
| ImporterHelper.ExcelFileImport_Upload | ShowPageAction | [L0](pages/importerhelper-excelfileimport-upload.abstract.md) | [L1](pages/importerhelper-excelfileimport-upload.overview.md) | [L2](../../../app-overview/current/modules/ImporterHelper/pages/importerhelper-excelfileimport-upload.json) |
| ImporterHelper.ImportTransaction_Edit | Unknown (navigation metadata not exported) | [L0](pages/importerhelper-importtransaction-edit.abstract.md) | [L1](pages/importerhelper-importtransaction-edit.overview.md) | [L2](../../../app-overview/current/modules/ImporterHelper/pages/importerhelper-importtransaction-edit.json) |
| ImporterHelper.ImportTransaction_Overview | ShowPageAction | [L0](pages/importerhelper-importtransaction-overview.abstract.md) | [L1](pages/importerhelper-importtransaction-overview.overview.md) | [L2](../../../app-overview/current/modules/ImporterHelper/pages/importerhelper-importtransaction-overview.json) |
