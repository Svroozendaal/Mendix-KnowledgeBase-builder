---
objectType: flow
module: ExcelImporter
qualifiedName: ExcelImporter.ValidateColumnMF
stableId: 1f50a9c9-3c78-462c-ba9a-031f83061490
slug: excelimporter-validatecolumnmf
layer: L1
l0: excelimporter-validatecolumnmf.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-validatecolumnmf.json
l2Logical: flow:ExcelImporter.ValidateColumnMF
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: ExcelImporter.ValidateColumnMF

## Summary

- Deterministic overview derived from exported flow structure.
- L0: [abstract](excelimporter-validatecolumnmf.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-validatecolumnmf.json)

## Main Steps

- retrieve ValueType_Member over association MxObjectMember_Type from vMember
- retrieve ValueType_Output over association Microflows_Output_Type from vMicroflow
- $Count = 1 = 1 expression=$Count = 1
- $vMember != empty has member? expression=$vMember != empty

## Trigger/Input/Output Context

- Kind: Rule
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

- nodeId=6fbe34ae-9b84-4a66-a795-29afe069e230; sourceKind=Association; association=MxObjectMember_Type; summary=retrieve ValueType_Member over association MxObjectMember_Type from vMember
- nodeId=bfb4fb25-eb66-4fa2-a813-4b0c64421c18; sourceKind=Association; association=Microflows_Output_Type; summary=retrieve ValueType_Output over association Microflows_Output_Type from vMicroflow
- nodeId=f215fb96-1091-4491-82a6-cf6e4f73b0a1; sourceKind=Association; association=MxObjectMember_Type; summary=retrieve ValueType_Ref over association MxObjectMember_Type from vMemberReference
- nodeId=d0b8da23-3124-4a9f-9037-0791704e543b; sourceKind=Association; association=Microflows_InputParameter; summary=retrieve vInputParams over association Microflows_InputParameter from vMicroflow
- nodeId=cb45916c-465f-4096-98b8-22a7ba3ae94d; sourceKind=Association; association=Column_MxObjectMember; summary=retrieve vMember over association Column_MxObjectMember from Column
- nodeId=3f6c9faa-4a99-4904-a110-96dede5857dd; sourceKind=Association; association=Column_MxObjectMember_Reference; summary=retrieve vMemberReference over association Column_MxObjectMember_Reference from Column
- nodeId=c14df837-0dd6-4cf5-983b-55d5b36aa0b8; sourceKind=Association; association=Column_Microflows; summary=retrieve vMicroflow over association Column_Microflows from Column
- nodeId=ea99ff91-8a06-472b-91cb-9b1c6d9e13f7; caption== 1; expression=$Count = 1 = 1 expression=$Count = 1

## Warnings/Unknowns

- Rollback hint detected in node detail.
- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-validatecolumnmf.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/ExcelImporter/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
