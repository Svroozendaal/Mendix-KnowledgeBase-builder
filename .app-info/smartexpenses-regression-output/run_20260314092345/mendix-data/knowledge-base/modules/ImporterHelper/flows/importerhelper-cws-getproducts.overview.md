---
objectType: flow
module: ImporterHelper
qualifiedName: ImporterHelper.CWS_GetProducts
stableId: 45ff07cb-a305-4927-8c78-dc5e18105e98
slug: importerhelper-cws-getproducts
layer: L1
l0: importerhelper-cws-getproducts.abstract.md
l2Path: ../../../../app-overview/current/modules/ImporterHelper/flows/importerhelper-cws-getproducts.json
l2Logical: flow:ImporterHelper.CWS_GetProducts
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: ImporterHelper.CWS_GetProducts

## Summary

- Likely acts as a save, process, or background step because it mutates data without showing a page.
- L0: [abstract](importerhelper-cws-getproducts.abstract.md)
- L2: [json](../../../../app-overview/current/modules/ImporterHelper/flows/importerhelper-cws-getproducts.json)

## Main Steps

- $Response != empty Response full? expression=$Response != empty
- CommitAction: commit Response (refreshInClient=true, withEvents=true) commit Response (refreshInClient=true, withEvents=true)

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

- nodeId=2012f427-41d5-49bc-99e5-c209124505c4; caption=Response full?; expression=$Response != empty Response full? expression=$Response != empty
- nodeId=37b26612-4809-40ac-991c-650d03fb9c8e; actionKind=Commit; members=refreshInClient=true, withEvents=true; summary=CommitAction: commit Response (refreshInClient=true, withEvents=true) commit Response (refreshInClient=true, withEvents=true)

## Warnings/Unknowns

- Rollback hint detected in node detail.
- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../app-overview/current/modules/ImporterHelper/flows/importerhelper-cws-getproducts.json)
- Aggregate export: [flows.json](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/ImporterHelper/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/ImporterHelper/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
