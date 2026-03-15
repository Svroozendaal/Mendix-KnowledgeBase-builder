---
objectType: flow
module: FeedbackModule
qualifiedName: FeedbackModule.PopulateUserAttributes
stableId: fcb24873-eb91-4027-bbe1-20a1777fc351
slug: feedbackmodule-populateuserattributes
layer: L1
l0: feedbackmodule-populateuserattributes.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/FeedbackModule/flows/feedbackmodule-populateuserattributes.json
l2Logical: flow:FeedbackModule.PopulateUserAttributes
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: FeedbackModule.PopulateUserAttributes

## Summary

- Likely acts as a save, process, or background step for System.User because it mutates data without showing a page.
- L0: [abstract](feedbackmodule-populateuserattributes.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/FeedbackModule/flows/feedbackmodule-populateuserattributes.json)

## Main Steps

- retrieve CurrentUser from System.User
- Change this retrieve the current user in your app and use the action next to it to populate submitter attributes of the feedback. This will indicate the submitt...
- ChangeObjectAction: change Feedback (SubmitterUUID=$currentUser/Name, SubmitterDisplayName=$CurrentUser/Name; refreshInClient=false) change Feedback (SubmitterUUID=$currentUser/Name, SubmitterDisplayName=$CurrentUser/Name; refreshInClient=false)

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: Called by FeedbackModule.DS_Feedback_Populate.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- System.User

## Called / Called By

- Calls: none
- Called by: FeedbackModule.DS_Feedback_Populate

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=cfa507c4-5571-46a8-b3e7-3981c8ff0899; sourceKind=Database; entity=System.User; summary=retrieve CurrentUser from System.User
- nodeId=b109f895-4dde-47f1-a448-643c8724840d; sourceKind=Unknown; summary=Change this retrieve the current user in your app and use the action next to it to populate submitter attributes of the feedback. This will indicate the submitt...
- nodeId=805365c2-38ff-439d-aeee-754693f9fa3c; actionKind=Change; members=SubmitterUUID=$currentUser/Name, SubmitterDisplayName=$CurrentUser/Name; refreshInClient=false; summary=ChangeObjectAction: change Feedback (SubmitterUUID=$currentUser/Name, SubmitterDisplayName=$CurrentUser/Name; refreshInClient=false) change Feedback (SubmitterUUID=$currentUser/Name, SubmitterDisplayName=$CurrentUser/Name; refreshInClient=false)
- nodeId=b109f895-4dde-47f1-a448-643c8724840d; actionKind=Change; summary=Change this retrieve the current user in your app and use the action next to it to populate submitter attributes of the feedback. This will indicate the submitt...

## Warnings/Unknowns

- No material warnings from deterministic export synthesis.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/FeedbackModule/flows/feedbackmodule-populateuserattributes.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/FeedbackModule/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/FeedbackModule/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
