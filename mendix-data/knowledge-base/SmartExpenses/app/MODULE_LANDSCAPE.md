# Module Landscape

## Custom Modules

| Module | Roles | Entities | Flows | Pages | Constants | Purpose |
|--------|-------|----------|-------|-------|-----------|---------|
| SmartExpenses | Admin, Anonymous, Parent, User | 10 | 42 | 29 | 0 | Core business module: expense/budget tracking, transactions, balances, user profiles |
| ImporterHelper | ExcelImporter, RESTImporter | 3 | 7 | 3 | 1 | Data import bridge: Excel file import and REST API import of transactions into SmartExpenses |
| New_Module | ModuleRole | 5 | 2 | 1 | 0 | Appears to be a work-in-progress or test module |

## System Module

| Module | Roles | Entities | Purpose |
|--------|-------|----------|---------|
| System | Administrator, User | 36 | Mendix platform system module (sessions, users, file documents) |

## Marketplace Modules

| Module | Roles | Entities | Flows | Pages | Purpose |
|--------|-------|----------|-------|-------|---------|
| Administration | Administrator, User | 2 | 8 | 9 | User and account management |
| AIDE_Lite | — | 0 | 0 | 0 | AI Development Environment (lightweight) |
| Atlas_Core | — | 0 | 0 | 0 | UI framework: layouts and design system |
| Atlas_Web_Content | Anonymous | 1 | 2 | 0 | Web content styling and anonymous access support |
| DataWidgets | User | 0 | 0 | 0 | Data grid and list widgets |
| ExcelImporter | Configurator, Readonly | 7 | 81 | 13 | Excel/CSV file import with template-based mapping |
| FeedbackModule | User | 2 | 16 | 6 | In-app user feedback collection |
| mIcons | — | 0 | 0 | 0 | Icon library |
| MxModelReflection | ModelAdministrator, Readonly, TokenUser | 15 | 33 | 17 | Runtime model introspection and metadata |
| NanoflowCommons | User | 2 | 0 | 0 | Common nanoflow utilities |
| Toast | User | 0 | 1 | 1 | Toast notification widget |
| WebActions | — | 0 | 0 | 0 | Client-side web action utilities |
| WorkflowCommons | Administrator, User | 26 | 186 | 32 | Workflow engine: task management, user tasks, workflow pages |

## Complexity Profile
- Largest module by flows: WorkflowCommons (186 flows) — marketplace module
- Largest custom module by flows: SmartExpenses (42 flows)
- Largest module by entities: System (36 entities) — platform module
- Largest custom module by entities: SmartExpenses (10 entities)
- Modules with no custom content: AIDE_Lite, Atlas_Core, mIcons, WebActions, DataWidgets
