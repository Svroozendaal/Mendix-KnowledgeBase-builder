---
objectType: flow
module: ExcelImporter
qualifiedName: ExcelImporter.IVK_ImportTemplateDocument
stableId: d568e924-31ca-476e-ade2-ed260efc830b
slug: excelimporter-ivk-importtemplatedocument
layer: L1
l0: excelimporter-ivk-importtemplatedocument.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-ivk-importtemplatedocument.json
l2Logical: flow:ExcelImporter.IVK_ImportTemplateDocument
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: ExcelImporter.IVK_ImportTemplateDocument

## Summary

- Deterministic overview derived from exported flow structure.
- L0: [abstract](excelimporter-ivk-importtemplatedocument.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-ivk-importtemplatedocument.json)

## Main Steps

- retrieve Template over association TemplateDocument_Template from TemplateDocument
- Example how you can implement your own excel import file Retrieve a template, this can be from an association or by the use of a constant or some application se...
- $Template != empty has a template selected expression=$Template != empty

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; the entry point may be navigation, background execution, or an export gap.
- Output/UI context: No page output was exported; check L2 JSON if the exact user-facing effect matters.

## Key Entities Touched

- No entity names were resolved from exported nodes; inspect L2 JSON if exact read/write scope matters.

## Called / Called By

- Calls: none
- Called by: none

## Shown Pages

- No ShowPageAction was exported for this flow; it may serve validation, background processing, or delegate work to other flows.

## Important Retrieves/Decisions/Mutations

- nodeId=cc3e4c34-c67b-4965-86e5-1a7493bf521d; sourceKind=Association; association=TemplateDocument_Template; summary=retrieve Template over association TemplateDocument_Template from TemplateDocument
- nodeId=79bf6fd0-ea5f-4a4f-ae2a-6a492dd3b59a; sourceKind=Database; summary=Example how you can implement your own excel import file Retrieve a template, this can be from an association or by the use of a constant or some application se...
- nodeId=1cc4977d-e72c-45cd-8cdd-2f620727c503; caption=has a template selected; expression=$Template != empty has a template selected expression=$Template != empty

## Warnings/Unknowns

- Rollback hint detected in node detail.
- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-ivk-importtemplatedocument.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
