---
objectType: flow
module: Inspection
qualifiedName: Inspection.VAL_Inspector_Validate
stableId: 1866348e-066f-451e-8396-431a8467b19e
slug: inspection-val-inspector-validate
layer: L1
l0: inspection-val-inspector-validate.abstract.md
l2Path: ../../../../../mendix-data-p05-mxcli-rerun/app-overview/current/modules/Inspection/flows/inspection-val-inspector-validate.json
l2Logical: flow:Inspection.VAL_Inspector_Validate
sourceRun: cli_2026-03-18T20-53-14.243Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: Inspection.VAL_Inspector_Validate

## Summary

- Likely serves as a helper flow invoked from Inspection.ACT_Inspector_Save.
- L0: [abstract](inspection-val-inspector-validate.abstract.md)
- L2: [json](../../../../../mendix-data-p05-mxcli-rerun/app-overview/current/modules/Inspection/flows/inspection-val-inspector-validate.json)

## Main Steps

- trim($Inspector/Name) != ''
- trim($Inspector/Telephone) != ''

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: Called by Inspection.ACT_Inspector_Save.
- Output/UI context: No page output was exported; check L2 JSON if the exact user-facing effect matters.

## Key Entities Touched

- No entity names were resolved from exported nodes; inspect L2 JSON if exact read/write scope matters.

## Called / Called By

- Calls: none
- Called by: Inspection.ACT_Inspector_Save

## Shown Pages

- No ShowPageAction was exported for this flow; it may serve validation, background processing, or delegate work to other flows.

## Important Retrieves/Decisions/Mutations

- nodeId=n003-decision; caption=IF; expression=trim($Inspector/Name) != ''
- nodeId=n004-decision; caption=IF; expression=trim($Inspector/Telephone) != ''
- nodeId=n005-decision; caption=IF; expression=trim($Inspector/EmailAddress) != ''
- nodeId=n008-decision; caption=IF; expression=trim($Inspector/Location) != ''
- nodeId=n011-decision; caption=IF; expression=trim($Inspector/Country) != ''
- nodeId=n016-decision; caption=IF; expression=$Inspector/Level != empty

## Warnings/Unknowns

- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../mendix-data-p05-mxcli-rerun/app-overview/current/modules/Inspection/flows/inspection-val-inspector-validate.json)
- Aggregate export: [flows.json](../../../../../mendix-data-p05-mxcli-rerun/app-overview/cli_2026-03-18T20-53-14.243Z/modules/Inspection/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../mendix-data-p05-mxcli-rerun/app-overview/cli_2026-03-18T20-53-14.243Z/modules/Inspection/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-18T20-53-14.243Z
