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
sourceRun: cli_2026-03-18T20-54-38.903Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: Inspection.ACT_Registration_Save

## Summary

- Likely acts as a save, process, or background step for Administration.Account, Inspection.Inspector because it mutates data without showing a page.
- L0: [abstract](inspection-act-registration-save.abstract.md)
- L2: [json](../../../../app-overview/current/modules/Inspection/flows/inspection-act-registration-save.json)

## Main Steps

- retrieve from System.UserRole WHERE Name = 'Inspector' LIMIT 1
- retrieve from System.UserRole WHERE Name = 'Manager' LIMIT 1
- $IsValid
- $Registration/Role = Inspection.Enum_Registration_UserRole.Inspector
- create Administration.Account (Name = $Registration/UserName, Password = $Registration/Password, FullName = $Registration/FullName, Email = $Registration/EmailAddress)
- create Inspection.Inspector (Name = $Registration/UserName, Inspector_Account = $NewAccount)

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; this likely starts from UI interaction or navigation.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- Administration.Account, Inspection.Inspector

## Called / Called By

- Calls: Inspection.VAL_Registration_Validate
- Called by: none

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=n007-retrieve; sourceKind=Database; entity=System.UserRole; xPath=Name = 'Inspector'; summary=retrieve from System.UserRole WHERE Name = 'Inspector' LIMIT 1
- nodeId=n010-retrieve; sourceKind=Database; entity=System.UserRole; xPath=Name = 'Manager'; summary=retrieve from System.UserRole WHERE Name = 'Manager' LIMIT 1
- nodeId=n003-decision; caption=IF; expression=$IsValid
- nodeId=n006-decision; caption=IF; expression=$Registration/Role = Inspection.Enum_Registration_UserRole.Inspector
- nodeId=n004-create; actionKind=Create; entity=Administration.Account; members=(Name = $Registration/UserName, Password = $Registration/Password, FullName = $Registration/FullName, Email = $Registration/EmailAddress); summary=create Administration.Account (Name = $Registration/UserName, Password = $Registration/Password, FullName = $Registration/FullName, Email = $Registration/EmailAddress)
- nodeId=n008-create; actionKind=Create; entity=Inspection.Inspector; members=(Name = $Registration/UserName, Inspector_Account = $NewAccount); summary=create Inspection.Inspector (Name = $Registration/UserName, Inspector_Account = $NewAccount)
- nodeId=n009-change; actionKind=Change; entity=System.UserRole; members=System.UserRoles = $UserRole_Inspector; summary=change $NewAccount (System.UserRoles = $UserRole_Inspector)
- nodeId=n011-change; actionKind=Change; entity=System.UserRole; members=System.UserRoles = $UserRole_Manager; summary=change $NewAccount (System.UserRoles = $UserRole_Manager)

## Warnings/Unknowns

- Rollback hint detected in node detail.

## Source

- Stable JSON: [json](../../../../app-overview/current/modules/Inspection/flows/inspection-act-registration-save.json)
- Aggregate export: [flows.json](../../../../app-overview/cli_2026-03-18T20-54-38.903Z/modules/Inspection/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../app-overview/cli_2026-03-18T20-54-38.903Z/modules/Inspection/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-18T20-54-38.903Z
