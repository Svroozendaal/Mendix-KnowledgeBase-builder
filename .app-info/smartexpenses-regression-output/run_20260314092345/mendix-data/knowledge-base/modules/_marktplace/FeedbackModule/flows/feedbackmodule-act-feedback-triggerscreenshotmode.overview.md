---
objectType: flow
module: FeedbackModule
qualifiedName: FeedbackModule.ACT_Feedback_TriggerScreenshotMode
stableId: 538dc61b-b86a-4771-bd4e-ba598d0e0be1
slug: feedbackmodule-act-feedback-triggerscreenshotmode
layer: L1
l0: feedbackmodule-act-feedback-triggerscreenshotmode.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/FeedbackModule/flows/feedbackmodule-act-feedback-triggerscreenshotmode.json
l2Logical: flow:FeedbackModule.ACT_Feedback_TriggerScreenshotMode
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: FeedbackModule.ACT_Feedback_TriggerScreenshotMode

## Summary

- Likely acts as a UI entry or navigation handler because it shows FeedbackModule.ShareFeedback.
- L0: [abstract](feedbackmodule-act-feedback-triggerscreenshotmode.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/FeedbackModule/flows/feedbackmodule-act-feedback-triggerscreenshotmode.json)

## Main Steps

- $base64FromWidget != empty is not Empty? expression=$base64FromWidget != empty
- $base64FromWidget != 'uploadCancelled' Upload Not Cancelled? expression=$base64FromWidget != 'uploadCancelled'
- ShowPageAction: show page FeedbackModule.ShareFeedback show page FeedbackModule.ShareFeedback
- ChangeObjectAction: change Feedback (ImageB64=$base64FromWidget; refreshInClient=true) change Feedback (ImageB64=$base64FromWidget; refreshInClient=true)

## Trigger/Input/Output Context

- Kind: Nanoflow
- Entry/call context: No inbound caller was exported; this likely starts from UI interaction or navigation.
- Output/UI context: Shows FeedbackModule.ShareFeedback.

## Key Entities Touched

- No entity names were resolved from exported nodes; inspect L2 JSON if exact read/write scope matters.

## Called / Called By

- Calls: none
- Called by: none

## Shown Pages

- FeedbackModule.ShareFeedback

## Important Retrieves/Decisions/Mutations

- nodeId=02a922e5-5b66-4c33-8149-43453e9210c2; caption=is not Empty?; expression=$base64FromWidget != empty is not Empty? expression=$base64FromWidget != empty
- nodeId=26bc1bc9-ca58-423a-b729-6f3ef6e2eae7; caption=Upload Not Cancelled?; expression=$base64FromWidget != 'uploadCancelled' Upload Not Cancelled? expression=$base64FromWidget != 'uploadCancelled'
- nodeId=2efffb57-4f3a-47a8-8c76-cebcc984876d; actionKind=Change; members=ImageB64=$base64FromWidget; refreshInClient=true; summary=ChangeObjectAction: change Feedback (ImageB64=$base64FromWidget; refreshInClient=true) change Feedback (ImageB64=$base64FromWidget; refreshInClient=true)

## Warnings/Unknowns

- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/FeedbackModule/flows/feedbackmodule-act-feedback-triggerscreenshotmode.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/FeedbackModule/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/FeedbackModule/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
