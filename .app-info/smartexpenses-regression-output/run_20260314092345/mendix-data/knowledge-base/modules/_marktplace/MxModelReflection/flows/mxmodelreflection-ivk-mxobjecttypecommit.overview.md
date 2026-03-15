---
objectType: flow
module: MxModelReflection
qualifiedName: MxModelReflection.IVK_MxObjectTypeCommit
stableId: e3df40c1-8d18-401f-a4db-5c55d4cb5554
slug: mxmodelreflection-ivk-mxobjecttypecommit
layer: L1
l0: mxmodelreflection-ivk-mxobjecttypecommit.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/MxModelReflection/flows/mxmodelreflection-ivk-mxobjecttypecommit.json
l2Logical: flow:MxModelReflection.IVK_MxObjectTypeCommit
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: MxModelReflection.IVK_MxObjectTypeCommit

## Summary

- Likely acts as a save, process, or background step because it mutates data without showing a page.
- L0: [abstract](mxmodelreflection-ivk-mxobjecttypecommit.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/MxModelReflection/flows/mxmodelreflection-ivk-mxobjecttypecommit.json)

## Main Steps

- CommitAction: commit MxObjectType (refreshInClient=false, withEvents=true) commit MxObjectType (refreshInClient=false, withEvents=true)

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

- nodeId=81cadc9e-d0b5-448c-a606-77ae03cbdcf1; actionKind=Commit; members=refreshInClient=false, withEvents=true; summary=CommitAction: commit MxObjectType (refreshInClient=false, withEvents=true) commit MxObjectType (refreshInClient=false, withEvents=true)

## Warnings/Unknowns

- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/MxModelReflection/flows/mxmodelreflection-ivk-mxobjecttypecommit.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/MxModelReflection/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/MxModelReflection/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
