---
objectType: flow
module: Inspection
qualifiedName: Inspection.ACT_Inspector_Save
stableId: 5407b316-96ac-43e0-9d61-c483a9334092
slug: inspection-act-inspector-save
layer: L1
l0: inspection-act-inspector-save.abstract.md
l2Path: ../../../../app-overview/current/modules/Inspection/flows/inspection-act-inspector-save.json
l2Logical: flow:Inspection.ACT_Inspector_Save
sourceRun: cli_2026-03-18T20-56-46.385Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: Inspection.ACT_Inspector_Save

## Summary

- Likely acts as a save, process, or background step because it mutates data without showing a page.
- L0: [abstract](inspection-act-inspector-save.abstract.md)
- L2: [json](../../../../app-overview/current/modules/Inspection/flows/inspection-act-inspector-save.json)

## Main Steps

- $IsValid valid? expression=$IsValid
- CommitAction: commit Inspector (refreshInClient=true, withEvents=true) commit Inspector (refreshInClient=true, withEvents=true)

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; this likely starts from UI interaction or navigation.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- No entity names were resolved from exported nodes; inspect L2 JSON if exact read/write scope matters.

## Called / Called By

- Calls: Inspection.VAL_Inspector_Validate
- Called by: none

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=e53f246a-a283-4532-b58a-07d74b7b665c; caption=valid?; expression=$IsValid valid? expression=$IsValid
- nodeId=f51cc754-1e2c-4c87-900c-079868a2ed91; actionKind=Commit; members=refreshInClient=true, withEvents=true; summary=CommitAction: commit Inspector (refreshInClient=true, withEvents=true) commit Inspector (refreshInClient=true, withEvents=true)

## Warnings/Unknowns

- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../app-overview/current/modules/Inspection/flows/inspection-act-inspector-save.json)
- Aggregate export: [flows.json](../../../../app-overview/cli_2026-03-18T20-56-46.385Z/modules/Inspection/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../app-overview/cli_2026-03-18T20-56-46.385Z/modules/Inspection/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-18T20-56-46.385Z
