# Module: ImporterHelper

Category: Custom
Module roles: ExcelImporter, RESTImporter

## Summary
- Entities: 3, Associations: 2, Enumerations: 0
- Flows: 7 (Microflows: 6, Nanoflows: 1)
- Pages: 3, Snippets: 0
- Constants: 1, Scheduled events: 0

## Purpose
ImporterHelper is a **data import bridge** that enables importing financial transactions into SmartExpenses from two sources:
- **Excel files**: Upload an Excel file, use ExcelImporter templates to parse rows, preview as ImportTransaction objects, then accept to create SmartExpenses.Transaction records.
- **REST API**: Call an external REST endpoint to retrieve transactions (via CWS_GetProducts flow), using a configurable URL constant.

The module acts as a staging area — imported data lands as non-persistent ImportTransaction objects that can be reviewed before being committed as permanent Transaction records in SmartExpenses.

## Navigation
- [DOMAIN.md](DOMAIN.md) — entities, associations, access rules
- [FLOWS.md](FLOWS.md) — microflows, nanoflows, call relationships
- [PAGES.md](PAGES.md) — pages, layouts, role access
- [RESOURCES.md](RESOURCES.md) — constants, scheduled events

## Cross-Module Dependencies
- Calls to: SmartExpenses (SUB_Transaction_setStatus — sets status on newly imported transactions)
- Called by: none
- Shared entities: ImportTransaction_Overview page accepts SmartExpenses.FBGProfile as parameter
- Uses marketplace module: ExcelImporter (StartImportByTemplate java action), Toast (showToast)

## Source
- Export: mendix-data/app-overview/cli-test-v2/modules/ImporterHelper/
