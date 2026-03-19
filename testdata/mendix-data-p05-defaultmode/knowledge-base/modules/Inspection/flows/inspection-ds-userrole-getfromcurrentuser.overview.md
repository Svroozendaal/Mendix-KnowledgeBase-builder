---
objectType: flow
module: Inspection
qualifiedName: Inspection.DS_UserRole_GetFromCurrentUser
stableId: f30baa04-ff29-4fbc-8040-32becd095cec
slug: inspection-ds-userrole-getfromcurrentuser
layer: L1
l0: inspection-ds-userrole-getfromcurrentuser.abstract.md
l2Path: ../../../../../mendix-data-p05-legacy/app-overview/current/modules/Inspection/flows/inspection-ds-userrole-getfromcurrentuser.json
l2Logical: flow:Inspection.DS_UserRole_GetFromCurrentUser
sourceRun: cli_2026-03-18T20-44-56.522Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: Inspection.DS_UserRole_GetFromCurrentUser

## Summary

- Likely supplies data to callers or pages rather than driving user navigation directly.
- L0: [abstract](inspection-ds-userrole-getfromcurrentuser.abstract.md)
- L2: [json](../../../../../mendix-data-p05-legacy/app-overview/current/modules/Inspection/flows/inspection-ds-userrole-getfromcurrentuser.json)

## Main Steps

- RetrieveAction: retrieve AccountCurrent from Administration.Account retrieve AccountCurrent from Administration.Account
- RetrieveAction: retrieve UserRoleList over association UserRoles from AccountCurrent retrieve UserRoleList over association UserRoles from AccountCurrent

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

- nodeId=ea4f8ae2-9698-4d3a-be12-12f6a402dac4; sourceKind=Database; entity=Administration.Account; summary=RetrieveAction: retrieve AccountCurrent from Administration.Account retrieve AccountCurrent from Administration.Account
- nodeId=fc9458b6-b7f9-4a20-8b88-181041ed0c1d; sourceKind=Association; association=UserRoles; summary=RetrieveAction: retrieve UserRoleList over association UserRoles from AccountCurrent retrieve UserRoleList over association UserRoles from AccountCurrent

## Warnings/Unknowns

- Rollback hint detected in node detail.

## Source

- Stable JSON: [json](../../../../../mendix-data-p05-legacy/app-overview/current/modules/Inspection/flows/inspection-ds-userrole-getfromcurrentuser.json)
- Aggregate export: [flows.json](../../../../../mendix-data-p05-legacy/app-overview/cli_2026-03-18T20-44-56.522Z/modules/Inspection/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../mendix-data-p05-legacy/app-overview/cli_2026-03-18T20-44-56.522Z/modules/Inspection/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-18T20-44-56.522Z
