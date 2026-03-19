---
objectType: flow
module: Inspection
qualifiedName: Inspection.VAL_Registration_Validate
stableId: c6f60961-a61c-462e-83f5-c3530cfc3414
slug: inspection-val-registration-validate
layer: L1
l0: inspection-val-registration-validate.abstract.md
l2Path: ../../../../app-overview/current/modules/Inspection/flows/inspection-val-registration-validate.json
l2Logical: flow:Inspection.VAL_Registration_Validate
sourceRun: cli_2026-03-18T20-54-38.903Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: Inspection.VAL_Registration_Validate

## Summary

- Likely serves as a helper flow invoked from Inspection.ACT_Registration_Save.
- L0: [abstract](inspection-val-registration-validate.abstract.md)
- L2: [json](../../../../app-overview/current/modules/Inspection/flows/inspection-val-registration-validate.json)

## Main Steps

- trim($Registration/FullName) != ''
- trim($Registration/EmailAddress) != ''

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: Called by Inspection.ACT_Registration_Save.
- Output/UI context: No page output was exported; check L2 JSON if the exact user-facing effect matters.

## Key Entities Touched

- No entity names were resolved from exported nodes; inspect L2 JSON if exact read/write scope matters.

## Called / Called By

- Calls: none
- Called by: Inspection.ACT_Registration_Save

## Shown Pages

- No ShowPageAction was exported for this flow; it may serve validation, background processing, or delegate work to other flows.

## Important Retrieves/Decisions/Mutations

- nodeId=n003-decision; caption=IF; expression=trim($Registration/FullName) != ''
- nodeId=n006-decision; caption=IF; expression=trim($Registration/EmailAddress) != ''
- nodeId=n007-decision; caption=IF; expression=trim($Registration/UserName) != ''
- nodeId=n012-decision; caption=IF; expression=trim($Registration/Password) != ''
- nodeId=n015-decision; caption=IF; expression=$Registration/Role != empty
- nodeId=n018-decision; caption=IF; expression=$Registration/Password = $Registration/ConfirmPassword

## Warnings/Unknowns

- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../app-overview/current/modules/Inspection/flows/inspection-val-registration-validate.json)
- Aggregate export: [flows.json](../../../../app-overview/cli_2026-03-18T20-54-38.903Z/modules/Inspection/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../app-overview/cli_2026-03-18T20-54-38.903Z/modules/Inspection/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-18T20-54-38.903Z
