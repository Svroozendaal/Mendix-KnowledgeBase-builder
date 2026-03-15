---
objectType: flow
module: MxModelReflection
qualifiedName: MxModelReflection.AssociationIsReferenceSet
stableId: 5e7b77c7-175a-4a73-bc34-253524d622ae
slug: mxmodelreflection-associationisreferenceset
layer: L1
l0: mxmodelreflection-associationisreferenceset.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/MxModelReflection/flows/mxmodelreflection-associationisreferenceset.json
l2Logical: flow:MxModelReflection.AssociationIsReferenceSet
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: MxModelReflection.AssociationIsReferenceSet

## Summary

- Deterministic overview derived from exported flow structure.
- L0: [abstract](mxmodelreflection-associationisreferenceset.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/MxModelReflection/flows/mxmodelreflection-associationisreferenceset.json)

## Main Steps

- retrieve MxObjectTypeList over association MxObjectReference_MxObjectType_Parent from MxObjectReference
- retrieve MxObjectTypeList_Child over association MxObjectReference_MxObjectType_Child from MxObjectReference
- $MxObjectReference/ReferenceType expression=$MxObjectReference/ReferenceType
- $MxObjectType_StartPoint != empty has startpoint expression=$MxObjectType_StartPoint != empty

## Trigger/Input/Output Context

- Kind: Rule
- Entry/call context: No inbound caller was exported; the entry point may be navigation, background execution, or an export gap.
- Output/UI context: No page output was exported; check L2 JSON if the exact user-facing effect matters.

## Key Entities Touched

- No entity names were resolved from exported nodes; inspect L2 JSON if exact read/write scope matters.

## Called / Called By

- Calls: none
- Called by: none

## Shown Pages

- No ShowPageAction was exported for this flow; it may serve validation, background processing, or delegate work to other flows.

## Important Retrieves/Decisions/Mutations

- nodeId=02deb7cd-71b9-4c7d-ba2c-c9f62663d5d7; sourceKind=Association; association=MxObjectReference_MxObjectType_Parent; summary=retrieve MxObjectTypeList over association MxObjectReference_MxObjectType_Parent from MxObjectReference
- nodeId=30fc721b-a5e5-4718-a88b-04369a187813; sourceKind=Association; association=MxObjectReference_MxObjectType_Child; summary=retrieve MxObjectTypeList_Child over association MxObjectReference_MxObjectType_Child from MxObjectReference
- nodeId=df85e0e9-b01e-47f1-b7a8-337af3dc3de4; caption=none; expression=$MxObjectReference/ReferenceType expression=$MxObjectReference/ReferenceType
- nodeId=d18c3c62-ac03-49fa-811e-ac5e91f42418; caption=has startpoint; expression=$MxObjectType_StartPoint != empty has startpoint expression=$MxObjectType_StartPoint != empty
- nodeId=6ae916af-c418-441e-a923-61912bc05393; caption=Is endpoint parent?; expression=$IsMxObjectEndpointInParent Is endpoint parent? expression=$IsMxObjectEndpointInParent
- nodeId=4571dba6-1b95-4142-8f0e-c10ec9bbe7da; caption=Is Startpoint in child; expression=$IsMxObjectStartpointInChild Is Startpoint in child expression=$IsMxObjectStartpointInChild

## Warnings/Unknowns

- Rollback hint detected in node detail.
- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/MxModelReflection/flows/mxmodelreflection-associationisreferenceset.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/MxModelReflection/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/MxModelReflection/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
