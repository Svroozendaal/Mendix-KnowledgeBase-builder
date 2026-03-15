---
objectType: flow
module: FeedbackModule
qualifiedName: FeedbackModule.ACT_Feedback_UploadImage
stableId: 6b71382e-7bb9-4ea2-8d88-46322e09f187
slug: feedbackmodule-act-feedback-uploadimage
layer: L1
l0: feedbackmodule-act-feedback-uploadimage.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/FeedbackModule/flows/feedbackmodule-act-feedback-uploadimage.json
l2Logical: flow:FeedbackModule.ACT_Feedback_UploadImage
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: FeedbackModule.ACT_Feedback_UploadImage

## Summary

- Likely acts as a UI entry or navigation handler because it shows FeedbackModule.ShareFeedback.
- L0: [abstract](feedbackmodule-act-feedback-uploadimage.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/FeedbackModule/flows/feedbackmodule-act-feedback-uploadimage.json)

## Main Steps

- $fileBlobURL != 'fileTypeNotAccepted' Correct File Type? expression=$fileBlobURL != 'fileTypeNotAccepted'
- $fileBlobURL != 'fileSizeNotAccepted' Correct Upload Size? expression=$fileBlobURL != 'fileSizeNotAccepted'
- ShowPageAction: show page FeedbackModule.ShareFeedback show page FeedbackModule.ShareFeedback
- ChangeObjectAction: change Feedback (ImageB64=$base64ImageFromWidget; refreshInClient=true) change Feedback (ImageB64=$base64ImageFromWidget; refreshInClient=true)
- CreateVariableAction: create variable fileUploadSize=5 create variable fileUploadSize=5

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

- nodeId=644cc808-03b4-4bcb-be81-ea6c497bb8aa; caption=Correct File Type?; expression=$fileBlobURL != 'fileTypeNotAccepted' Correct File Type? expression=$fileBlobURL != 'fileTypeNotAccepted'
- nodeId=f8eee8be-d64b-4ae2-a6b7-3479726a50cf; caption=Correct Upload Size?; expression=$fileBlobURL != 'fileSizeNotAccepted' Correct Upload Size? expression=$fileBlobURL != 'fileSizeNotAccepted'
- nodeId=e210c13c-c388-47d2-a4c3-ac1492b65917; caption=Upload Not Cancelled?; expression=$fileBlobURL != 'uploadCancelled' Upload Not Cancelled? expression=$fileBlobURL != 'uploadCancelled'
- nodeId=2e0b5f9a-d57a-42ec-8898-5dd9e59cea4f; caption=Uploaded Image?; expression=$fileBlobURL != empty Uploaded Image? expression=$fileBlobURL != empty
- nodeId=f4f90115-b1af-4526-9dbc-194c43a1ed93; actionKind=Change; members=ImageB64=$base64ImageFromWidget; refreshInClient=true; summary=ChangeObjectAction: change Feedback (ImageB64=$base64ImageFromWidget; refreshInClient=true) change Feedback (ImageB64=$base64ImageFromWidget; refreshInClient=true)
- nodeId=3a2e260a-4699-41af-aa27-6bfbc97d1ddc; actionKind=Create; summary=CreateVariableAction: create variable fileUploadSize=5 create variable fileUploadSize=5
- nodeId=6490e63b-1c63-4376-af1d-826a23f94dc6; actionKind=Create; summary=CreateVariableAction: create variable mimeTypes='.gif,.png,.jpg,.jpeg' create variable mimeTypes='.gif,.png,.jpg,.jpeg'

## Warnings/Unknowns

- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/FeedbackModule/flows/feedbackmodule-act-feedback-uploadimage.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/FeedbackModule/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/FeedbackModule/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
