# Domain Model: ImporterHelper

## Entities

### ExcelFileImport
- Persistence: persistent
- Generalisation: System.FileDocument
- Attributes: (inherited from System.FileDocument: FileID, Name, DeleteAfterDownload, Contents, HasContents, Size)
- Access rules:
  | Role(s) | Create | Delete | Default |
  |---------|--------|--------|---------|
  | ExcelImporter | yes | yes | ReadWrite |
- Purpose: uploaded Excel file for import processing

### ImportTransaction
- Persistence: **non-persistent** (staging object)
- Attributes:
  | Name | Type |
  |------|------|
  | Bedrag | Decimal |
  | Datum | DateTime |
  | Number | Integer |
  | Omschrijving | String |
  | Tegenpartij | String |
  | Transactiereferentie | String |
- Access rules:
  | Role(s) | Create | Delete | Default |
  |---------|--------|--------|---------|
  | ExcelImporter, RESTImporter | yes | yes | ReadWrite (Number: ReadOnly) |
- Purpose: temporary staging object for imported transaction data before acceptance into SmartExpenses.Transaction

### ImportTransactionHelper
- Persistence: **non-persistent** (transient helper)
- Access rules:
  | Role(s) | Create | Delete | Default |
  |---------|--------|--------|---------|
  | ExcelImporter, RESTImporter | yes | yes | ReadWrite |
- Purpose: container/helper linking import transactions to their source Excel file

## Associations

| Association | Parent | Child | Cardinality |
|-------------|--------|-------|-------------|
| ImportTransactionHelper_ExcelFileImport | ImportTransactionHelper | ExcelFileImport | *-1 |
| ImportTransaction_ImportTransactionHelper | ImportTransaction | ImportTransactionHelper | *-1 |

## Enumerations
None.
