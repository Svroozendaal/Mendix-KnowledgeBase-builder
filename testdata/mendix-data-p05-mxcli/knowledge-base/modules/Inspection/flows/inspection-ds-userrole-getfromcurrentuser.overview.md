---
objectType: flow
module: Inspection
qualifiedName: Inspection.DS_UserRole_GetFromCurrentUser
stableId: f30baa04-ff29-4fbc-8040-32becd095cec
slug: inspection-ds-userrole-getfromcurrentuser
layer: L1
l0: inspection-ds-userrole-getfromcurrentuser.abstract.md
l2Path: ../../../../app-overview/current/modules/Inspection/flows/inspection-ds-userrole-getfromcurrentuser.json
l2Logical: flow:Inspection.DS_UserRole_GetFromCurrentUser
sourceRun: cli_2026-03-18T20-44-56.521Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: Inspection.DS_UserRole_GetFromCurrentUser

## Summary

- Likely supplies data to callers or pages rather than driving user navigation directly.
- L0: [abstract](inspection-ds-userrole-getfromcurrentuser.abstract.md)
- L2: [json](../../../../app-overview/current/modules/Inspection/flows/inspection-ds-userrole-getfromcurrentuser.json)

## Main Steps

- retrieve from Administration.Account WHERE id = $currentUser LIMIT 1
- retrieve over association $AccountCurrent/System.UserRoles

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: Called by Inspection.VAL_Task_Validate.
- Output/UI context: No page output was exported; check L2 JSON if the exact user-facing effect matters.

## Key Entities Touched

- Administration.Account

## Called / Called By

- Calls: none
- Called by: Inspection.VAL_Task_Validate

## Shown Pages

- No ShowPageAction was exported for this flow; it may serve validation, background processing, or delegate work to other flows.

## Important Retrieves/Decisions/Mutations

- nodeId=n002-retrieve; sourceKind=Database; entity=Administration.Account; xPath=id = $currentUser; summary=retrieve from Administration.Account WHERE id = $currentUser LIMIT 1
- nodeId=n003-retrieve; sourceKind=Association; association=$AccountCurrent/System.UserRoles; summary=retrieve over association $AccountCurrent/System.UserRoles

## Warnings/Unknowns

- No material warnings from deterministic export synthesis.

## Source

- Stable JSON: [json](../../../../app-overview/current/modules/Inspection/flows/inspection-ds-userrole-getfromcurrentuser.json)
- Aggregate export: [flows.json](../../../../app-overview/cli_2026-03-18T20-44-56.521Z/modules/Inspection/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../app-overview/cli_2026-03-18T20-44-56.521Z/modules/Inspection/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-18T20-44-56.521Z
