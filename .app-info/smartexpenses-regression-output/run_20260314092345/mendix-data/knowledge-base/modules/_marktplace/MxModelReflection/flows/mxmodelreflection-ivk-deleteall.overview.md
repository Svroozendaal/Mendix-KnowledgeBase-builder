---
objectType: flow
module: MxModelReflection
qualifiedName: MxModelReflection.IVK_deleteAll
stableId: 55bd7749-b4ba-4cc0-9e46-ea20869aa982
slug: mxmodelreflection-ivk-deleteall
layer: L1
l0: mxmodelreflection-ivk-deleteall.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/MxModelReflection/flows/mxmodelreflection-ivk-deleteall.json
l2Logical: flow:MxModelReflection.IVK_deleteAll
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: MxModelReflection.IVK_deleteAll

## Summary

- Likely acts as a save, process, or background step for MxModelReflection.Microflows, MxModelReflection.MxObjectType, MxModelReflection.ValueType because it mutates data without showing a page.
- L0: [abstract](mxmodelreflection-ivk-deleteall.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/MxModelReflection/flows/mxmodelreflection-ivk-deleteall.json)

## Main Steps

- retrieve allMicroflows from MxModelReflection.Microflows
- retrieve allObjTypes from MxModelReflection.MxObjectType
- DeleteAction: delete allMicroflows (refreshInClient=true) delete allMicroflows (refreshInClient=true)
- DeleteAction: delete allObjTypes (refreshInClient=true) delete allObjTypes (refreshInClient=true)

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; the entry point may be navigation, background execution, or an export gap.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- MxModelReflection.Microflows, MxModelReflection.MxObjectType, MxModelReflection.ValueType

## Called / Called By

- Calls: none
- Called by: none

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=358e3650-def1-4a4b-b4c0-cafd289b5efa; sourceKind=Database; entity=MxModelReflection.Microflows; summary=retrieve allMicroflows from MxModelReflection.Microflows
- nodeId=130a9909-3247-4d4d-80a8-87ca0e8b8850; sourceKind=Database; entity=MxModelReflection.MxObjectType; summary=retrieve allObjTypes from MxModelReflection.MxObjectType
- nodeId=41b64ece-7315-4aba-b8ab-4e0a34603da6; sourceKind=Database; entity=MxModelReflection.ValueType; summary=retrieve allValueTypes from MxModelReflection.ValueType
- nodeId=1789fbc4-2737-4cbd-8929-7fa8b9479174; actionKind=Delete; members=refreshInClient=true; summary=DeleteAction: delete allMicroflows (refreshInClient=true) delete allMicroflows (refreshInClient=true)
- nodeId=f5caf918-97be-4aa9-af39-be449f919eb4; actionKind=Delete; members=refreshInClient=true; summary=DeleteAction: delete allObjTypes (refreshInClient=true) delete allObjTypes (refreshInClient=true)
- nodeId=1887d12a-ed8c-4249-9016-b5d075ca7aeb; actionKind=Delete; members=refreshInClient=true; summary=DeleteAction: delete allValueTypes (refreshInClient=true) delete allValueTypes (refreshInClient=true)

## Warnings/Unknowns

- No material warnings from deterministic export synthesis.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/MxModelReflection/flows/mxmodelreflection-ivk-deleteall.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/MxModelReflection/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/MxModelReflection/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
