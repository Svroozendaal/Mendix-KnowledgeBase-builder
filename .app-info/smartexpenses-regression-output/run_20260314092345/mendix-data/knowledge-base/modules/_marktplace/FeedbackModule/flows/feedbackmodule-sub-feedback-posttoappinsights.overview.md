---
objectType: flow
module: FeedbackModule
qualifiedName: FeedbackModule.SUB_Feedback_PostToAppInsights
stableId: b0c18557-2a2b-4b53-92ba-272ffd8010a7
slug: feedbackmodule-sub-feedback-posttoappinsights
layer: L1
l0: feedbackmodule-sub-feedback-posttoappinsights.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/FeedbackModule/flows/feedbackmodule-sub-feedback-posttoappinsights.json
l2Logical: flow:FeedbackModule.SUB_Feedback_PostToAppInsights
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: FeedbackModule.SUB_Feedback_PostToAppInsights

## Summary

- Likely acts as a save, process, or background step because it mutates data without showing a page.
- L0: [abstract](feedbackmodule-sub-feedback-posttoappinsights.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/FeedbackModule/flows/feedbackmodule-sub-feedback-posttoappinsights.json)

## Main Steps

- CreateVariableAction: create variable ServerLocation='https://feedback-api.mendix.com/v2/feedback-items' create variable ServerLocation='https://feedback-api.mendix.com/v2/feedback-items'

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: Called by FeedbackModule.SUB_Feedback_SendToServer.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- No entity names were resolved from exported nodes; inspect L2 JSON if exact read/write scope matters.

## Called / Called By

- Calls: none
- Called by: FeedbackModule.SUB_Feedback_SendToServer

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=e88c7409-fd67-4bb1-b6a6-2b261de9d774; actionKind=Create; entity=api.mendix; summary=CreateVariableAction: create variable ServerLocation='https://feedback-api.mendix.com/v2/feedback-items' create variable ServerLocation='https://feedback-api.mendix.com/v2/feedback-items'

## Warnings/Unknowns

- Rollback hint detected in node detail.
- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/FeedbackModule/flows/feedbackmodule-sub-feedback-posttoappinsights.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/FeedbackModule/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/FeedbackModule/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
