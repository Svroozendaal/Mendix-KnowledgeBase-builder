---
objectType: flow
module: MxModelReflection
qualifiedName: MxModelReflection.Ch_ObjecttypeReference
stableId: 14fc2940-bc2a-4f1b-b111-dc6a7544e6a7
slug: mxmodelreflection-ch-objecttypereference
layer: L1
l0: mxmodelreflection-ch-objecttypereference.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/MxModelReflection/flows/mxmodelreflection-ch-objecttypereference.json
l2Logical: flow:MxModelReflection.Ch_ObjecttypeReference
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: MxModelReflection.Ch_ObjecttypeReference

## Summary

- Likely acts as a save, process, or background step because it mutates data without showing a page.
- L0: [abstract](mxmodelreflection-ch-objecttypereference.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/MxModelReflection/flows/mxmodelreflection-ch-objecttypereference.json)

## Main Steps

- retrieve MxObjectType over association Token_MxObjectType_Referenced from Token
- ChangeObjectAction: change Token (FindObjectReference=$MxObjectType/CompleteName; refreshInClient=true) change Token (FindObjectReference=$MxObjectType/CompleteName; refreshInClient=true)

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

- nodeId=43d172d5-a150-4028-b60b-da9f1b14a467; sourceKind=Association; association=Token_MxObjectType_Referenced; summary=retrieve MxObjectType over association Token_MxObjectType_Referenced from Token
- nodeId=ba9d8b5e-21a6-40e7-89e0-1b2c612a8f81; actionKind=Change; members=FindObjectReference=$MxObjectType/CompleteName; refreshInClient=true; summary=ChangeObjectAction: change Token (FindObjectReference=$MxObjectType/CompleteName; refreshInClient=true) change Token (FindObjectReference=$MxObjectType/CompleteName; refreshInClient=true)

## Warnings/Unknowns

- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/MxModelReflection/flows/mxmodelreflection-ch-objecttypereference.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/MxModelReflection/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/MxModelReflection/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
