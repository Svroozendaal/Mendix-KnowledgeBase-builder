---
objectType: flow
module: Inspection
qualifiedName: Inspection.ACT_CoverPhoto_Save
stableId: 1ff4d8f8-a639-4bb4-8897-764b26df984e
slug: inspection-act-coverphoto-save
layer: L1
l0: inspection-act-coverphoto-save.abstract.md
l2Path: ../../../../app-overview/current/modules/Inspection/flows/inspection-act-coverphoto-save.json
l2Logical: flow:Inspection.ACT_CoverPhoto_Save
sourceRun: cli_2026-03-18T20-56-46.385Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: Inspection.ACT_CoverPhoto_Save

## Summary

- Likely acts as a save, process, or background step because it mutates data without showing a page.
- L0: [abstract](inspection-act-coverphoto-save.abstract.md)
- L2: [json](../../../../app-overview/current/modules/Inspection/flows/inspection-act-coverphoto-save.json)

## Main Steps

- CommitAction: commit CoverPhoto (refreshInClient=true, withEvents=true) commit CoverPhoto (refreshInClient=true, withEvents=true)

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

- nodeId=0d803ec3-9550-4442-87e2-ba63aaaa1656; actionKind=Commit; members=refreshInClient=true, withEvents=true; summary=CommitAction: commit CoverPhoto (refreshInClient=true, withEvents=true) commit CoverPhoto (refreshInClient=true, withEvents=true)

## Warnings/Unknowns

- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../app-overview/current/modules/Inspection/flows/inspection-act-coverphoto-save.json)
- Aggregate export: [flows.json](../../../../app-overview/cli_2026-03-18T20-56-46.385Z/modules/Inspection/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../app-overview/cli_2026-03-18T20-56-46.385Z/modules/Inspection/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-18T20-56-46.385Z
