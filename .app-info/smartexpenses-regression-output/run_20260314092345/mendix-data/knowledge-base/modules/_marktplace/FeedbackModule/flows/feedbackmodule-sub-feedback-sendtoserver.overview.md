---
objectType: flow
module: FeedbackModule
qualifiedName: FeedbackModule.SUB_Feedback_SendToServer
stableId: b274f46b-d997-4a5b-8856-570de6c0bf5c
slug: feedbackmodule-sub-feedback-sendtoserver
layer: L1
l0: feedbackmodule-sub-feedback-sendtoserver.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/FeedbackModule/flows/feedbackmodule-sub-feedback-sendtoserver.json
l2Logical: flow:FeedbackModule.SUB_Feedback_SendToServer
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: FeedbackModule.SUB_Feedback_SendToServer

## Summary

- Likely acts as a save, process, or background step because it mutates data without showing a page.
- L0: [abstract](feedbackmodule-sub-feedback-sendtoserver.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/FeedbackModule/flows/feedbackmodule-sub-feedback-sendtoserver.json)

## Main Steps

- $Feedback/AppID != '1' and $Feedback/AppID != empty and $Feedback/AppID != '' AppId is not empty or 1? expression=$Feedback/AppID != '1' and $Feedback/AppID != empty and $Feedback/AppID != ''
- $Feedback/ImageB64 != empty and $Feedback/ImageB64 != '' Has Screenshot? expression=$Feedback/ImageB64 != empty and $Feedback/ImageB64 != ''
- ChangeObjectAction: change Feedback (ScreenshotName='screenshot-' + formatDateTime([%CurrentDateTime%],'yyyy-MM-dd-HH-mm-ss')+'.'+ toLowerCase(substring($Feedback/ImageB64,find($Feedback/ImageB64, 'data:image/') + 11,3)); refreshInClient=false) change Feedback (ScreenshotName='screenshot-' + formatDateTime([%CurrentDateTime%],'yyyy-MM-dd-HH-mm-ss')+'.'+ toLowerCase(substring($Feedback/ImageB64,find($Feedback/ImageB64, 'data:image/') + 11,3)); refreshInClient=false)

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: Called by FeedbackModule.ACT_SubmitFeedback.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- No entity names were resolved from exported nodes; inspect L2 JSON if exact read/write scope matters.

## Called / Called By

- Calls: FeedbackModule.SUB_Feedback_PostToAppInsights, FeedbackModule.SUB_Feedback_Sanitize
- Called by: FeedbackModule.ACT_SubmitFeedback

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=2881b0d5-e832-460d-98a6-0ea0b72bc40f; caption=AppId is not empty or 1?; expression=$Feedback/AppID != '1' and $Feedback/AppID != empty and $Feedback/AppID != '' AppId is not empty or 1? expression=$Feedback/AppID != '1' and $Feedback/AppID != empty and $Feedback/AppID != ''
- nodeId=36a10077-7d28-4e5a-9ef8-402494d8c718; caption=Has Screenshot?; expression=$Feedback/ImageB64 != empty and $Feedback/ImageB64 != '' Has Screenshot? expression=$Feedback/ImageB64 != empty and $Feedback/ImageB64 != ''
- nodeId=2b1f52ce-2523-4c24-8da9-774e623193ff; actionKind=Change; members=ScreenshotName='screenshot-' + formatDateTime([%CurrentDateTime%],'yyyy-MM-dd-HH-mm-ss'; summary=ChangeObjectAction: change Feedback (ScreenshotName='screenshot-' + formatDateTime([%CurrentDateTime%],'yyyy-MM-dd-HH-mm-ss')+'.'+ toLowerCase(substring($Feedback/ImageB64,find($Feedback/ImageB64, 'data:image/') + 11,3)); refreshInClient=false) change Feedback (ScreenshotName='screenshot-' + formatDateTime([%CurrentDateTime%],'yyyy-MM-dd-HH-mm-ss')+'.'+ toLowerCase(substring($Feedback/ImageB64,find($Feedback/ImageB64, 'data:image/') + 11,3)); refreshInClient=false)

## Warnings/Unknowns

- Rollback hint detected in node detail.
- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/FeedbackModule/flows/feedbackmodule-sub-feedback-sendtoserver.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/FeedbackModule/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/FeedbackModule/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
