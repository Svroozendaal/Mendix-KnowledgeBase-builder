---
objectType: flow
module: MxModelReflection
qualifiedName: MxModelReflection.IVK_RecalculateSize
stableId: 93561c40-381c-411f-aeed-a0f1b36805df
slug: mxmodelreflection-ivk-recalculatesize
layer: L1
l0: mxmodelreflection-ivk-recalculatesize.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/MxModelReflection/flows/mxmodelreflection-ivk-recalculatesize.json
l2Logical: flow:MxModelReflection.IVK_RecalculateSize
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: MxModelReflection.IVK_RecalculateSize

## Summary

- Likely acts as a save, process, or background step for MxModelReflection.DbSizeEstimate, MxModelReflection.MxObjectMember because it mutates data without showing a page.
- L0: [abstract](mxmodelreflection-ivk-recalculatesize.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/MxModelReflection/flows/mxmodelreflection-ivk-recalculatesize.json)

## Main Steps

- retrieve DbSizeEstimateList from MxModelReflection.DbSizeEstimate
- retrieve MxObjectMemberList from MxModelReflection.MxObjectMember
- $ValueType/TypeEnum expression=$ValueType/TypeEnum
- contains( toLowerCase($Member/CompleteName), 'owner') or contains( toLowerCase($Member/CompleteName), 'changedby') has owner or changed by expression=contains( toLowerCase($Member/CompleteName), 'owner') or contains( toLowerCase($Member/CompleteName), 'changedby')
- ChangeObjectAction: change Estimate (CalculatedSizeInBytes=$Size, CalculatedSizeInKiloBytes=ceil($Size : 1024); refreshInClient=false) change Estimate (CalculatedSizeInBytes=$Size, CalculatedSizeInKiloBytes=ceil($Size : 1024); refreshInClient=false)
- ChangeVariableAction: change variable Size=$Size + 1 change variable Size=$Size + 1

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; the entry point may be navigation, background execution, or an export gap.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- MxModelReflection.DbSizeEstimate, MxModelReflection.MxObjectMember

## Called / Called By

- Calls: MxModelReflection.Log
- Called by: none

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=ec73be45-cbe5-42c6-a2bd-77ecd22eb7fa; sourceKind=Database; entity=MxModelReflection.DbSizeEstimate; summary=retrieve DbSizeEstimateList from MxModelReflection.DbSizeEstimate
- nodeId=6f7bef62-c5bb-4066-a3fc-5ff166a55fca; sourceKind=Database; entity=MxModelReflection.MxObjectMember; summary=retrieve MxObjectMemberList from MxModelReflection.MxObjectMember
- nodeId=d0a03242-ae94-4042-9055-9c1546e61dab; sourceKind=Association; association=MxObjectMember_Type; summary=retrieve ValueType over association MxObjectMember_Type from Member
- nodeId=09e3833a-5a27-42d1-a740-c355acf0f0a9; caption=none; expression=$ValueType/TypeEnum expression=$ValueType/TypeEnum
- nodeId=e8580680-867b-4c88-a589-19322010f40e; caption=has owner or changed by; expression=contains( toLowerCase($Member/CompleteName), 'owner') or contains( toLowerCase($Member/CompleteName), 'changedby') has owner or changed by expression=contains( toLowerCase($Member/CompleteName), 'owner') or contains( toLowerCase($Member/CompleteName), 'changedby')
- nodeId=c4dfedf9-7dbb-44ae-84c6-7ffeeb8747cf; actionKind=Change; members=CalculatedSizeInBytes=$Size, CalculatedSizeInKiloBytes=ceil($Size : 1024; summary=ChangeObjectAction: change Estimate (CalculatedSizeInBytes=$Size, CalculatedSizeInKiloBytes=ceil($Size : 1024); refreshInClient=false) change Estimate (CalculatedSizeInBytes=$Size, CalculatedSizeInKiloBytes=ceil($Size : 1024); refreshInClient=false)
- nodeId=22eb11c8-61b5-4dc0-a6fa-308cc9942fd6; actionKind=Change; summary=ChangeVariableAction: change variable Size=$Size + 1 change variable Size=$Size + 1
- nodeId=7e9af927-ae9d-4ed3-8744-279e31afda5f; actionKind=Change; members=ceil(if $Member/FieldLength != empty then $Member/FieldLength * 0.8 else 200; summary=ChangeVariableAction: change variable Size=$Size + 2+( ceil(if $Member/FieldLength != empty then $Member/FieldLength * 0.8 else 200) *2) change variable Size=$Size + 2+( ceil(if $Member/FieldLength != empty then $Member/FieldLength * 0.8 else 200) *2)

## Warnings/Unknowns

- Rollback hint detected in node detail.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/MxModelReflection/flows/mxmodelreflection-ivk-recalculatesize.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/MxModelReflection/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/MxModelReflection/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
