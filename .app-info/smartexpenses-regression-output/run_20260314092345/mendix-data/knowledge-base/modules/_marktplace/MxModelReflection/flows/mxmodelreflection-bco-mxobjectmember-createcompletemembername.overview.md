---
objectType: flow
module: MxModelReflection
qualifiedName: MxModelReflection.BCo_MxObjectMember_CreateCompleteMemberName
stableId: aa91774a-b3d9-4077-bd9f-634e695b0859
slug: mxmodelreflection-bco-mxobjectmember-createcompletemembername
layer: L1
l0: mxmodelreflection-bco-mxobjectmember-createcompletemembername.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/MxModelReflection/flows/mxmodelreflection-bco-mxobjectmember-createcompletemembername.json
l2Logical: flow:MxModelReflection.BCo_MxObjectMember_CreateCompleteMemberName
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: MxModelReflection.BCo_MxObjectMember_CreateCompleteMemberName

## Summary

- Likely acts as a save, process, or background step because it mutates data without showing a page.
- L0: [abstract](mxmodelreflection-bco-mxobjectmember-createcompletemembername.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/MxModelReflection/flows/mxmodelreflection-bco-mxobjectmember-createcompletemembername.json)

## Main Steps

- retrieve MxObjectType over association MxObjectMember_MxObjectType from MxObjectMember
- $MxObjectType != empty expression=$MxObjectType != empty
- ChangeObjectAction: change MxObjectMember (CompleteName=$MxObjectType/CompleteName + ' / ' + $MxObjectMember/AttributeName; refreshInClient=false) change MxObjectMember (CompleteName=$MxObjectType/CompleteName + ' / ' + $MxObjectMember/AttributeName; refreshInClient=false)
- ChangeObjectAction: change MxObjectMember (CompleteName=' / ' + $MxObjectMember/AttributeName; refreshInClient=false) change MxObjectMember (CompleteName=' / ' + $MxObjectMember/AttributeName; refreshInClient=false)

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

- nodeId=99454515-d73f-4898-a22f-0e735027c234; sourceKind=Association; association=MxObjectMember_MxObjectType; summary=retrieve MxObjectType over association MxObjectMember_MxObjectType from MxObjectMember
- nodeId=c7a86e99-43a5-43db-936d-8b83f3a53966; caption=none; expression=$MxObjectType != empty expression=$MxObjectType != empty
- nodeId=0a008828-5694-49f7-9999-9ea9d727f0c8; actionKind=Change; members=CompleteName=$MxObjectType/CompleteName + ' / ' + $MxObjectMember/AttributeName; refreshInClient=false; summary=ChangeObjectAction: change MxObjectMember (CompleteName=$MxObjectType/CompleteName + ' / ' + $MxObjectMember/AttributeName; refreshInClient=false) change MxObjectMember (CompleteName=$MxObjectType/CompleteName + ' / ' + $MxObjectMember/AttributeName; refreshInClient=false)
- nodeId=112b39c4-0d2c-4a8e-a716-2b69080eee42; actionKind=Change; members=CompleteName=' / ' + $MxObjectMember/AttributeName; refreshInClient=false; summary=ChangeObjectAction: change MxObjectMember (CompleteName=' / ' + $MxObjectMember/AttributeName; refreshInClient=false) change MxObjectMember (CompleteName=' / ' + $MxObjectMember/AttributeName; refreshInClient=false)

## Warnings/Unknowns

- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/MxModelReflection/flows/mxmodelreflection-bco-mxobjectmember-createcompletemembername.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/MxModelReflection/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/MxModelReflection/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
