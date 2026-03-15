---
objectType: flow
module: MxModelReflection
qualifiedName: MxModelReflection.BCo_MxObjectType
stableId: a036d810-b71e-42b9-bf6b-a897c5829c7f
slug: mxmodelreflection-bco-mxobjecttype
layer: L1
l0: mxmodelreflection-bco-mxobjecttype.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/MxModelReflection/flows/mxmodelreflection-bco-mxobjecttype.json
l2Logical: flow:MxModelReflection.BCo_MxObjectType
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: MxModelReflection.BCo_MxObjectType

## Summary

- Likely acts as a save, process, or background step because it mutates data without showing a page.
- L0: [abstract](mxmodelreflection-bco-mxobjecttype.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/MxModelReflection/flows/mxmodelreflection-bco-mxobjecttype.json)

## Main Steps

- $MxObjectType/ReadableName != empty and $MxObjectType/ReadableName != '' has readable name? expression=$MxObjectType/ReadableName != empty and $MxObjectType/ReadableName != ''
- ChangeObjectAction: change MxObjectType (ReadableName=$MxObjectType/Name + ' from the ' + $MxObjectType/Module + ' module'; refreshInClient=false) change MxObjectType (ReadableName=$MxObjectType/Name + ' from the ' + $MxObjectType/Module + ' module'; refreshInClient=false)

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

- nodeId=256c0ce3-31c0-4c61-903d-ea026fea82e7; caption=has readable name?; expression=$MxObjectType/ReadableName != empty and $MxObjectType/ReadableName != '' has readable name? expression=$MxObjectType/ReadableName != empty and $MxObjectType/ReadableName != ''
- nodeId=d6167770-57c3-496b-b0de-08d4ac143e20; actionKind=Change; members=ReadableName=$MxObjectType/Name + ' from the ' + $MxObjectType/Module + ' module'; refreshInClient=false; summary=ChangeObjectAction: change MxObjectType (ReadableName=$MxObjectType/Name + ' from the ' + $MxObjectType/Module + ' module'; refreshInClient=false) change MxObjectType (ReadableName=$MxObjectType/Name + ' from the ' + $MxObjectType/Module + ' module'; refreshInClient=false)

## Warnings/Unknowns

- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/MxModelReflection/flows/mxmodelreflection-bco-mxobjecttype.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/MxModelReflection/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/MxModelReflection/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
