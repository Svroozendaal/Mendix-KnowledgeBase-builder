---
objectType: flow
module: MxModelReflection
qualifiedName: MxModelReflection.FindObjectType
stableId: 89f4862e-e779-45f5-962e-9ed898bd972b
slug: mxmodelreflection-findobjecttype
layer: L1
l0: mxmodelreflection-findobjecttype.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/MxModelReflection/flows/mxmodelreflection-findobjecttype.json
l2Logical: flow:MxModelReflection.FindObjectType
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: MxModelReflection.FindObjectType

## Summary

- Likely serves as a helper flow invoked from ExcelImporter.Ch_FindObjectType_Reference, ExcelImporter.SetupTemplate, MxModelReflection.OC_FindObjectType.
- L0: [abstract](mxmodelreflection-findobjecttype.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/MxModelReflection/flows/mxmodelreflection-findobjecttype.json)

## Main Steps

- retrieve RetrievedObjectType from MxModelReflection.MxObjectType
- retrieve RetrievedObjectType_1 from MxModelReflection.MxObjectType
- $MxObjectReference_optional != empty has reference? expression=$MxObjectReference_optional != empty
- $RetrievedObjectType_ByReference != empty is RetrieveObjectType? expression=$RetrievedObjectType_ByReference != empty

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: Called by ExcelImporter.Ch_FindObjectType_Reference, ExcelImporter.SetupTemplate, MxModelReflection.OC_FindObjectType.
- Output/UI context: No page output was exported; check L2 JSON if the exact user-facing effect matters.

## Key Entities Touched

- MxModelReflection.MxObjectType

## Called / Called By

- Calls: none
- Called by: ExcelImporter.Ch_FindObjectType_Reference, ExcelImporter.SetupTemplate, MxModelReflection.OC_FindObjectType

## Shown Pages

- No ShowPageAction was exported for this flow; it may serve validation, background processing, or delegate work to other flows.

## Important Retrieves/Decisions/Mutations

- nodeId=300d8363-e22c-42bc-8611-74547ae016c2; sourceKind=Database; entity=MxModelReflection.MxObjectType; summary=retrieve RetrievedObjectType from MxModelReflection.MxObjectType
- nodeId=2c9d1a10-6aab-4547-b8ce-5c74b6c68ec7; sourceKind=Database; entity=MxModelReflection.MxObjectType; summary=retrieve RetrievedObjectType_1 from MxModelReflection.MxObjectType
- nodeId=4d6b4810-17e8-4b55-8792-1fc547090b89; sourceKind=Database; entity=MxModelReflection.MxObjectType; summary=retrieve RetrievedObjectType_ByReference from MxModelReflection.MxObjectType
- nodeId=869292e4-82b0-46f2-a909-58ac183e6a21; sourceKind=Database; entity=MxModelReflection.MxObjectType; summary=retrieve RetrievedObjectType_ByReference_1 from MxModelReflection.MxObjectType
- nodeId=1ed6065c-1386-4f16-915e-122938530d1b; caption=has reference?; expression=$MxObjectReference_optional != empty has reference? expression=$MxObjectReference_optional != empty
- nodeId=148ac00c-b203-4d26-814c-a8d5498194fe; caption=is RetrieveObjectType?; expression=$RetrievedObjectType_ByReference != empty is RetrieveObjectType? expression=$RetrievedObjectType_ByReference != empty
- nodeId=fef8cc89-a9c5-4a2c-8bc8-03e2e9f67a3e; caption=is RetrivedObjectType?; expression=$RetrievedObjectType != empty is RetrivedObjectType? expression=$RetrievedObjectType != empty
- nodeId=0a21dd53-aff1-49ff-92bf-ab0482f751dd; caption=search str != empty; expression=$ObjectTypeSearchString != empty search str != empty expression=$ObjectTypeSearchString != empty

## Warnings/Unknowns

- No material warnings from deterministic export synthesis.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/MxModelReflection/flows/mxmodelreflection-findobjecttype.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/MxModelReflection/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/MxModelReflection/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
