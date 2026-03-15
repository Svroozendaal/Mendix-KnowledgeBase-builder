---
objectType: flow
module: FeedbackModule
qualifiedName: FeedbackModule.VAL_Feedback
stableId: 3db96c8b-1465-4429-9915-562dbbc77d07
slug: feedbackmodule-val-feedback
layer: L1
l0: feedbackmodule-val-feedback.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/FeedbackModule/flows/feedbackmodule-val-feedback.json
l2Logical: flow:FeedbackModule.VAL_Feedback
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: FeedbackModule.VAL_Feedback

## Summary

- Likely acts as a save, process, or background step because it mutates data without showing a page.
- L0: [abstract](feedbackmodule-val-feedback.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/FeedbackModule/flows/feedbackmodule-val-feedback.json)

## Main Steps

- length(trim($Feedback/Description)) <= 32000 Description < 32000 characters? expression=length(trim($Feedback/Description)) <= 32000
- $IsValidEmail Email is Valid? expression=$IsValidEmail
- ChangeVariableAction: change variable ValidFeedback=false change variable ValidFeedback=false

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: Called by FeedbackModule.ACT_SubmitFeedback.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- No entity names were resolved from exported nodes; inspect L2 JSON if exact read/write scope matters.

## Called / Called By

- Calls: none
- Called by: FeedbackModule.ACT_SubmitFeedback

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=9164b3aa-fe60-48d9-b2bc-3dd1fe609290; caption=Description < 32000 characters?; expression=length(trim($Feedback/Description)) <= 32000 Description < 32000 characters? expression=length(trim($Feedback/Description)) <= 32000
- nodeId=5abe08fe-bbf0-4eaa-ac0b-63597b683233; caption=Email is Valid?; expression=$IsValidEmail Email is Valid? expression=$IsValidEmail
- nodeId=0ba96493-4316-4d3c-9203-d9928fb8069b; caption=Email not empty?; expression=$Feedback/SubmitterEmail != empty and $Feedback/SubmitterEmail != '' Email not empty? expression=$Feedback/SubmitterEmail != empty and $Feedback/SubmitterEmail != ''
- nodeId=aefd707c-d13c-4946-ab1c-1bd27836fed3; caption=Subject < 200 characters; expression=length(trim($Feedback/Subject)) <= 200 Subject < 200 characters expression=length(trim($Feedback/Subject)) <= 200
- nodeId=e962ea51-7670-48be-9f8b-045016d57cf1; caption=Subject not empty?; expression=trim($Feedback/Subject) != empty and trim($Feedback/Subject) != '' Subject not empty? expression=trim($Feedback/Subject) != empty and trim($Feedback/Subject) != ''
- nodeId=4bd7b389-2fd1-4f7b-9c30-fb87acbd1a81; actionKind=Change; summary=ChangeVariableAction: change variable ValidFeedback=false change variable ValidFeedback=false
- nodeId=64da5dec-4aaf-46cf-9795-927273fa1103; actionKind=Change; summary=ChangeVariableAction: change variable ValidFeedback=false change variable ValidFeedback=false
- nodeId=f635a638-7352-4463-82da-4bae298a1d30; actionKind=Change; summary=ChangeVariableAction: change variable ValidFeedback=false change variable ValidFeedback=false

## Warnings/Unknowns

- Rollback hint detected in node detail.
- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/FeedbackModule/flows/feedbackmodule-val-feedback.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/FeedbackModule/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/FeedbackModule/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
