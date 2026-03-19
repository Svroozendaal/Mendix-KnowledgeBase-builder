---
objectType: flow
module: Inspection
qualifiedName: Inspection.ACT_Assessory_Delete
stableId: a500d88f-a4d1-4141-a6a1-6cda0344db36
slug: inspection-act-assessory-delete
layer: L1
l0: inspection-act-assessory-delete.abstract.md
l2Path: ../../../../app-overview/current/modules/Inspection/flows/inspection-act-assessory-delete.json
l2Logical: flow:Inspection.ACT_Assessory_Delete
sourceRun: cli_2026-03-18T20-54-38.903Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: Inspection.ACT_Assessory_Delete

## Summary

- Likely acts as a save, process, or background step because it mutates data without showing a page.
- L0: [abstract](inspection-act-assessory-delete.abstract.md)
- L2: [json](../../../../app-overview/current/modules/Inspection/flows/inspection-act-assessory-delete.json)

## Main Steps

- delete $Accessory

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

- nodeId=n002-delete; actionKind=Delete; entity=Inspection.Accessory; summary=delete $Accessory

## Warnings/Unknowns

- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../app-overview/current/modules/Inspection/flows/inspection-act-assessory-delete.json)
- Aggregate export: [flows.json](../../../../app-overview/cli_2026-03-18T20-54-38.903Z/modules/Inspection/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../app-overview/cli_2026-03-18T20-54-38.903Z/modules/Inspection/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-18T20-54-38.903Z
