---
objectType: flow
module: Inspection
qualifiedName: Inspection.ACT_Tool_Delete
stableId: d3b128c1-593e-438d-a003-302298e3e538
slug: inspection-act-tool-delete
layer: L1
l0: inspection-act-tool-delete.abstract.md
l2Path: ../../../../app-overview/current/modules/Inspection/flows/inspection-act-tool-delete.json
l2Logical: flow:Inspection.ACT_Tool_Delete
sourceRun: cli_2026-03-18T21-10-02.160Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: Inspection.ACT_Tool_Delete

## Summary

- Likely acts as a save, process, or background step because it mutates data without showing a page.
- L0: [abstract](inspection-act-tool-delete.abstract.md)
- L2: [json](../../../../app-overview/current/modules/Inspection/flows/inspection-act-tool-delete.json)

## Main Steps

- delete $Tool

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

- nodeId=n002-delete; actionKind=Delete; entity=Inspection.Tool; summary=delete $Tool

## Warnings/Unknowns

- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../app-overview/current/modules/Inspection/flows/inspection-act-tool-delete.json)
- Aggregate export: [flows.json](../../../../app-overview/cli_2026-03-18T21-10-02.160Z/modules/Inspection/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../app-overview/cli_2026-03-18T21-10-02.160Z/modules/Inspection/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-18T21-10-02.160Z
