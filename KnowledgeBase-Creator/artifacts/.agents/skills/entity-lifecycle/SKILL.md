# SKILL: Entity Lifecycle Mapping

## Purpose

Map the full lifecycle of an entity — Create, Read, Update, Delete — across all flows and pages in the application.

## Used By

KB Domain Expert, KB Security Reviewer, User Story Interpreter

## Procedure

1. Read `routes/by-entity.md` to find all flows and pages referencing the entity.
2. For each flow, read `modules/<Module>/FLOWS.md` and classify as Create, Read, Update, or Delete.
3. For each page, read `modules/<Module>/PAGES.md` and classify as Create form, Detail view, Edit form, List view, or Delete action.
4. Check `modules/<Module>/DOMAIN.md` for access rules (who can CRUD).
5. Check `app/SECURITY.md` for role-level permissions.

## Output

| Operation | Flows | Pages | Roles |
|---|---|---|---|
| Create | [flow names] | [page names] | [role names] |
| Read | [flow names] | [page names] | [role names] |
| Update | [flow names] | [page names] | [role names] |
| Delete | [flow names] | [page names] | [role names] |

Flag any missing operations as lifecycle gaps.
