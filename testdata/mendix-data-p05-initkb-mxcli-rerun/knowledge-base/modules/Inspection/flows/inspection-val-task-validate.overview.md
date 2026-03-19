---
objectType: flow
module: Inspection
qualifiedName: Inspection.VAL_Task_Validate
stableId: e3e58a5f-2f78-4371-813b-2b62ad3c646b
slug: inspection-val-task-validate
layer: L1
l0: inspection-val-task-validate.abstract.md
l2Path: ../../../../app-overview/current/modules/Inspection/flows/inspection-val-task-validate.json
l2Logical: flow:Inspection.VAL_Task_Validate
sourceRun: cli_2026-03-18T20-57-13.045Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: Inspection.VAL_Task_Validate

## Summary

- Likely acts as a save, process, or background step because it mutates data without showing a page.
- L0: [abstract](inspection-val-task-validate.abstract.md)
- L2: [json](../../../../app-overview/current/modules/Inspection/flows/inspection-val-task-validate.json)

## Main Steps

- $UserRole/Name = 'Manager' or $UserRole/Name = 'Administrator'
- trim($Task/AdditionalRemarks) != ''
- VALIDATION FEEDBACK $Task/Created MESSAGE 'Create date is empty' VALIDATION FEEDBACK $Task/Created MESSAGE 'Create date is empty'

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: Called by Inspection.ACT_Task_Save, Inspection.ACT_Task_SetToDone.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- No entity names were resolved from exported nodes; inspect L2 JSON if exact read/write scope matters.

## Called / Called By

- Calls: Inspection.DS_UserRole_GetFromCurrentUser
- Called by: Inspection.ACT_Task_Save, Inspection.ACT_Task_SetToDone

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=n004-decision; caption=IF; expression=$UserRole/Name = 'Manager' or $UserRole/Name = 'Administrator'
- nodeId=n005-decision; caption=IF; expression=trim($Task/AdditionalRemarks) != ''
- nodeId=n006-decision; caption=IF; expression=true
- nodeId=n007-decision; caption=IF; expression=trim($Task/Description) != ''
- nodeId=n008-decision; caption=IF; expression=$Task/Priority != empty
- nodeId=n009-decision; caption=IF; expression=$Task/Created != empty
- nodeId=n010-decision; caption=IF; expression=$Task/Status != empty
- nodeId=n017-decision; caption=IF; expression=$Task/DueDate != empty

## Warnings/Unknowns

- Rollback hint detected in node detail.
- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../app-overview/current/modules/Inspection/flows/inspection-val-task-validate.json)
- Aggregate export: [flows.json](../../../../app-overview/cli_2026-03-18T20-57-13.045Z/modules/Inspection/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../app-overview/cli_2026-03-18T20-57-13.045Z/modules/Inspection/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-18T20-57-13.045Z
