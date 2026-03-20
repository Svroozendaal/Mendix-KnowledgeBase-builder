# Module Landscape

## Module Categories

| Module | Category | Complexity | Why this module exists |
|---|---|---:|---|
| Administration | Marketplace | 34 | Support capability from marketplace or shared library |
| Atlas_Core | Marketplace | 0 | Support capability from marketplace or shared library |
| Atlas_Web_Content | Marketplace | 59 | Support capability from marketplace or shared library |
| DataWidgets | Marketplace | 0 | Support capability from marketplace or shared library |
| Inspection | Custom | 132 | Implements app-specific behaviour |
| NanoflowCommons | Marketplace | 6 | Support capability from marketplace or shared library |
| Notification | Custom | 16 | Implements app-specific behaviour |

Confidence: Export-backed

## Module Relationships

`Inspection` is the operational core and owns the main business objects (tasks, inspectors, equipment, bookings, reports) plus most user-facing pages. `Notification` depends on inspection events to create per-user notification records and present unread/read inbox pages. Cross-module interaction is bidirectional: Inspection triggers notification send flows, and Notification calls back into Inspection to resolve account context.

Confidence: Inferred

## Custom Module Purposes

- Inspection: Handles inspection domain execution, including onboarding, task assignment and progress, equipment/tool lifecycle, and report generation.
- Notification: Delivers role-targeted operational alerts and supports inbox management for inspectors and managers.

Confidence: Inferred

## Custom Module Priority Ranking

| Rank | Module | Score | Rationale |
|---|---|---:|---|
| 1 | Inspection | 132 | flow/entity/page density |
| 2 | Notification | 16 | flow/entity/page density |

Confidence: Inferred

## Source

- Generated at: 2026-03-19T15:48:56.0654420Z
- Run folder: C:\Workspaces\Mendix\Emixa_InspectionApp\mendix-data\app-overview\cli_2026-03-19T15-48-55.594Z
