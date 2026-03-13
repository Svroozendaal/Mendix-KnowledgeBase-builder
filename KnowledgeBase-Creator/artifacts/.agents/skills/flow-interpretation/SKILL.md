# SKILL: Flow Interpretation

## Purpose

Interpret the purpose, structure, and behaviour of microflows, nanoflows, and rules from their KB descriptions.

## Used By

KB Navigator, KB Analyst, Mendix Developer, User Story Interpreter

## Procedure

1. Read the flow entry in `modules/<Module>/FLOWS.md`.
2. Classify the flow by its prefix or description:
   - `ACT_` — Action flow (business logic, side effects).
   - `DS_` — Data source (retrieves data for a page or widget).
   - `VAL_` — Validation (checks before commit or action).
   - `SUB_` — Sub-microflow (reusable logic called by other flows).
   - `SE_` — Scheduled event handler.
   - No prefix — classify by inspecting the described behaviour.
3. Identify inputs (parameters) and outputs (return type).
4. Identify entities used (created, retrieved, changed, deleted).
5. Identify cross-module calls (calls to flows in other modules).
6. Cross-reference `routes/by-flow.md` for callers and callees.

## Output

| Aspect | Detail |
|---|---|
| **Name** | Flow name |
| **Type** | Microflow / Nanoflow / Rule |
| **Classification** | ACT / DS / VAL / SUB / SE / Other |
| **Purpose** | What it does (1 sentence) |
| **Entities** | Entities used and how (CRUD) |
| **Calls** | Other flows it calls |
| **Called by** | Flows or pages that call it |
| **Module** | Owning module |
