# Pages: FeedbackModule

## Page Inventory

| Page | Title | Allowed roles | Parameters | Popup |
|---|---|---|---|---|
| FeedbackModule.PopupFailure | Something went wrong | FeedbackModule.User | none | True |
| FeedbackModule.PopupFailure_Logo | Something went wrong | FeedbackModule.User | none | True |
| FeedbackModule.PopupSuccess | Feedback Submitted | FeedbackModule.User | Response:FeedbackModule.ResponseHelper | True |
| FeedbackModule.PopupSuccess_Logo | Feedback Submitted | FeedbackModule.User | Response:FeedbackModule.ResponseHelper | True |
| FeedbackModule.ShareFeedback | Share your feedback | FeedbackModule.User | none | True |
| FeedbackModule.ShareFeedback_Logo | Share your feedback | FeedbackModule.User | none | True |

## Page-Flow Links

| Page | Shown by flows |
|---|---|
| FeedbackModule.PopupFailure | FeedbackModule.ACT_SubmitFeedback |
| FeedbackModule.PopupFailure_Logo | none |
| FeedbackModule.PopupSuccess | FeedbackModule.ACT_SubmitFeedback |
| FeedbackModule.PopupSuccess_Logo | none |
| FeedbackModule.ShareFeedback | FeedbackModule.ACT_Feedback_TriggerScreenshotMode, FeedbackModule.ACT_Feedback_UploadImage |
| FeedbackModule.ShareFeedback_Logo | none |

## Journey Groups

| User intent group | Pages |
|---|---|
| General | FeedbackModule.PopupFailure, FeedbackModule.PopupSuccess, FeedbackModule.ShareFeedback |
| PopupFailure | FeedbackModule.PopupFailure_Logo |
| PopupSuccess | FeedbackModule.PopupSuccess_Logo |
| ShareFeedback | FeedbackModule.ShareFeedback_Logo |

## Page Links

| Page | Entry provenance | L0 | L1 | L2 |
|---|---|---|---|---|
| FeedbackModule.PopupFailure | ShowPageAction | [L0](pages/feedbackmodule-popupfailure.abstract.md) | [L1](pages/feedbackmodule-popupfailure.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/FeedbackModule/pages/feedbackmodule-popupfailure.json) |
| FeedbackModule.PopupFailure_Logo | Unknown (navigation metadata not exported) | [L0](pages/feedbackmodule-popupfailure-logo.abstract.md) | [L1](pages/feedbackmodule-popupfailure-logo.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/FeedbackModule/pages/feedbackmodule-popupfailure-logo.json) |
| FeedbackModule.PopupSuccess | ShowPageAction | [L0](pages/feedbackmodule-popupsuccess.abstract.md) | [L1](pages/feedbackmodule-popupsuccess.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/FeedbackModule/pages/feedbackmodule-popupsuccess.json) |
| FeedbackModule.PopupSuccess_Logo | Unknown (navigation metadata not exported) | [L0](pages/feedbackmodule-popupsuccess-logo.abstract.md) | [L1](pages/feedbackmodule-popupsuccess-logo.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/FeedbackModule/pages/feedbackmodule-popupsuccess-logo.json) |
| FeedbackModule.ShareFeedback | ShowPageAction | [L0](pages/feedbackmodule-sharefeedback.abstract.md) | [L1](pages/feedbackmodule-sharefeedback.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/FeedbackModule/pages/feedbackmodule-sharefeedback.json) |
| FeedbackModule.ShareFeedback_Logo | Unknown (navigation metadata not exported) | [L0](pages/feedbackmodule-sharefeedback-logo.abstract.md) | [L1](pages/feedbackmodule-sharefeedback-logo.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/FeedbackModule/pages/feedbackmodule-sharefeedback-logo.json) |
