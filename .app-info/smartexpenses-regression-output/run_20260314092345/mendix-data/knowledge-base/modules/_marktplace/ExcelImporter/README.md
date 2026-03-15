# Module: ExcelImporter

Category: Marketplace
Module roles: Configurator, Readonly

## Summary

- Entities: 7
- Flows: 81
- Pages: 13
- Constants: 2

## Purpose

- Export-backed: module category and inventory from overview export.
- Inferred: module role is support capability.
- Deterministic fallback: This module appears to provide supporting capability for data such as additional properties, column, and log, flows such as documentation dummy xsd, documentation export parse flows, and documentation import parse flows, pages such as column details and new column mapping selection, and supporting configuration and runtime resources based on its exported entities, pages, flows, and resources.

## Capability Map

| Capability prefix | Flow count | Representative flow |
|---|---:|---|
| ACR | 1 | ExcelImporter.ACr_Template |
| ASU | 1 | ExcelImporter.ASu_CheckModelAndTemplates |
| BCO | 1 | ExcelImporter.BCo_Column |
| BDE | 1 | ExcelImporter.BDe_Column |
| CH | 13 | ExcelImporter.Ch_Column_SetDefaultObject |
| COLUMN | 2 | ExcelImporter.Column_SetCorrectRefObjectType |
| EXAMPLE | 1 | ExcelImporter.Example_SetupImportTemplate |
| EXCELTEMPLATE | 2 | ExcelImporter.ExcelTemplate_ExportToXML |
| IVK | 14 | ExcelImporter.IVK_CancelTemplate |
| OTHER | 40 | ExcelImporter._DocumentationDummyXSD |
| PARSEENUMTOSTRING | 1 | ExcelImporter.ParseEnumToString_StatisticLevel |
| PARSESTRINGTOENUM | 1 | ExcelImporter.ParseStringToEnum_StatisticsLevel |
| SF | 1 | ExcelImporter.SF_Template_CheckNrs |
| SUB | 1 | ExcelImporter.Sub_CreateColumnsFromTemplate |
| VALIDATE | 1 | ExcelImporter.Validate_TemplateDocument |

## Primary User Journeys

| Entry flow | UI result | Entities touched |
|---|---|---|
| ExcelImporter.ValidateTemplate | none | ExcelImporter.Column, ExcelImporter.ReferenceHandling |
| ExcelImporter.IVK_Column_Save | none | none |
| ExcelImporter.BCo_Column | none | ExcelImporter.Column |

## Top risks/unknowns in model understanding
- Some flows have behavioural actions without explicit entity name tokens (parser gap).
- Some pages have no explicit ShowPageAction evidence in exported flows.

## Navigation

- [DOMAIN.md](DOMAIN.md)
- [FLOWS.md](FLOWS.md) - module flow overview
- [flows/INDEX.abstract.md](flows/INDEX.abstract.md) - flow routing file
- [PAGES.md](PAGES.md) - module page overview
- [pages/INDEX.abstract.md](pages/INDEX.abstract.md) - page routing file
- [RESOURCES.md](RESOURCES.md)
- [INTERPRETATION.md](INTERPRETATION.md) - AI narrative layer
- Open collection abstracts first, then object overview files, and use stable JSON only when exact export-backed detail is required.

## Source Pointers

- Domain export: [domain-model.pseudo.txt](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/domain-model.pseudo.txt) and [domain-model.json](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/domain-model.json).
- Flow export: [flows.pseudo.txt](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.pseudo.txt) and [flows.json](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.json).
- Page export: [pages.pseudo.txt](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/pages.pseudo.txt) and [pages.json](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/pages.json).
- Resource export: [resources.pseudo.txt](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/resources.pseudo.txt) and [resources.json](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/resources.json).
- Use `DOMAIN.md` for entity shape, lifecycle, access rules, associations, and XPath summaries.
- Use `FLOWS.md` and `flows/INDEX.abstract.md` for flow routing and compact module-level flow context.
- Use `PAGES.md` and `pages/INDEX.abstract.md` for page routing and compact module-level page context.
- Use `RESOURCES.md` for constants, scheduled events, and supporting module resources.

## Cross-Module Dependencies

- Calls to: MxModelReflection
- Called by: none
- Shared entities via associations: none

## Source

- Export module: ExcelImporter
- Run folder: cli_2026-03-14T09-23-46.259Z
