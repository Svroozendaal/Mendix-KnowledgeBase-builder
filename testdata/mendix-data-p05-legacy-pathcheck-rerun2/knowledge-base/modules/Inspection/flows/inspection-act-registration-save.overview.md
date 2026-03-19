---
objectType: flow
module: Inspection
qualifiedName: Inspection.ACT_Registration_Save
stableId: fc8368f4-f101-4670-b2c7-7f227e771641
slug: inspection-act-registration-save
layer: L1
l0: inspection-act-registration-save.abstract.md
l2Path: ../../../../app-overview/current/modules/Inspection/flows/inspection-act-registration-save.json
l2Logical: flow:Inspection.ACT_Registration_Save
sourceRun: cli_2026-03-18T20-56-46.385Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: Inspection.ACT_Registration_Save

## Summary

- Likely acts as a save, process, or background step for Administration.Account, Inspection.Inspector, System.UserRole because it mutates data without showing a page.
- L0: [abstract](inspection-act-registration-save.abstract.md)
- L2: [json](../../../../app-overview/current/modules/Inspection/flows/inspection-act-registration-save.json)

## Main Steps

- RetrieveAction: retrieve UserRole_Manager from System.UserRole retrieve UserRole_Manager from System.UserRole
- RetrieveAction: retrieve UserRole_Inspector from System.UserRole retrieve UserRole_Inspector from System.UserRole
- $Registration/Role = Inspection.Enum_Registration_UserRole.Inspector is inspector? expression=$Registration/Role = Inspection.Enum_Registration_UserRole.Inspector
- $IsValid valid? expression=$IsValid
- ChangeObjectAction: change NewAccount (UserRoles=$UserRole_Inspector; refreshInClient=false) change NewAccount (UserRoles=$UserRole_Inspector; refreshInClient=false)
- CreateObjectAction: create Administration.Account as NewAccount (Name=$Registration/UserName, Password=$Registration/Password, FullName=$Registration/FullName, Email=$Registration/EmailAddress) create Administration.Acco...

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; this likely starts from UI interaction or navigation.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- Administration.Account, Inspection.Inspector, System.UserRole

## Called / Called By

- Calls: Inspection.VAL_Registration_Validate
- Called by: none

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=81182cf0-de5c-4d8f-ac5b-526e28bba993; sourceKind=Database; entity=System.UserRole; summary=RetrieveAction: retrieve UserRole_Manager from System.UserRole retrieve UserRole_Manager from System.UserRole
- nodeId=8d46f91c-4fcc-414e-8d49-4f168f491ae8; sourceKind=Database; entity=System.UserRole; summary=RetrieveAction: retrieve UserRole_Inspector from System.UserRole retrieve UserRole_Inspector from System.UserRole
- nodeId=5bb64925-f788-4970-8d48-e3309724454c; caption=is inspector?; expression=$Registration/Role = Inspection.Enum_Registration_UserRole.Inspector is inspector? expression=$Registration/Role = Inspection.Enum_Registration_UserRole.Inspector
- nodeId=65a57993-e299-4d3d-b635-4033b6c7ebfe; caption=valid?; expression=$IsValid valid? expression=$IsValid
- nodeId=52898dcc-bb51-498f-b8db-95d2373c2ec0; actionKind=Change; members=UserRoles=$UserRole_Inspector; refreshInClient=false; summary=ChangeObjectAction: change NewAccount (UserRoles=$UserRole_Inspector; refreshInClient=false) change NewAccount (UserRoles=$UserRole_Inspector; refreshInClient=false)
- nodeId=64e17ceb-1b7d-4ee5-8299-7fc42ae6fdfe; actionKind=Create; entity=Administration.Account; members=Name=$Registration/UserName, Password=$Registration/Password, FullName=$Registration/FullName, Email=$Registration/EmailAddress; summary=CreateObjectAction: create Administration.Account as NewAccount (Name=$Registration/UserName, Password=$Registration/Password, FullName=$Registration/FullName, Email=$Registration/EmailAddress) create Administration.Acco...
- nodeId=868f0c7c-d4cd-40d4-985a-fd92763d4d49; actionKind=Create; entity=Inspection.Inspector; members=Name=$Registration/UserName, Inspector_Account=$NewAccount; summary=CreateObjectAction: create Inspection.Inspector as NewInspector (Name=$Registration/UserName, Inspector_Account=$NewAccount) create Inspection.Inspector as NewInspector (Name=$Registration/UserName, Inspector_Account=$Ne...
- nodeId=f2f9af30-27c9-4fd1-abf1-a10878d5b18a; actionKind=Change; members=UserRoles=$UserRole_Manager; refreshInClient=false; summary=ChangeObjectAction: change NewAccount (UserRoles=$UserRole_Manager; refreshInClient=false) change NewAccount (UserRoles=$UserRole_Manager; refreshInClient=false)

## Warnings/Unknowns

- No material warnings from deterministic export synthesis.

## Source

- Stable JSON: [json](../../../../app-overview/current/modules/Inspection/flows/inspection-act-registration-save.json)
- Aggregate export: [flows.json](../../../../app-overview/cli_2026-03-18T20-56-46.385Z/modules/Inspection/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../app-overview/cli_2026-03-18T20-56-46.385Z/modules/Inspection/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-18T20-56-46.385Z
