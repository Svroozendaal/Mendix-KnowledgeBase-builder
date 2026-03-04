# Application Overview

## Identity
- Source: mendix-data/dumps/2026-03-02T15-20-39.802Z_App.mpr_086e2d7045254049b65ab730faa2bd4c/working-dump.json
- Generated: 2026-03-03T20:58:20Z
- Schema version: 2.0

## Summary
- Modules: 18 (Custom: 3, Marketplace: 13, System: 1, Unknown: 1)
- Entities: 109, Associations: 97, Enumerations: 54
- Flows: 379 (Microflows: 333, Nanoflows: 42, Rules: 3, Workflows: 1)
- Flow nodes: 3,477; Flow edges: 2,599; Call edges: 214

## Security
- Security level: CheckEverything
- Admin user: MxAdmin
- Guest access: yes (role: Anonymous)

## Key Observations
- This is a **personal finance / expense management application** ("SmartExpenses") with budget tracking, balance management, and transaction processing as core functionality.
- The app uses a multi-role access model with role-based data isolation via XPath constraints — users only see their own data through FBGProfile ownership chains.
- Heavy reliance on marketplace modules (13 of 18) including ExcelImporter for data import and WorkflowCommons (186 flows) for process automation.
