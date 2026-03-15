---
objectType: flow
module: MxModelReflection
qualifiedName: MxModelReflection.OC_FindObjectType
stableId: 32ee0560-63fe-4c28-b9d3-a5a6869981d2
slug: mxmodelreflection-oc-findobjecttype
layer: L1
l0: mxmodelreflection-oc-findobjecttype.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/MxModelReflection/flows/mxmodelreflection-oc-findobjecttype.json
l2Logical: flow:MxModelReflection.OC_FindObjectType
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: MxModelReflection.OC_FindObjectType

## Summary

- Likely acts as a save, process, or background step because it mutates data without showing a page.
- L0: [abstract](mxmodelreflection-oc-findobjecttype.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/MxModelReflection/flows/mxmodelreflection-oc-findobjecttype.json)

## Main Steps

- ChangeObjectAction: change DbSizeEstimate (DbSizeEstimate_MxObjectType=$MxObjectType, FindObjectType=if $MxObjectType != empty then $MxObjectType/CompleteName else $DbSizeEstimate/FindObjectType; refreshInClient=true) change DbSizeEstimate (DbSizeEstimate_MxObjectType=$MxObjectType, FindObjectType=if $MxObjectType != empty then $MxObjectType/CompleteName else $DbSizeEstimate/FindObjectType; refreshInClient=true)

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; the entry point may be navigation, background execution, or an export gap.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- No entity names were resolved from exported nodes; inspect L2 JSON if exact read/write scope matters.

## Called / Called By

- Calls: MxModelReflection.FindObjectType
- Called by: none

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=04e8e2ac-2db8-48fc-af80-3b1c0d676bcc; actionKind=Change; members=DbSizeEstimate_MxObjectType=$MxObjectType, FindObjectType=if $MxObjectType != empty then $MxObjectType/CompleteName else $DbSizeEstimate/FindObjectType; refreshInClient=true; summary=ChangeObjectAction: change DbSizeEstimate (DbSizeEstimate_MxObjectType=$MxObjectType, FindObjectType=if $MxObjectType != empty then $MxObjectType/CompleteName else $DbSizeEstimate/FindObjectType; refreshInClient=true) change DbSizeEstimate (DbSizeEstimate_MxObjectType=$MxObjectType, FindObjectType=if $MxObjectType != empty then $MxObjectType/CompleteName else $DbSizeEstimate/FindObjectType; refreshInClient=true)

## Warnings/Unknowns

- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/MxModelReflection/flows/mxmodelreflection-oc-findobjecttype.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/MxModelReflection/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/MxModelReflection/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
