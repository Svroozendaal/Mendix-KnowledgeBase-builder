---
objectType: flow
module: MxModelReflection
qualifiedName: MxModelReflection.FindMember
stableId: 88e85cff-7413-47ec-9433-ae859be3f40d
slug: mxmodelreflection-findmember
layer: L1
l0: mxmodelreflection-findmember.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/MxModelReflection/flows/mxmodelreflection-findmember.json
l2Logical: flow:MxModelReflection.FindMember
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: MxModelReflection.FindMember

## Summary

- Likely acts as a save, process, or background step for MxModelReflection.MxObjectMember because it mutates data without showing a page.
- L0: [abstract](mxmodelreflection-findmember.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/MxModelReflection/flows/mxmodelreflection-findmember.json)

## Main Steps

- retrieve RetrievedMember from MxModelReflection.MxObjectMember
- retrieve RetrievedMember_1 from MxModelReflection.MxObjectMember
- $RetrievedMember != empty is RetrievedMember? expression=$RetrievedMember != empty
- $MemberSearchString != empty member str != empty expression=$MemberSearchString != empty
- CreateVariableAction: create variable MemberSearch=replaceAll(trim( $MemberSearchString), ' ', '') create variable MemberSearch=replaceAll(trim( $MemberSearchString), ' ', '')

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: Called by ExcelImporter.Ch_FindAttribute, ExcelImporter.Ch_FindAttribute_Reference, ExcelImporter.SetupColumn.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- MxModelReflection.MxObjectMember

## Called / Called By

- Calls: none
- Called by: ExcelImporter.Ch_FindAttribute, ExcelImporter.Ch_FindAttribute_Reference, ExcelImporter.SetupColumn

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=56a5e393-9604-4618-9821-87e64d2c18ae; sourceKind=Database; entity=MxModelReflection.MxObjectMember; summary=retrieve RetrievedMember from MxModelReflection.MxObjectMember
- nodeId=0449efac-588e-424f-b01f-a96d84033c9f; sourceKind=Database; entity=MxModelReflection.MxObjectMember; summary=retrieve RetrievedMember_1 from MxModelReflection.MxObjectMember
- nodeId=5902cef2-1ccb-4b8d-85f0-a49722590261; caption=is RetrievedMember?; expression=$RetrievedMember != empty is RetrievedMember? expression=$RetrievedMember != empty
- nodeId=ffd372f3-9c93-439f-a589-f2680802d3cd; caption=member str != empty; expression=$MemberSearchString != empty member str != empty expression=$MemberSearchString != empty
- nodeId=59e8ae36-f548-43b4-b426-c1bf2ca29413; actionKind=Create; members=trim( $MemberSearchString; summary=CreateVariableAction: create variable MemberSearch=replaceAll(trim( $MemberSearchString), ' ', '') create variable MemberSearch=replaceAll(trim( $MemberSearchString), ' ', '')

## Warnings/Unknowns

- No material warnings from deterministic export synthesis.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/MxModelReflection/flows/mxmodelreflection-findmember.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/MxModelReflection/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/MxModelReflection/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
