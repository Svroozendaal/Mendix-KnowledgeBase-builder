---
objectType: flow
module: ExcelImporter
qualifiedName: ExcelImporter.MxObjectReferenceAssociationOwnerToString
stableId: 4475025f-98e2-475d-98cd-0c24d7e7c2e8
slug: excelimporter-mxobjectreferenceassociationownertostring
layer: L1
l0: excelimporter-mxobjectreferenceassociationownertostring.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-mxobjectreferenceassociationownertostring.json
l2Logical: flow:ExcelImporter.MxObjectReferenceAssociationOwnerToString
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: ExcelImporter.MxObjectReferenceAssociationOwnerToString

## Summary

- Likely acts as a save, process, or background step because it mutates data without showing a page.
- L0: [abstract](excelimporter-mxobjectreferenceassociationownertostring.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-mxobjectreferenceassociationownertostring.json)

## Main Steps

- CreateVariableAction: create variable AssociationOwnerString=getKey($AssociationOwnerEnum) create variable AssociationOwnerString=getKey($AssociationOwnerEnum)

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; the entry point may be navigation, background execution, or an export gap.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- No entity names were resolved from exported nodes; inspect L2 JSON if exact read/write scope matters.

## Called / Called By

- Calls: none
- Called by: none

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=d8a7fbab-bc24-420e-b9d4-6f98caa73cdd; actionKind=Create; members=$AssociationOwnerEnum; summary=CreateVariableAction: create variable AssociationOwnerString=getKey($AssociationOwnerEnum) create variable AssociationOwnerString=getKey($AssociationOwnerEnum)

## Warnings/Unknowns

- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-mxobjectreferenceassociationownertostring.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
