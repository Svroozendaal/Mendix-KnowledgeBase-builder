---
objectType: flow
module: MxModelReflection
qualifiedName: MxModelReflection.ACT_ShowMemberPage
stableId: fb44c55a-4c81-48b7-a01e-5897e4b25de9
slug: mxmodelreflection-act-showmemberpage
layer: L1
l0: mxmodelreflection-act-showmemberpage.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/MxModelReflection/flows/mxmodelreflection-act-showmemberpage.json
l2Logical: flow:MxModelReflection.ACT_ShowMemberPage
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: MxModelReflection.ACT_ShowMemberPage

## Summary

- Likely acts as a UI entry or navigation handler because it shows MxModelReflection.Member_View, MxModelReflection.MemberEnum_View.
- L0: [abstract](mxmodelreflection-act-showmemberpage.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/MxModelReflection/flows/mxmodelreflection-act-showmemberpage.json)

## Main Steps

- split MxObjectMember split MxObjectMember
- ShowPageAction: show page MxModelReflection.MemberEnum_View show page MxModelReflection.MemberEnum_View

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; this likely starts from UI interaction or navigation.
- Output/UI context: Shows MxModelReflection.Member_View, MxModelReflection.MemberEnum_View.

## Key Entities Touched

- No entity names were resolved from exported nodes; inspect L2 JSON if exact read/write scope matters.

## Called / Called By

- Calls: none
- Called by: none

## Shown Pages

- MxModelReflection.Member_View, MxModelReflection.MemberEnum_View

## Important Retrieves/Decisions/Mutations

- No retrieve, decision, or mutation metadata was exported for this flow; inspect L2 JSON if node-level evidence matters.

## Warnings/Unknowns

- Rollback hint detected in node detail.
- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/MxModelReflection/flows/mxmodelreflection-act-showmemberpage.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/MxModelReflection/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/MxModelReflection/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
