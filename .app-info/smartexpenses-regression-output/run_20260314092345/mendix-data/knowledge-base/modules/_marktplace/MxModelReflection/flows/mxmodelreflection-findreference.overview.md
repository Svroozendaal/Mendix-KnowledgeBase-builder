---
objectType: flow
module: MxModelReflection
qualifiedName: MxModelReflection.FindReference
stableId: 8dd83931-8ffe-482a-b832-7f3ace417ae0
slug: mxmodelreflection-findreference
layer: L1
l0: mxmodelreflection-findreference.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/MxModelReflection/flows/mxmodelreflection-findreference.json
l2Logical: flow:MxModelReflection.FindReference
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: MxModelReflection.FindReference

## Summary

- Likely serves as a helper flow invoked from ExcelImporter.Ch_FindReference, ExcelImporter.SetupTemplate.
- L0: [abstract](mxmodelreflection-findreference.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/MxModelReflection/flows/mxmodelreflection-findreference.json)

## Main Steps

- retrieve RetrievedReference from MxModelReflection.MxObjectReference
- retrieve RetrievedReference_1 from MxModelReflection.MxObjectReference
- $MxObjectType_optional != empty has objecttype? expression=$MxObjectType_optional != empty
- $RetrievedReference != empty Is RetrievedReference? expression=$RetrievedReference != empty

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: Called by ExcelImporter.Ch_FindReference, ExcelImporter.SetupTemplate.
- Output/UI context: No page output was exported; check L2 JSON if the exact user-facing effect matters.

## Key Entities Touched

- MxModelReflection.MxObjectReference

## Called / Called By

- Calls: none
- Called by: ExcelImporter.Ch_FindReference, ExcelImporter.SetupTemplate

## Shown Pages

- No ShowPageAction was exported for this flow; it may serve validation, background processing, or delegate work to other flows.

## Important Retrieves/Decisions/Mutations

- nodeId=fa44dda7-f2ab-44a8-98fd-10004f6f3186; sourceKind=Database; entity=MxModelReflection.MxObjectReference; summary=retrieve RetrievedReference from MxModelReflection.MxObjectReference
- nodeId=67d9dfe6-7a6b-48f4-9826-16e18dc41a5d; sourceKind=Database; entity=MxModelReflection.MxObjectReference; summary=retrieve RetrievedReference_1 from MxModelReflection.MxObjectReference
- nodeId=67d601a5-e4e4-462d-91a5-4627db0659cb; sourceKind=Database; entity=MxModelReflection.MxObjectReference; summary=retrieve RetrievedReference_ByObjectType from MxModelReflection.MxObjectReference
- nodeId=f8f1c1e8-4af2-4cac-bb88-b59dbf61cdd8; sourceKind=Database; entity=MxModelReflection.MxObjectReference; summary=retrieve RetrievedReference_ByObjectType_1 from MxModelReflection.MxObjectReference
- nodeId=e4cdc6ec-83b5-4128-be64-9859fe76ee47; caption=has objecttype?; expression=$MxObjectType_optional != empty has objecttype? expression=$MxObjectType_optional != empty
- nodeId=f458baf6-5990-4700-8ce7-20c8d8eb31d0; caption=Is RetrievedReference?; expression=$RetrievedReference != empty Is RetrievedReference? expression=$RetrievedReference != empty
- nodeId=84ddc426-2902-4c27-80c2-a678f19b301d; caption=is RetrievedReference?; expression=$RetrievedReference_ByObjectType != empty is RetrievedReference? expression=$RetrievedReference_ByObjectType != empty
- nodeId=65bba5a1-9c75-4670-8053-723b3d59ee0c; caption=search str != empty; expression=$ReferenceSearchString != empty search str != empty expression=$ReferenceSearchString != empty

## Warnings/Unknowns

- No material warnings from deterministic export synthesis.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/MxModelReflection/flows/mxmodelreflection-findreference.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/MxModelReflection/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/MxModelReflection/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
