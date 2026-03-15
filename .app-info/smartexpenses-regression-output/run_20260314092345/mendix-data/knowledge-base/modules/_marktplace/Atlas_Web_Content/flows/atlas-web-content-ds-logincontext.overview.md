---
objectType: flow
module: Atlas_Web_Content
qualifiedName: Atlas_Web_Content.DS_LoginContext
stableId: bdc6bd07-d246-48ad-b886-a94adba7b6b4
slug: atlas-web-content-ds-logincontext
layer: L1
l0: atlas-web-content-ds-logincontext.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/Atlas_Web_Content/flows/atlas-web-content-ds-logincontext.json
l2Logical: flow:Atlas_Web_Content.DS_LoginContext
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: Atlas_Web_Content.DS_LoginContext

## Summary

- Likely acts as a save, process, or background step for Atlas_Web_Content.LoginContext because it mutates data without showing a page.
- L0: [abstract](atlas-web-content-ds-logincontext.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/Atlas_Web_Content/flows/atlas-web-content-ds-logincontext.json)

## Main Steps

- CreateObjectAction: create Atlas_Web_Content.LoginContext as NewLoginContext create Atlas_Web_Content.LoginContext as NewLoginContext

## Trigger/Input/Output Context

- Kind: Nanoflow
- Entry/call context: No inbound caller was exported; the entry point may be navigation, background execution, or an export gap.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- Atlas_Web_Content.LoginContext

## Called / Called By

- Calls: none
- Called by: none

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=c161c8c3-047d-4c88-8452-b1255d57c5b2; actionKind=Create; entity=Atlas_Web_Content.LoginContext; summary=CreateObjectAction: create Atlas_Web_Content.LoginContext as NewLoginContext create Atlas_Web_Content.LoginContext as NewLoginContext

## Warnings/Unknowns

- No material warnings from deterministic export synthesis.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/Atlas_Web_Content/flows/atlas-web-content-ds-logincontext.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/Atlas_Web_Content/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/Atlas_Web_Content/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
