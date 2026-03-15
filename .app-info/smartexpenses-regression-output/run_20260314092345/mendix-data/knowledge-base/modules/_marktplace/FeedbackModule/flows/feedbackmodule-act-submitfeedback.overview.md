---
objectType: flow
module: FeedbackModule
qualifiedName: FeedbackModule.ACT_SubmitFeedback
stableId: 9aaafa68-970a-4863-8dd7-4007f681f7d2
slug: feedbackmodule-act-submitfeedback
layer: L1
l0: feedbackmodule-act-submitfeedback.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/FeedbackModule/flows/feedbackmodule-act-submitfeedback.json
l2Logical: flow:FeedbackModule.ACT_SubmitFeedback
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: FeedbackModule.ACT_SubmitFeedback

## Summary

- Likely acts as a UI entry or navigation handler because it shows FeedbackModule.PopupFailure, FeedbackModule.PopupSuccess.
- L0: [abstract](feedbackmodule-act-submitfeedback.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/FeedbackModule/flows/feedbackmodule-act-submitfeedback.json)

## Main Steps

- $isValid Feedback form Valid? expression=$isValid
- $ResponseHelper != empty is Success? expression=$ResponseHelper != empty
- ShowPageAction: show page FeedbackModule.PopupFailure show page FeedbackModule.PopupFailure

## Trigger/Input/Output Context

- Kind: Nanoflow
- Entry/call context: No inbound caller was exported; this likely starts from UI interaction or navigation.
- Output/UI context: Shows FeedbackModule.PopupFailure, FeedbackModule.PopupSuccess.

## Key Entities Touched

- No entity names were resolved from exported nodes; inspect L2 JSON if exact read/write scope matters.

## Called / Called By

- Calls: FeedbackModule.SUB_Feedback_ResetLocalStorage, FeedbackModule.SUB_Feedback_SendToServer, FeedbackModule.VAL_Feedback
- Called by: none

## Shown Pages

- FeedbackModule.PopupFailure, FeedbackModule.PopupSuccess

## Important Retrieves/Decisions/Mutations

- nodeId=749ae0f8-0b48-45ce-b140-e69c6643c931; caption=Feedback form Valid?; expression=$isValid Feedback form Valid? expression=$isValid
- nodeId=de6dcdde-952c-45e0-a103-d025d3510c8f; caption=is Success?; expression=$ResponseHelper != empty is Success? expression=$ResponseHelper != empty

## Warnings/Unknowns

- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/FeedbackModule/flows/feedbackmodule-act-submitfeedback.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/FeedbackModule/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/FeedbackModule/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
