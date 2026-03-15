---
objectType: flow
module: MxModelReflection
qualifiedName: MxModelReflection.IVK_OpenReferencedMendixObject
stableId: 6e2bf5cd-b72f-4fca-ad90-bc3d2b2469a6
slug: mxmodelreflection-ivk-openreferencedmendixobject
layer: L1
l0: mxmodelreflection-ivk-openreferencedmendixobject.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/MxModelReflection/flows/mxmodelreflection-ivk-openreferencedmendixobject.json
l2Logical: flow:MxModelReflection.IVK_OpenReferencedMendixObject
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: MxModelReflection.IVK_OpenReferencedMendixObject

## Summary

- Likely acts as a UI entry or navigation handler because it shows MxModelReflection.MxObject_Details.
- L0: [abstract](mxmodelreflection-ivk-openreferencedmendixobject.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/MxModelReflection/flows/mxmodelreflection-ivk-openreferencedmendixobject.json)

## Main Steps

- retrieve MendixObject over association MxObjectReference_MxObjectType from Selection
- $Iterator != $MxObjectType expression=$Iterator != $MxObjectType
- ShowPageAction: show page MxModelReflection.MxObject_Details show page MxModelReflection.MxObject_Details

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; this likely starts from UI interaction or navigation.
- Output/UI context: Shows MxModelReflection.MxObject_Details.

## Key Entities Touched

- No entity names were resolved from exported nodes; inspect L2 JSON if exact read/write scope matters.

## Called / Called By

- Calls: none
- Called by: none

## Shown Pages

- MxModelReflection.MxObject_Details

## Important Retrieves/Decisions/Mutations

- nodeId=6aa59df0-5bc1-45a3-ab82-afeba44ca6af; sourceKind=Association; association=MxObjectReference_MxObjectType; summary=retrieve MendixObject over association MxObjectReference_MxObjectType from Selection
- nodeId=a474f0e3-0d20-44b0-9b59-01aa338d5ee1; caption=none; expression=$Iterator != $MxObjectType expression=$Iterator != $MxObjectType

## Warnings/Unknowns

- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/MxModelReflection/flows/mxmodelreflection-ivk-openreferencedmendixobject.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/MxModelReflection/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/MxModelReflection/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
