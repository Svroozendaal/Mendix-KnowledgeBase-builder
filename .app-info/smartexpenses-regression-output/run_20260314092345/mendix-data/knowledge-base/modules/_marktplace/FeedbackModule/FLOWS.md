# Flows: FeedbackModule

## Flow Catalogue

### Action Flows (ACT_*)

| Flow | Nodes | Key Actions | Pages Shown |
|---|---:|---|---|
| ACT_Feedback_ClearForm | 5 | none | none |
| ACT_Feedback_ClearImage | 5 | none | none |
| ACT_Feedback_TriggerScreenshotMode | 14 | none | FeedbackModule.ShareFeedback |
| ACT_Feedback_UploadImage | 26 | none | FeedbackModule.ShareFeedback |
| ACT_SubmitFeedback | 14 | none | FeedbackModule.PopupFailure, FeedbackModule.PopupSuccess |

### Data Sources (DS_*)

| Flow | Nodes | Key Actions | Returns |
|---|---:|---|---|
| DS_Feedback_Populate | 7 | none | inferred from node actions |

### Validation Flows (VAL_*)

| Flow | Nodes | Key Actions |
|---|---:|---|
| VAL_Feedback | 29 | none |

### Other Flows

| Flow | Type | Nodes | Key Actions |
|---|---|---:|---|
| ConvertBase64String | Microflow | 7 | none |
| ConvertUUIDToURL | Microflow | 4 | none |
| OCH_Feedback_SaveToLocalStorage | Nanoflow | 4 | none |
| PopulateUserAttributes | Microflow | 6 | System.User |
| SUB_Feedback_GetOrCreate | Nanoflow | 8 | FeedbackModule.Feedback |
| SUB_Feedback_PostToAppInsights | Microflow | 8 | none |
| SUB_Feedback_ResetLocalStorage | Nanoflow | 6 | none |
| SUB_Feedback_Sanitize | Microflow | 14 | none |
| SUB_Feedback_SendToServer | Microflow | 15 | none |

## Cross-Module Calls

| Flow | Calls | Target Module |
|---|---|---|
| none | none | none |

## Tier 1 Shortlist

| Flow | Shown Pages | Entities |
|---|---|---|
| none | none | none |

## Flow Details

| Flow | Kind | Nodes | Tier | Calls Out | Called By |
|---|---|---:|---:|---:|---:|
| ACT_Feedback_ClearForm | Nanoflow | 5 | 3 | 0 | 0 |
| ACT_Feedback_ClearImage | Nanoflow | 5 | 3 | 0 | 0 |
| ACT_Feedback_TriggerScreenshotMode | Nanoflow | 14 | 3 | 0 | 0 |
| ACT_Feedback_UploadImage | Nanoflow | 26 | 3 | 0 | 0 |
| ACT_SubmitFeedback | Nanoflow | 14 | 3 | 3 | 0 |
| ConvertBase64String | Microflow | 7 | 3 | 0 | 0 |
| ConvertUUIDToURL | Microflow | 4 | 3 | 0 | 0 |
| DS_Feedback_Populate | Nanoflow | 7 | 3 | 2 | 0 |
| OCH_Feedback_SaveToLocalStorage | Nanoflow | 4 | 3 | 0 | 0 |
| PopulateUserAttributes | Microflow | 6 | 3 | 0 | 1 |
| SUB_Feedback_GetOrCreate | Nanoflow | 8 | 3 | 0 | 1 |
| SUB_Feedback_PostToAppInsights | Microflow | 8 | 3 | 0 | 1 |
| SUB_Feedback_ResetLocalStorage | Nanoflow | 6 | 3 | 0 | 1 |
| SUB_Feedback_Sanitize | Microflow | 14 | 3 | 0 | 1 |
| SUB_Feedback_SendToServer | Microflow | 15 | 3 | 2 | 1 |
| VAL_Feedback | Microflow | 29 | 3 | 0 | 1 |

## Tier 1 Deep Narratives

Tier 1 deep narratives are only generated for custom modules; use the flow catalogue and L0/L1 flow files for this module.

## Flow Links

| Flow | Type | Tier | L0 | L1 | L2 |
|---|---|---:|---|---|---|
| FeedbackModule.ACT_Feedback_ClearForm | Nanoflow | 3 | [L0](flows/feedbackmodule-act-feedback-clearform.abstract.md) | [L1](flows/feedbackmodule-act-feedback-clearform.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/FeedbackModule/flows/feedbackmodule-act-feedback-clearform.json) |
| FeedbackModule.ACT_Feedback_ClearImage | Nanoflow | 3 | [L0](flows/feedbackmodule-act-feedback-clearimage.abstract.md) | [L1](flows/feedbackmodule-act-feedback-clearimage.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/FeedbackModule/flows/feedbackmodule-act-feedback-clearimage.json) |
| FeedbackModule.ACT_Feedback_TriggerScreenshotMode | Nanoflow | 3 | [L0](flows/feedbackmodule-act-feedback-triggerscreenshotmode.abstract.md) | [L1](flows/feedbackmodule-act-feedback-triggerscreenshotmode.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/FeedbackModule/flows/feedbackmodule-act-feedback-triggerscreenshotmode.json) |
| FeedbackModule.ACT_Feedback_UploadImage | Nanoflow | 3 | [L0](flows/feedbackmodule-act-feedback-uploadimage.abstract.md) | [L1](flows/feedbackmodule-act-feedback-uploadimage.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/FeedbackModule/flows/feedbackmodule-act-feedback-uploadimage.json) |
| FeedbackModule.ACT_SubmitFeedback | Nanoflow | 3 | [L0](flows/feedbackmodule-act-submitfeedback.abstract.md) | [L1](flows/feedbackmodule-act-submitfeedback.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/FeedbackModule/flows/feedbackmodule-act-submitfeedback.json) |
| FeedbackModule.ConvertBase64String | Microflow | 3 | [L0](flows/feedbackmodule-convertbase64string.abstract.md) | [L1](flows/feedbackmodule-convertbase64string.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/FeedbackModule/flows/feedbackmodule-convertbase64string.json) |
| FeedbackModule.ConvertUUIDToURL | Microflow | 3 | [L0](flows/feedbackmodule-convertuuidtourl.abstract.md) | [L1](flows/feedbackmodule-convertuuidtourl.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/FeedbackModule/flows/feedbackmodule-convertuuidtourl.json) |
| FeedbackModule.DS_Feedback_Populate | Nanoflow | 3 | [L0](flows/feedbackmodule-ds-feedback-populate.abstract.md) | [L1](flows/feedbackmodule-ds-feedback-populate.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/FeedbackModule/flows/feedbackmodule-ds-feedback-populate.json) |
| FeedbackModule.OCH_Feedback_SaveToLocalStorage | Nanoflow | 3 | [L0](flows/feedbackmodule-och-feedback-savetolocalstorage.abstract.md) | [L1](flows/feedbackmodule-och-feedback-savetolocalstorage.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/FeedbackModule/flows/feedbackmodule-och-feedback-savetolocalstorage.json) |
| FeedbackModule.PopulateUserAttributes | Microflow | 3 | [L0](flows/feedbackmodule-populateuserattributes.abstract.md) | [L1](flows/feedbackmodule-populateuserattributes.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/FeedbackModule/flows/feedbackmodule-populateuserattributes.json) |
| FeedbackModule.SUB_Feedback_GetOrCreate | Nanoflow | 3 | [L0](flows/feedbackmodule-sub-feedback-getorcreate.abstract.md) | [L1](flows/feedbackmodule-sub-feedback-getorcreate.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/FeedbackModule/flows/feedbackmodule-sub-feedback-getorcreate.json) |
| FeedbackModule.SUB_Feedback_PostToAppInsights | Microflow | 3 | [L0](flows/feedbackmodule-sub-feedback-posttoappinsights.abstract.md) | [L1](flows/feedbackmodule-sub-feedback-posttoappinsights.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/FeedbackModule/flows/feedbackmodule-sub-feedback-posttoappinsights.json) |
| FeedbackModule.SUB_Feedback_ResetLocalStorage | Nanoflow | 3 | [L0](flows/feedbackmodule-sub-feedback-resetlocalstorage.abstract.md) | [L1](flows/feedbackmodule-sub-feedback-resetlocalstorage.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/FeedbackModule/flows/feedbackmodule-sub-feedback-resetlocalstorage.json) |
| FeedbackModule.SUB_Feedback_Sanitize | Microflow | 3 | [L0](flows/feedbackmodule-sub-feedback-sanitize.abstract.md) | [L1](flows/feedbackmodule-sub-feedback-sanitize.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/FeedbackModule/flows/feedbackmodule-sub-feedback-sanitize.json) |
| FeedbackModule.SUB_Feedback_SendToServer | Microflow | 3 | [L0](flows/feedbackmodule-sub-feedback-sendtoserver.abstract.md) | [L1](flows/feedbackmodule-sub-feedback-sendtoserver.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/FeedbackModule/flows/feedbackmodule-sub-feedback-sendtoserver.json) |
| FeedbackModule.VAL_Feedback | Microflow | 3 | [L0](flows/feedbackmodule-val-feedback.abstract.md) | [L1](flows/feedbackmodule-val-feedback.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/FeedbackModule/flows/feedbackmodule-val-feedback.json) |
