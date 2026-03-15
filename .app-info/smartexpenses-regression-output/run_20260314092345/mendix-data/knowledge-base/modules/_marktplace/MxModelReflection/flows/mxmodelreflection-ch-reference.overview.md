---
objectType: flow
module: MxModelReflection
qualifiedName: MxModelReflection.Ch_Reference
stableId: 90bffadb-7767-4313-b35a-ee92ffa11967
slug: mxmodelreflection-ch-reference
layer: L1
l0: mxmodelreflection-ch-reference.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/MxModelReflection/flows/mxmodelreflection-ch-reference.json
l2Logical: flow:MxModelReflection.Ch_Reference
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: MxModelReflection.Ch_Reference

## Summary

- Likely acts as a save, process, or background step because it mutates data without showing a page.
- L0: [abstract](mxmodelreflection-ch-reference.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/MxModelReflection/flows/mxmodelreflection-ch-reference.json)

## Main Steps

- retrieve MxObjectReference over association Token_MxObjectReference from Token
- ChangeObjectAction: change Token (FindReference=$MxObjectReference/CompleteName; refreshInClient=true) change Token (FindReference=$MxObjectReference/CompleteName; refreshInClient=true)

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

- nodeId=c6e72235-dafa-4b00-a81e-995795c45566; sourceKind=Association; association=Token_MxObjectReference; summary=retrieve MxObjectReference over association Token_MxObjectReference from Token
- nodeId=8a960d05-e30c-4c7c-9075-07570e7bfba8; actionKind=Change; members=FindReference=$MxObjectReference/CompleteName; refreshInClient=true; summary=ChangeObjectAction: change Token (FindReference=$MxObjectReference/CompleteName; refreshInClient=true) change Token (FindReference=$MxObjectReference/CompleteName; refreshInClient=true)

## Warnings/Unknowns

- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/MxModelReflection/flows/mxmodelreflection-ch-reference.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/MxModelReflection/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/MxModelReflection/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
