---
objectType: flow
module: MxModelReflection
qualifiedName: MxModelReflection.Ch_ObjectTypeStart
stableId: e19a780f-0f75-4023-934e-5c593f2b1376
slug: mxmodelreflection-ch-objecttypestart
layer: L1
l0: mxmodelreflection-ch-objecttypestart.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/MxModelReflection/flows/mxmodelreflection-ch-objecttypestart.json
l2Logical: flow:MxModelReflection.Ch_ObjectTypeStart
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: MxModelReflection.Ch_ObjectTypeStart

## Summary

- Likely acts as a save, process, or background step because it mutates data without showing a page.
- L0: [abstract](mxmodelreflection-ch-objecttypestart.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/MxModelReflection/flows/mxmodelreflection-ch-objecttypestart.json)

## Main Steps

- retrieve MxObjectType over association Token_MxObjectType_Start from Token
- ChangeObjectAction: change Token (FindObjectStart=$MxObjectType/CompleteName; refreshInClient=true) change Token (FindObjectStart=$MxObjectType/CompleteName; refreshInClient=true)

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

- nodeId=764c7051-e4e9-473e-a063-f2f41c3787ad; sourceKind=Association; association=Token_MxObjectType_Start; summary=retrieve MxObjectType over association Token_MxObjectType_Start from Token
- nodeId=478eaf04-e2ba-4989-ace2-e680c7aa9826; actionKind=Change; members=FindObjectStart=$MxObjectType/CompleteName; refreshInClient=true; summary=ChangeObjectAction: change Token (FindObjectStart=$MxObjectType/CompleteName; refreshInClient=true) change Token (FindObjectStart=$MxObjectType/CompleteName; refreshInClient=true)

## Warnings/Unknowns

- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/MxModelReflection/flows/mxmodelreflection-ch-objecttypestart.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/MxModelReflection/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/MxModelReflection/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
