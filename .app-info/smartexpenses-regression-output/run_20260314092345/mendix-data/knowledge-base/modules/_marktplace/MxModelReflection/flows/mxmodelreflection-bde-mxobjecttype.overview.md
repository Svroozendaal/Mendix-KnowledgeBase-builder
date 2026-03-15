---
objectType: flow
module: MxModelReflection
qualifiedName: MxModelReflection.BDe_MxObjectType
stableId: 8021e248-c865-4faa-a04a-3e3fd04974f8
slug: mxmodelreflection-bde-mxobjecttype
layer: L1
l0: mxmodelreflection-bde-mxobjecttype.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/MxModelReflection/flows/mxmodelreflection-bde-mxobjecttype.json
l2Logical: flow:MxModelReflection.BDe_MxObjectType
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: MxModelReflection.BDe_MxObjectType

## Summary

- Likely acts as a save, process, or background step because it mutates data without showing a page.
- L0: [abstract](mxmodelreflection-bde-mxobjecttype.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/MxModelReflection/flows/mxmodelreflection-bde-mxobjecttype.json)

## Main Steps

- retrieve MxObjectReferenceList over association MxObjectReference_MxObjectType_Parent from Reference
- retrieve MxObjectReferenceList_Parent over association MxObjectReference_MxObjectType_Parent from MxObjectType
- $count = 1 = 1 expression=$count = 1
- $Reference/MxModelReflection.MxObjectReference_MxObjectType_Child = empty child object empty? expression=$Reference/MxModelReflection.MxObjectReference_MxObjectType_Child = empty
- DeleteAction: delete Reference (refreshInClient=false) delete Reference (refreshInClient=false)

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

- nodeId=55c809e2-b224-49aa-89a2-fb27247db1db; sourceKind=Association; association=MxObjectReference_MxObjectType_Parent; summary=retrieve MxObjectReferenceList over association MxObjectReference_MxObjectType_Parent from Reference
- nodeId=caeb2308-c02f-468d-99ac-85bdb779d5b5; sourceKind=Association; association=MxObjectReference_MxObjectType_Parent; summary=retrieve MxObjectReferenceList_Parent over association MxObjectReference_MxObjectType_Parent from MxObjectType
- nodeId=a490d73e-fe69-4d7a-a494-ac932d0e3408; caption== 1; expression=$count = 1 = 1 expression=$count = 1
- nodeId=cb8e942c-6640-411a-917a-f3b44545fe84; caption=child object empty?; expression=$Reference/MxModelReflection.MxObjectReference_MxObjectType_Child = empty child object empty? expression=$Reference/MxModelReflection.MxObjectReference_MxObjectType_Child = empty
- nodeId=76e9df81-cadd-4ead-be52-474fa76da364; actionKind=Delete; members=refreshInClient=false; summary=DeleteAction: delete Reference (refreshInClient=false) delete Reference (refreshInClient=false)

## Warnings/Unknowns

- Rollback hint detected in node detail.
- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/MxModelReflection/flows/mxmodelreflection-bde-mxobjecttype.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/MxModelReflection/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/MxModelReflection/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
