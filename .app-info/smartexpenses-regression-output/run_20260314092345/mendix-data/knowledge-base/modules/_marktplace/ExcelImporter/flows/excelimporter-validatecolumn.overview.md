---
objectType: flow
module: ExcelImporter
qualifiedName: ExcelImporter.ValidateColumn
stableId: 57411c37-9ac1-4395-997b-527d5fa4da82
slug: excelimporter-validatecolumn
layer: L1
l0: excelimporter-validatecolumn.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-validatecolumn.json
l2Logical: flow:ExcelImporter.ValidateColumn
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: ExcelImporter.ValidateColumn

## Summary

- Deterministic overview derived from exported flow structure.
- L0: [abstract](excelimporter-validatecolumn.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-validatecolumn.json)

## Main Steps

- retrieve MemberList from MxModelReflection.MxObjectMember
- retrieve Members_Ref from MxModelReflection.MxObjectMember
- $NrOfMembers > 0 > 0 expression=$NrOfMembers > 0
- $NrOfMembers_Ref > 0 > 0 expression=$NrOfMembers_Ref > 0

## Trigger/Input/Output Context

- Kind: Rule
- Entry/call context: No inbound caller was exported; the entry point may be navigation, background execution, or an export gap.
- Output/UI context: No page output was exported; check L2 JSON if the exact user-facing effect matters.

## Key Entities Touched

- MxModelReflection.MxObjectMember, MxModelReflection.MxObjectReference, MxModelReflection.MxObjectType

## Called / Called By

- Calls: none
- Called by: none

## Shown Pages

- No ShowPageAction was exported for this flow; it may serve validation, background processing, or delegate work to other flows.

## Important Retrieves/Decisions/Mutations

- nodeId=7abfc31f-5177-4331-9ab5-ab34556790e1; sourceKind=Database; entity=MxModelReflection.MxObjectMember; summary=retrieve MemberList from MxModelReflection.MxObjectMember
- nodeId=fee78763-8829-4cf9-a35f-25e2f75100e7; sourceKind=Database; entity=MxModelReflection.MxObjectMember; summary=retrieve Members_Ref from MxModelReflection.MxObjectMember
- nodeId=7248b8fb-0137-415b-b0b0-4b9e7bebc97c; sourceKind=Association; association=Column_MxObjectMember; summary=retrieve MxObjectMember over association Column_MxObjectMember from Column
- nodeId=e722bdd1-d4c8-418f-88de-96adc72e675c; sourceKind=Association; association=Column_MxObjectMember_Reference; summary=retrieve MxObjectMember_Ref over association Column_MxObjectMember_Reference from Column
- nodeId=512262c5-7ed0-4b76-b82e-8a66db83c2c2; sourceKind=Association; association=Column_MxObjectType; summary=retrieve ObjectType over association Column_MxObjectType from Column
- nodeId=6e3b1f1f-4d86-4974-8cc1-8c3f0edf6c2a; sourceKind=Database; entity=MxModelReflection.MxObjectType; summary=retrieve ObjectType_Ref from MxModelReflection.MxObjectType
- nodeId=4c32b9fc-8e26-4554-a978-1b9e5877667f; sourceKind=Database; entity=MxModelReflection.MxObjectReference; summary=retrieve Reference from MxModelReflection.MxObjectReference
- nodeId=8e0b04e7-e956-42c6-b48f-433bf78017df; caption=> 0; expression=$NrOfMembers > 0 > 0 expression=$NrOfMembers > 0

## Warnings/Unknowns

- Rollback hint detected in node detail.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-validatecolumn.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
