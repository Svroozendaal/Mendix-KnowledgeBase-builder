---
objectType: flow
module: Inspection
qualifiedName: Inspection.ACT_Tool_Delete
stableId: d3b128c1-593e-438d-a003-302298e3e538
slug: inspection-act-tool-delete
layer: L1
l0: inspection-act-tool-delete.abstract.md
l2Path: ../../../../../mendix-data-p05-legacy/app-overview/current/modules/Inspection/flows/inspection-act-tool-delete.json
l2Logical: flow:Inspection.ACT_Tool_Delete
sourceRun: cli_2026-03-18T20-44-56.522Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: Inspection.ACT_Tool_Delete

## Summary

- Likely acts as a save, process, or background step because it mutates data without showing a page.
- L0: [abstract](inspection-act-tool-delete.abstract.md)
- L2: [json](../../../../../mendix-data-p05-legacy/app-overview/current/modules/Inspection/flows/inspection-act-tool-delete.json)

## Main Steps

- DeleteAction: delete Tool (refreshInClient=true) delete Tool (refreshInClient=true)

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; this likely starts from UI interaction or navigation.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- No entity names were resolved from exported nodes; inspect L2 JSON if exact read/write scope matters.

## Called / Called By

- Calls: none
- Called by: none

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=9a20c628-eaaa-4afb-b10d-2552e6004064; actionKind=Delete; members=refreshInClient=true; summary=DeleteAction: delete Tool (refreshInClient=true) delete Tool (refreshInClient=true)

## Warnings/Unknowns

- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../mendix-data-p05-legacy/app-overview/current/modules/Inspection/flows/inspection-act-tool-delete.json)
- Aggregate export: [flows.json](../../../../../mendix-data-p05-legacy/app-overview/cli_2026-03-18T20-44-56.522Z/modules/Inspection/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../mendix-data-p05-legacy/app-overview/cli_2026-03-18T20-44-56.522Z/modules/Inspection/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-18T20-44-56.522Z
