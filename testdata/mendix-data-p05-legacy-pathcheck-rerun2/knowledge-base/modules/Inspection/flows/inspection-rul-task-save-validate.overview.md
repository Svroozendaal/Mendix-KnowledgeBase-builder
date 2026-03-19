---
objectType: flow
module: Inspection
qualifiedName: Inspection.RUL_Task_Save_Validate
stableId: ccf3fa48-7daa-4307-8196-b75e276beac6
slug: inspection-rul-task-save-validate
layer: L1
l0: inspection-rul-task-save-validate.abstract.md
l2Path: ../../../../app-overview/current/modules/Inspection/flows/inspection-rul-task-save-validate.json
l2Logical: flow:Inspection.RUL_Task_Save_Validate
sourceRun: cli_2026-03-18T20-56-46.385Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: Inspection.RUL_Task_Save_Validate

## Summary

- Likely acts as a save, process, or background step because it mutates data without showing a page.
- L0: [abstract](inspection-rul-task-save-validate.abstract.md)
- L2: [json](../../../../app-overview/current/modules/Inspection/flows/inspection-rul-task-save-validate.json)

## Main Steps

- $Task/Created != empty Is Created on not empty? expression=$Task/Created != empty
- $Task/Status != empty Is Status not empty? expression=$Task/Status != empty
- ChangeVariableAction: change variable IsValid=false change variable IsValid=false

## Trigger/Input/Output Context

- Kind: Rule
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

- nodeId=0959dfc2-7606-4525-b044-e179cf74c6e2; caption=Is Created on not empty?; expression=$Task/Created != empty Is Created on not empty? expression=$Task/Created != empty
- nodeId=660a002b-3810-416e-b9f8-2060ac219bf3; caption=Is Status not empty?; expression=$Task/Status != empty Is Status not empty? expression=$Task/Status != empty
- nodeId=753b541f-727b-423f-94ab-e1215d4e566d; caption=Is Due date not empty?; expression=$Task/DueDate != empty Is Due date not empty? expression=$Task/DueDate != empty
- nodeId=c59cc980-ca8d-47db-bf78-8407c09fd43b; caption=Is Description not empty?; expression=trim($Task/Description) != '' Is Description not empty? expression=trim($Task/Description) != ''
- nodeId=ef5edb58-0545-4b1f-ad73-d3f411ce9df8; caption=Is Priority not empty?; expression=$Task/Priority != empty Is Priority not empty? expression=$Task/Priority != empty
- nodeId=fcc0b285-e986-433e-b8a3-8f7afd0a07aa; caption=Is Title not empty?; expression=trim($Task/Title) != '' Is Title not empty? expression=trim($Task/Title) != ''
- nodeId=106c9a13-79e0-4efa-9684-3f03584a71de; actionKind=Change; summary=ChangeVariableAction: change variable IsValid=false change variable IsValid=false
- nodeId=1ca6d14d-b882-4788-af6f-db78465ce821; actionKind=Change; summary=ChangeVariableAction: change variable IsValid=false change variable IsValid=false

## Warnings/Unknowns

- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../app-overview/current/modules/Inspection/flows/inspection-rul-task-save-validate.json)
- Aggregate export: [flows.json](../../../../app-overview/cli_2026-03-18T20-56-46.385Z/modules/Inspection/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../app-overview/cli_2026-03-18T20-56-46.385Z/modules/Inspection/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-18T20-56-46.385Z
