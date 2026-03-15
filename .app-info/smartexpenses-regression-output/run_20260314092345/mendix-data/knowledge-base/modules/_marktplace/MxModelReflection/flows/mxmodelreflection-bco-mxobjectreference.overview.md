---
objectType: flow
module: MxModelReflection
qualifiedName: MxModelReflection.BCo_MxObjectReference
stableId: f9e73d76-ebee-4630-9d21-4d22217bbf3e
slug: mxmodelreflection-bco-mxobjectreference
layer: L1
l0: mxmodelreflection-bco-mxobjectreference.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/MxModelReflection/flows/mxmodelreflection-bco-mxobjectreference.json
l2Logical: flow:MxModelReflection.BCo_MxObjectReference
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: MxModelReflection.BCo_MxObjectReference

## Summary

- Likely acts as a save, process, or background step because it mutates data without showing a page.
- L0: [abstract](mxmodelreflection-bco-mxobjectreference.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/MxModelReflection/flows/mxmodelreflection-bco-mxobjectreference.json)

## Main Steps

- $MxObjectReference/ReadableName != empty and $MxObjectReference/ReadableName != '' has readable name? expression=$MxObjectReference/ReadableName != empty and $MxObjectReference/ReadableName != ''
- ChangeObjectAction: change MxObjectReference (ReadableName=$MxObjectReference/CompleteName; refreshInClient=false) change MxObjectReference (ReadableName=$MxObjectReference/CompleteName; refreshInClient=false)

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

- nodeId=107e7576-0c0d-4d36-bd19-9d7335037687; caption=has readable name?; expression=$MxObjectReference/ReadableName != empty and $MxObjectReference/ReadableName != '' has readable name? expression=$MxObjectReference/ReadableName != empty and $MxObjectReference/ReadableName != ''
- nodeId=fd98612b-b6e2-4f11-9a0c-30f520f79b0d; actionKind=Change; members=ReadableName=$MxObjectReference/CompleteName; refreshInClient=false; summary=ChangeObjectAction: change MxObjectReference (ReadableName=$MxObjectReference/CompleteName; refreshInClient=false) change MxObjectReference (ReadableName=$MxObjectReference/CompleteName; refreshInClient=false)

## Warnings/Unknowns

- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/MxModelReflection/flows/mxmodelreflection-bco-mxobjectreference.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/MxModelReflection/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/MxModelReflection/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
