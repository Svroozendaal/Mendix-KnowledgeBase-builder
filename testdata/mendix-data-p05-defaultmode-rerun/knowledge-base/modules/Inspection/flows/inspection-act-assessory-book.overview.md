---
objectType: flow
module: Inspection
qualifiedName: Inspection.ACT_Assessory_Book
stableId: 55c66afc-5ad1-4865-aa64-1fb050493d8e
slug: inspection-act-assessory-book
layer: L1
l0: inspection-act-assessory-book.abstract.md
l2Path: ../../../../../mendix-data-p05-mxcli-rerun/app-overview/current/modules/Inspection/flows/inspection-act-assessory-book.json
l2Logical: flow:Inspection.ACT_Assessory_Book
sourceRun: cli_2026-03-18T20-53-14.243Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: Inspection.ACT_Assessory_Book

## Summary

- Likely acts as a save, process, or background step because it mutates data without showing a page.
- L0: [abstract](inspection-act-assessory-book.abstract.md)
- L2: [json](../../../../../mendix-data-p05-mxcli-rerun/app-overview/current/modules/Inspection/flows/inspection-act-assessory-book.json)

## Main Steps

- $Accessory/AmountInStock != 0
- $Accessory/AmountInStock > 10
- change $Accessory (AmountInStock = $Accessory/AmountInStock - 1)
- commit $Accessory WITH EVENTS REFRESH ON ERROR ROLLBACK

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

- nodeId=n002-decision; caption=IF; expression=$Accessory/AmountInStock != 0
- nodeId=n004-decision; caption=IF; expression=$Accessory/AmountInStock > 10
- nodeId=n006-decision; caption=IF; expression=$Accessory/AmountInStock = 0
- nodeId=n003-change; actionKind=Change; entity=Inspection.Accessory; members=AmountInStock = $Accessory/AmountInStock - 1; summary=change $Accessory (AmountInStock = $Accessory/AmountInStock - 1)
- nodeId=n005-commit; actionKind=Commit; entity=Inspection.Accessory; summary=commit $Accessory WITH EVENTS REFRESH ON ERROR ROLLBACK

## Warnings/Unknowns

- Rollback hint detected in node detail.
- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../mendix-data-p05-mxcli-rerun/app-overview/current/modules/Inspection/flows/inspection-act-assessory-book.json)
- Aggregate export: [flows.json](../../../../../mendix-data-p05-mxcli-rerun/app-overview/cli_2026-03-18T20-53-14.243Z/modules/Inspection/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../mendix-data-p05-mxcli-rerun/app-overview/cli_2026-03-18T20-53-14.243Z/modules/Inspection/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-18T20-53-14.243Z
