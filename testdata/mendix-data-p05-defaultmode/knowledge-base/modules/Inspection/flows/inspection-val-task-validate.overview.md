---
objectType: flow
module: Inspection
qualifiedName: Inspection.VAL_Task_Validate
stableId: e3e58a5f-2f78-4371-813b-2b62ad3c646b
slug: inspection-val-task-validate
layer: L1
l0: inspection-val-task-validate.abstract.md
l2Path: ../../../../../mendix-data-p05-legacy/app-overview/current/modules/Inspection/flows/inspection-val-task-validate.json
l2Logical: flow:Inspection.VAL_Task_Validate
sourceRun: cli_2026-03-18T20-44-56.522Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: Inspection.VAL_Task_Validate

## Summary

- Likely acts as a save, process, or background step because it mutates data without showing a page.
- L0: [abstract](inspection-val-task-validate.abstract.md)
- L2: [json](../../../../../mendix-data-p05-legacy/app-overview/current/modules/Inspection/flows/inspection-val-task-validate.json)

## Main Steps

- $Task/Priority != empty Is Priority not empty? expression=$Task/Priority != empty
- $UserRole/Name = 'Manager' or $UserRole/Name = 'Administrator' user role manager or admin? expression=$UserRole/Name = 'Manager' or $UserRole/Name = 'Administrator'
- ChangeVariableAction: change variable IsValid=false change variable IsValid=false

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

- nodeId=12fbe0ac-ab5f-4151-9e4f-7acb0946417a; caption=Is Priority not empty?; expression=$Task/Priority != empty Is Priority not empty? expression=$Task/Priority != empty
- nodeId=41799ad6-882c-4a4c-badf-bfbf105c989e; caption=user role manager or admin?; expression=$UserRole/Name = 'Manager' or $UserRole/Name = 'Administrator' user role manager or admin? expression=$UserRole/Name = 'Manager' or $UserRole/Name = 'Administrator'
- nodeId=62ed7cfc-6cc5-46ab-a91e-7ca3e2e8a72e; caption=Is Description not empty?; expression=trim($Task/Description) != '' Is Description not empty? expression=trim($Task/Description) != ''
- nodeId=77b885b2-9544-4eb0-a4d7-abed7de53f7d; caption=Is Created on not empty?; expression=$Task/Created != empty Is Created on not empty? expression=$Task/Created != empty
- nodeId=ae09faac-75de-4db1-b9bb-f8a5778b65d1; caption=Is Due date not empty?; expression=$Task/DueDate != empty Is Due date not empty? expression=$Task/DueDate != empty
- nodeId=da141952-9dde-4300-9bf4-eec6b1912747; caption=Is remarks not empty?; expression=trim($Task/AdditionalRemarks) != '' Is remarks not empty? expression=trim($Task/AdditionalRemarks) != ''
- nodeId=fb8e4ce2-1038-49fb-ab1a-779383eb7405; caption=Is Status not empty?; expression=$Task/Status != empty Is Status not empty? expression=$Task/Status != empty
- nodeId=095a9337-8445-4f0a-80e3-a2ba0e872d28; actionKind=Change; summary=ChangeVariableAction: change variable IsValid=false change variable IsValid=false

## Warnings/Unknowns

- Rollback hint detected in node detail.
- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../mendix-data-p05-legacy/app-overview/current/modules/Inspection/flows/inspection-val-task-validate.json)
- Aggregate export: [flows.json](../../../../../mendix-data-p05-legacy/app-overview/cli_2026-03-18T20-44-56.522Z/modules/Inspection/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../mendix-data-p05-legacy/app-overview/cli_2026-03-18T20-44-56.522Z/modules/Inspection/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-18T20-44-56.522Z
