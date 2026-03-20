# Interpretation: Inspection

## Module Purpose

Inspection is the operational core for running field inspections: it manages inspector accounts, inspection items, task execution, equipment/tool availability, and report generation for managers.

- Orchestrates day-to-day inspection work through task creation, validation, status progression, and notification-triggering save flows.
- Maintains equipment and accessory availability, including booking and stock-state transitions.
- Supports onboarding and profile upkeep for inspectors, including account linkage and image uploads.

Confidence: Inferred

## Domain Narrative

The domain model is centred around `Inspection.Task` as the execution record for inspection work. A task links to one `Inspection.Inspector` (`Inspection.Task_Inspector`), one `Inspection.InspectionItem` (`Inspection.Task_InspectionItem`), optional media (`Inspection.CoverPhoto` via `Inspection.Task_CoverPhoto`), and optional generated output (`Inspection.Report` via `Inspection.Task_Report`). This shapes a clear lifecycle: assign work, execute/update status, attach evidence, and report.

`Inspection.Equipment` is split into specialised subtypes `Inspection.Tool` and `Inspection.Accessory`, while `Inspection.Booking` links inspectors to equipment (`Inspection.Booking_Inspector`, `Inspection.Booking_Equipment`) for reservation scenarios. Stock management is modelled with `Inspection.Accessory.AmountInStock` and `Inspection.ENUM_Accessory_Status`, which the booking/order flows update.

Two non-persistent helper entities support UI-driven workflows: `Inspection.Registration` captures anonymous sign-up input before account creation, and `Inspection.ReportHelper` captures report filter criteria before report generation. Access rules show role-specific intent: inspectors are constrained to their own work via XPath on `Inspection.Task` and `Inspection.InspectionItem`, while managers/admins retain broader coordination control.

Confidence: Inferred

## Flow Narrative

### Tier 1 Business Intent

| Tier 1 flow | Business intent | Business rule/constraint |
|---|---|---|
| `Inspection.ACT_Accessory_Create` | Start creating a new accessory from equipment management and open edit UI. | Creates `Inspection.Accessory` and shows `Inspection.Assessory_NewEdit`. |
| `Inspection.ACT_Assessory_Book` | Reserve/use an accessory and reduce stock. | Stock thresholds drive status changes (`In_Stock` / `Almost_out_of_stock` / `Out_of_stock`). |
| `Inspection.ACT_Assessory_Delete` | Remove obsolete accessory records. | Immediate delete action on accessory. |
| `Inspection.ACT_CoverPhoto_Create` | Prepare cover photo record for a task and open upload UI. | Creates `Inspection.CoverPhoto` linked to task before page open. |
| `Inspection.ACT_CoverPhoto_Save` | Persist uploaded cover photo changes. | Commit with events enabled for cover-photo consistency. |
| `Inspection.ACT_Inspector_Save` | Save inspector profile changes. | Gated by `Inspection.VAL_Inspector_Validate` checks. |
| `Inspection.ACT_InspectorPhoto_Create` | Create and link inspector profile image, then open image editor popup. | Creates `Inspection.InspectorPhoto` linked to inspector. |
| `Inspection.ACT_Registration_Create` | Start self-registration for anonymous users. | Creates transient `Inspection.Registration` and opens registration popup. |
| `Inspection.ACT_Registration_Save` | Finalise registration into account/inspector records. | Uses role decision (`Inspector`/`Manager`) and validation before commit. |
| `Inspection.ACT_Report_ApplyFilters` | Build a filtered report view over tasks. | Applies filter criteria and links matching tasks to report. |
| `Inspection.ACT_Report_Generate` | Generate report output over task data. | Creates `Inspection.Report` and binds tasks into report context. |
| `Inspection.ACT_ReportHelper_Create` | Open report-criteria dialog for the user. | Creates transient `Inspection.ReportHelper` before showing page. |
| `Inspection.ACT_Task_Create` | Start a new task from an inspection item. | Creates `Inspection.Task` with default status `To_do` and timestamp. |
| `Inspection.ACT_Task_Save` | Save task updates and trigger downstream notifications. | Runs `Inspection.VAL_Task_Validate` before commit and calls notification flows. |
| `Inspection.ACT_Task_SetToDone` | Mark a task as completed and notify manager. | Changes status to `Done` and runs task validation/notification calls. |
| `Inspection.ACT_Task_SetToInProgress` | Transition task into active execution state. | Sets status to `Running`. |
| `Inspection.ACT_Tool_Book` | Open booking UI for selected tool. | Navigation to `Inspection.Tool_Book`. |
| `Inspection.ACT_Tool_Create` | Start creating a tool record and open edit popup. | Creates `Inspection.Tool` then shows `Inspection.Tool_NewEdit`. |
| `Inspection.ACT_Tool_Delete` | Remove tool records from inventory. | Immediate delete action on tool. |
| `Inspection.ACT_Tool_Validate` | Validate booking request before accepting reservation changes. | Requires reservation validity and checks existing booking context. |
| `Inspection.BCo_Inspector` | Ensure inspector has linked account metadata at commit time. | Retrieves inspector user role and creates account when association is empty. |
| `Inspection.SE_Equipment_OrderNew` | Periodic replenishment flow for equipment/accessories. | Calls casting/order subflows and commits replenishment list. |
| `Inspection.SUB_Account_GetFromInspector` | Resolve account linked to an inspector for notification context. | Retrieves `Administration.Account` through `Inspection.Inspector_Account`. |
| `Inspection.SUB_Booking_Delete` | Bulk cleanup of old bookings. | Retrieves booking list and deletes it. |
| `Inspection.VAL_Inspector_Validate` | Validate inspector profile completeness. | Requires non-empty name, level, contact/location fields. |
| `Inspection.VAL_Registration_Validate` | Validate registration form quality. | Enforces required fields and password confirmation. |
| `Inspection.VAL_Task_Validate` | Validate task quality and role-specific constraints. | Requires key task fields and role checks (`Manager`/`Administrator`). |
| `Inspection.VAL_Tool_Validate` | Validate tool reservation date logic. | Reservation date must exist and not be in the past. |

### Unknown Evidence Resolution (Inspection-Scoped)

- `Inspection.ACT_Assessory_Book`, `Inspection.ACT_Assessory_Delete`, `Inspection.ACT_CoverPhoto_Save`, `Inspection.ACT_Inspector_Save`: entity touch can be inferred from explicit commit/change/delete actions on `Accessory`, `CoverPhoto`, and `Inspector`.
- `Inspection.ACT_Task_Save`, `Inspection.ACT_Task_SetToDone`, `Inspection.ACT_Task_SetToInProgress`: task entity touch can be inferred from status mutation and `commit Task` actions.
- `Inspection.ACT_Tool_Delete` and `Inspection.ACT_Tool_Book`: tool context is evidenced by delete action on `Tool` and page action around `Inspection.Tool_Book`.
- `Inspection.DS_Booking_RetrieveUpcomming`, `Inspection.SE_Booking_DeleteOlderThenToday`, `Inspection.SUB_Accessory_Order`, `Inspection.SUB_Account_GetFromInspector`, `Inspection.SUB_Equipment_Cast`, `Inspection.OCH_Task_Refresh`, `Inspection.RUL_Task_Save_Validate`, `Inspection.VAL_Inspector_Validate`, `Inspection.VAL_Registration_Validate`, `Inspection.VAL_Task_Validate`, `Inspection.VAL_Tool_Validate`: entity context can be inferred from association retrieves and variable/member references (`Booking`, `Accessory`, `Inspector`, `Task`, `Registration`, `Tool`, `Administration.Account`).
- Remaining unresolved evidence gaps are page-level "Shown by flows" rows where deterministic export still has no `ShowPageAction` for those pages, plus scheduled-event target metadata absent from resource payload.

Confidence: Inferred

## Page Narrative

### User Journey Context

`Inspection` presents a role-driven journey with clear entry points: anonymous users start at `Inspection.Account_LoginPage_SplitLeft`, while authenticated users land on `Inspection.Dashboard_Home` (role-based homepage and menu entry). From there, users branch into operational hubs: `Inspection.Equipment_Overview` (inventory and booking actions), `Inspection.Task_Overview` (task execution/report launch), and `Inspection.Inspector_Overview` (inspector administration).

Task and inspection-item work forms the core execution path: users open/create items in `Inspection.InspectionItem_Overview`, create tasks (`Inspection.ACT_Task_Create`), update lifecycle state in `Inspection.Task_NewEdit`, and optionally attach media (`Inspection.CoverPhoto_NewEdit`). Reporting is initiated from `Inspection.Task_Overview` into `Inspection.Report_NewEdit`, where filtered or full task reports are generated.

Popup/detail split is consistent for edits: `Inspection.Assessory_NewEdit`, `Inspection.Tool_NewEdit`, `Inspection.Tool_Book`, `Inspection.Inspector_NewEdit`, `Inspection.InspectorPhoto_NewEdit`, `Inspection.CoverPhoto_NewEdit`, `Inspection.Registration_NewEdit`, and `Inspection.Report_NewEdit` are modal-style interaction points, while dashboards/overviews (`Dashboard_Home`, `Equipment_Overview`, `Task_Overview`, `Inspector_Overview`, `InspectionItem_Overview`) act as navigation and decision hubs.

Confidence: Inferred
