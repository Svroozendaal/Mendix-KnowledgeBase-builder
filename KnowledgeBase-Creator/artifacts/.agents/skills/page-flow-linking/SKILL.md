# SKILL: Page-Flow Linking

## Purpose

Connect pages to their backing flows (data sources, on-click actions, validations) and map the complete page interaction model.

## Used By

KB UX Interpreter, KB Navigator, User Story Interpreter

## Procedure

1. Read `modules/<Module>/PAGES.md` for the page definition.
2. Identify data source flows (DS_ microflows or nanoflows that feed data views / list views).
3. Identify action flows (ACT_ microflows triggered by buttons or events).
4. Identify validation flows (VAL_ microflows called before commits).
5. Cross-reference `routes/by-page.md` for a summary of page-flow links.
6. Cross-reference `routes/by-flow.md` to find all pages that use a specific flow.

## Output

For each page:

| Widget / Action | Flow | Type | Entity |
|---|---|---|---|
| Data view source | DS_Entity_GetActive | Data source | Entity |
| Save button | ACT_Entity_Save | Action | Entity |
| Validation | VAL_Entity_BeforeCommit | Validation | Entity |
| Delete button | ACT_Entity_Delete | Action | Entity |
| Navigation button | — | Show page | — |
