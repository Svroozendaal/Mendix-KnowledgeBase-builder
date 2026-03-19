---
objectType: flow
module: Inspection
qualifiedName: Inspection.VAL_Registration_Validate
stableId: c6f60961-a61c-462e-83f5-c3530cfc3414
slug: inspection-val-registration-validate
layer: L1
l0: inspection-val-registration-validate.abstract.md
l2Path: ../../../../../mendix-data-p05-legacy/app-overview/current/modules/Inspection/flows/inspection-val-registration-validate.json
l2Logical: flow:Inspection.VAL_Registration_Validate
sourceRun: cli_2026-03-18T20-44-56.522Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: Inspection.VAL_Registration_Validate

## Summary

- Likely acts as a save, process, or background step because it mutates data without showing a page.
- L0: [abstract](inspection-val-registration-validate.abstract.md)
- L2: [json](../../../../../mendix-data-p05-legacy/app-overview/current/modules/Inspection/flows/inspection-val-registration-validate.json)

## Main Steps

- trim($Registration/UserName) != '' Is User name not empty? expression=trim($Registration/UserName) != ''
- $Registration/Role != empty Is Role not empty? expression=$Registration/Role != empty
- CreateVariableAction: create variable IsValid=true create variable IsValid=true
- ChangeVariableAction: change variable IsValid=false change variable IsValid=false

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: Called by Inspection.ACT_Registration_Save.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- No entity names were resolved from exported nodes; inspect L2 JSON if exact read/write scope matters.

## Called / Called By

- Calls: none
- Called by: Inspection.ACT_Registration_Save

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=00c0f200-73b7-4da2-8a15-907d8a322210; caption=Is User name not empty?; expression=trim($Registration/UserName) != '' Is User name not empty? expression=trim($Registration/UserName) != ''
- nodeId=318bcabd-63df-4f4f-bde4-46ed1262b89d; caption=Is Role not empty?; expression=$Registration/Role != empty Is Role not empty? expression=$Registration/Role != empty
- nodeId=4a764e82-032c-46aa-9333-54cb6a6298e6; caption=Is full name not empty?; expression=trim($Registration/FullName) != '' Is full name not empty? expression=trim($Registration/FullName) != ''
- nodeId=4cd839f2-cad8-4ba7-b395-fbe8252a0e74; caption=Is Password not empty?; expression=trim($Registration/Password) != '' Is Password not empty? expression=trim($Registration/Password) != ''
- nodeId=6567cbc5-88bc-4f66-9b23-4e19214d8615; caption=do passwords match?; expression=$Registration/Password = $Registration/ConfirmPassword do passwords match? expression=$Registration/Password = $Registration/ConfirmPassword
- nodeId=c8e41150-3b16-4054-b520-bb4875e2a797; caption=Is email address not empty?; expression=trim($Registration/EmailAddress) != '' Is email address not empty? expression=trim($Registration/EmailAddress) != ''
- nodeId=19729fe5-6df0-4a05-8705-06105249d724; actionKind=Create; summary=CreateVariableAction: create variable IsValid=true create variable IsValid=true
- nodeId=1a6f016f-e441-465d-9b79-4d37281c6287; actionKind=Change; summary=ChangeVariableAction: change variable IsValid=false change variable IsValid=false

## Warnings/Unknowns

- Rollback hint detected in node detail.
- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../mendix-data-p05-legacy/app-overview/current/modules/Inspection/flows/inspection-val-registration-validate.json)
- Aggregate export: [flows.json](../../../../../mendix-data-p05-legacy/app-overview/cli_2026-03-18T20-44-56.522Z/modules/Inspection/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../mendix-data-p05-legacy/app-overview/cli_2026-03-18T20-44-56.522Z/modules/Inspection/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-18T20-44-56.522Z
