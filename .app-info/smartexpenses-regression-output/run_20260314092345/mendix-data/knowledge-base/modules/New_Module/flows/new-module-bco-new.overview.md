---
objectType: flow
module: New_Module
qualifiedName: New_Module.BCO_new
stableId: 6ae81a70-01c4-4dff-85ab-8f908adbb547
slug: new-module-bco-new
layer: L1
l0: new-module-bco-new.abstract.md
l2Path: ../../../../app-overview/current/modules/New_Module/flows/new-module-bco-new.json
l2Logical: flow:New_Module.BCO_new
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: New_Module.BCO_new

## Summary

- Likely acts as a save, process, or background step because it mutates data without showing a page.
- L0: [abstract](new-module-bco-new.abstract.md)
- L2: [json](../../../../app-overview/current/modules/New_Module/flows/new-module-bco-new.json)

## Main Steps

- ChangeObjectAction: change Entitywith10attributes (Attribute2int=$Entitywith10attributes/Attribute2int + 15; refreshInClient=false) change Entitywith10attributes (Attribute2int=$Entitywith10attributes/Attribute2int + 15; refreshInClient=false)

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

- nodeId=b9f056da-2859-4a6b-91ab-112ec29ab1dd; actionKind=Change; members=Attribute2int=$Entitywith10attributes/Attribute2int + 15; refreshInClient=false; summary=ChangeObjectAction: change Entitywith10attributes (Attribute2int=$Entitywith10attributes/Attribute2int + 15; refreshInClient=false) change Entitywith10attributes (Attribute2int=$Entitywith10attributes/Attribute2int + 15; refreshInClient=false)

## Warnings/Unknowns

- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../app-overview/current/modules/New_Module/flows/new-module-bco-new.json)
- Aggregate export: [flows.json](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/New_Module/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/New_Module/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
