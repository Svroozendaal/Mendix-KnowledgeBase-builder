# Interpretation: Inspection

## Module Purpose

The `Inspection` module is the business core of the app. It manages inspector onboarding, operational task execution, equipment and booking handling, and reporting workflows used by inspectors and managers in daily inspection operations.

What this module does:
- Captures and maintains operational records such as inspectors, tasks, inspection items, tools, accessories, and reports.
- Drives user actions for creating, updating, validating, and completing inspection work.
- Orchestrates downstream communication by triggering notification flows when task status changes.

Confidence: Inferred

## Domain Narrative

The domain model represents a practical field-operations structure. `Inspection.Task` is the central work object and links to `Inspection.Inspector`, optional `Inspection.InspectionItem` evidence, optional `Inspection.CoverPhoto`, and `Inspection.Report` outputs. `Inspection.Inspector` is identity-linked to `Administration.Account` through `Inspection.Inspector_Account`, which aligns user security to assigned work.

Equipment handling is split by specialization: `Inspection.Equipment` is a base concept with `Inspection.Tool` and `Inspection.Accessory` as specialized variants, while `Inspection.Booking` connects inspector-to-equipment reservations over time (`Booking_Inspector`, `Booking_Equipment`). `Inspection.Registration` and `Inspection.ReportHelper` act as process-support entities: registration captures onboarding input, and report helper stores filter criteria for report generation flows.

Security rules indicate an ownership pattern where inspectors mostly read or operate on scoped work, while managers and administrators have broader create/update authority for setup and governance activities.

Confidence: Inferred

## Flow Narrative

| Tier 1 flow | Business intent | Business rule |
|---|---|---|
| Inspection.ACT_Accessory_Create | Open creation flow for a new accessory record used in equipment operations. | Manager-driven creation path inferred from page role and entity access; no extra validation token exported. |
| Inspection.ACT_Assessory_Book | Start an accessory booking action from equipment workflows. | Booking and stock consistency implied by flow purpose, but explicit entity tokens are none in export. |
| Inspection.ACT_Assessory_Delete | Remove an accessory entry from operational inventory when required. | Deletion is role-governed by entity/page permissions; no explicit validation token exported. |
| Inspection.ACT_CoverPhoto_Create | Create a cover-photo object linked to task/inspection evidence capture. | Image creation allowed for configured roles via domain access rules. |
| Inspection.ACT_CoverPhoto_Save | Persist edited cover photo details from the popup flow. | Save behavior inferred from action name; explicit write entity evidence is none in export. |
| Inspection.ACT_Inspector_Save | Persist inspector profile changes from maintenance pages. | Must keep inspector-account linkage consistent (`Inspection.Inspector_Account`) for security alignment. |
| Inspection.ACT_InspectorPhoto_Create | Create an inspector profile image object for profile maintenance. | Role-constrained through page access and domain member rights. |
| Inspection.ACT_Registration_Create | Open registration form data for a new pre-auth onboarding attempt. | Public entry path inferred from anonymous login/registration page. |
| Inspection.ACT_Registration_Save | Convert registration input into persistent account and inspector records. | Validation and account consistency are enforced through called validation/after-commit patterns. |
| Inspection.ACT_Report_ApplyFilters | Apply report filter criteria before final generation. | Filter inputs should constrain task selection by dates/category in `ReportHelper`. |
| Inspection.ACT_Report_Generate | Generate inspection report output from filtered operational data. | Report content is constrained by selected filters and accessible task scope. |
| Inspection.ACT_ReportHelper_Create | Create helper object that stores report filter inputs. | Helper is transient support data and should be valid before generation actions run. |
| Inspection.ACT_Task_Create | Open task creation workflow for a new inspection task. | Initial task defaults (e.g., status) are inferred from domain defaults. |
| Inspection.ACT_Task_Save | Persist task edits and trigger downstream notifications for assignee/manager awareness. | Notification side effects are conditionally triggered through cross-module calls. |
| Inspection.ACT_Task_SetToDone | Mark a task as completed and trigger completion notification behavior. | Status transition should respect allowed lifecycle progression for task states. |
| Inspection.ACT_Task_SetToInProgress | Move a task into active execution state for inspectors. | Transition intent implies state-gate semantics even when explicit tokens are none in export. |
| Inspection.ACT_Tool_Book | Book a tool resource for planned operational work. | Booking validity (date/resource relation) is enforced via `ACT_Tool_Validate`. |
| Inspection.ACT_Tool_Create | Create a new tool record in the equipment inventory. | Manager-level maintenance action inferred from page and role permissions. |
| Inspection.ACT_Tool_Delete | Remove obsolete tool records from inventory. | Deletion constrained by role permissions; explicit validation token is none. |
| Inspection.ACT_Tool_Validate | Validate booking request data before commit. | Explicit validation intent: ensure booking consistency and prevent invalid reservations. |
| Inspection.BCo_Inspector | Execute before-commit logic for inspector object changes. | Commit-time guardrail for inspector data consistency and related account linkage. |
| Inspection.SE_Equipment_OrderNew | Scheduled/automated check that updates equipment-accessory ordering state. | Inventory threshold behavior inferred from accessory stock fields (`AmountInStock`, `IsOrdered`). |
| Inspection.SUB_Account_GetFromInspector | Resolve account context from an inspector reference for downstream flows. | Used as a shared lookup utility for cross-module notification routing. |
| Inspection.SUB_Booking_Delete | Delete outdated booking records when cleanup logic runs. | Used by cleanup paths to enforce booking retention policy. |
| Inspection.VAL_Inspector_Validate | Validate inspector input fields before save. | Explicit validation flow: reject invalid inspector profile data. |
| Inspection.VAL_Registration_Validate | Validate registration input before creating account/inspector records. | Explicit validation flow: enforce required and consistent registration values. |
| Inspection.VAL_Task_Validate | Validate task payload before save/state transition. | Explicit validation flow: enforce required task constraints prior to commit/notification. |
| Inspection.VAL_Tool_Validate | Validate tool-booking details before booking commit. | Explicit validation flow: prevent invalid or conflicting booking submissions. |

Confidence: Inferred

## Page Narrative

### User Journey Context

- Entry points: `Inspection.Account_LoginPage_SplitLeft` (public login/registration) and `Inspection.Dashboard_Home` (role-based post-login operational hub).
- Operational list/detail views: `Inspection.Task_Overview`, `Inspection.Equipment_Overview`, `Inspection.InspectionItem_Overview`, and `Inspection.Inspector_Overview` act as management overviews that launch edits and actions.
- Task execution views: `Inspection.Task_NewEdit` and `Inspection.InspectionItem_FromDashboard` support day-to-day inspector work and item-level follow-up.
- Maintenance popups: `Inspection.Assessory_NewEdit`, `Inspection.Tool_NewEdit`, `Inspection.Tool_Book`, `Inspection.CoverPhoto_NewEdit`, `Inspection.InspectorPhoto_NewEdit`, `Inspection.Inspector_NewEdit`, `Inspection.InspectionItem_NewEdit`, `Inspection.Report_NewEdit`, and `Inspection.Registration_NewEdit` are focused transaction dialogs.
- Personal profile path: `Inspection.Inspector_Account_NewEdit` provides self-maintenance capability for inspector-facing account data.

Confidence: Inferred
