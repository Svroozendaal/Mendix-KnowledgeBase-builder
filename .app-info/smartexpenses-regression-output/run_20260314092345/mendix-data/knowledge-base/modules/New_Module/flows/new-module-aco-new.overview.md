---
objectType: flow
module: New_Module
qualifiedName: New_Module.ACO_new
stableId: 3a2752de-694a-431e-af02-abbb7257099a
slug: new-module-aco-new
layer: L1
l0: new-module-aco-new.abstract.md
l2Path: ../../../../app-overview/current/modules/New_Module/flows/new-module-aco-new.json
l2Logical: flow:New_Module.ACO_new
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: New_Module.ACO_new

## Summary

- Likely acts as a save, process, or background step because it mutates data without showing a page.
- L0: [abstract](new-module-aco-new.abstract.md)
- L2: [json](../../../../app-overview/current/modules/New_Module/flows/new-module-aco-new.json)

## Main Steps

- retrieve Entity2 over association Entitywith10attributes_Entity2 from Entitywith10attributes
- $Entity2 != empty filled? expression=$Entity2 != empty
- ChangeObjectAction: change Entity2 (Attribute=' jooo nieuwe tekst'; refreshInClient=false) change Entity2 (Attribute=' jooo nieuwe tekst'; refreshInClient=false)
- CommitAction: commit Entity2 (refreshInClient=false, withEvents=true) commit Entity2 (refreshInClient=false, withEvents=true)

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

- nodeId=d3f8bc33-d519-42b8-a05f-1238fd2ca3a7; sourceKind=Association; association=Entitywith10attributes_Entity2; summary=retrieve Entity2 over association Entitywith10attributes_Entity2 from Entitywith10attributes
- nodeId=78beadfe-7781-4f70-adc8-0f17d3bc22e1; caption=filled?; expression=$Entity2 != empty filled? expression=$Entity2 != empty
- nodeId=90213cb5-e1a9-405e-9db1-7b157da4afac; actionKind=Change; members=Attribute=' jooo nieuwe tekst'; refreshInClient=false; summary=ChangeObjectAction: change Entity2 (Attribute=' jooo nieuwe tekst'; refreshInClient=false) change Entity2 (Attribute=' jooo nieuwe tekst'; refreshInClient=false)
- nodeId=9b9c249e-d67b-4504-84c6-c10fa053897f; actionKind=Commit; members=refreshInClient=false, withEvents=true; summary=CommitAction: commit Entity2 (refreshInClient=false, withEvents=true) commit Entity2 (refreshInClient=false, withEvents=true)

## Warnings/Unknowns

- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../app-overview/current/modules/New_Module/flows/new-module-aco-new.json)
- Aggregate export: [flows.json](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/New_Module/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/New_Module/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
