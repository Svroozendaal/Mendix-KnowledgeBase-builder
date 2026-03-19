# SKILL: Impact Analysis

## Purpose

Trace the blast radius of a change to a specific flow, entity, or page. This skill identifies all directly and indirectly affected artefacts to help agents assess the scope and risk of modifications.

## Used By

KB Analyst, KB Flow Tracer, Planner

## When to Use

- The user asks "what is affected if I change X?"
- An agent needs to assess the scope of a proposed modification.
- A planner needs to identify dependencies before sequencing work.

## Procedure: Flow Change

1. **Identify the target flow.** Locate it in `routes/by-flow.md`. Record module, type, tier.

2. **Upstream impact (callers).** From `routes/by-flow.md`, find the "Called by" count. Read the flow's L1 overview to get the explicit caller list. These callers are **directly affected** because their behaviour depends on the changed flow's output or side effects.

3. **Downstream impact (callees).** From the L1 overview, find the "Calls" list. These callees receive changed input if the calling flow's behaviour changes. Mark as **indirectly affected**.

4. **Entity impact.** From the L1 overview "Key Entities Touched", identify all entities this flow reads or mutates. For each entity, check `routes/by-entity.md` for other flows that touch the same entity. These are **indirectly affected** through shared data.

5. **Page impact.** From `routes/by-flow.md` "Shows Pages" column and the L1 overview "Shown Pages", identify pages served by this flow. Check `routes/by-page.md` for the page's backing flows and role visibility.

6. **Module impact.** List all modules that contain affected flows. Check `routes/cross-module.md` for existing dependency relationships.

7. **Security impact.** For affected entities, check `app/SECURITY.md` for role-based access constraints. Flag entities with XPath constraints that may interact with the changed flow.

8. **Rate blast radius.**
   - **Small:** single module, 1-3 affected flows, no cross-module impact.
   - **Medium:** 2-3 modules, 4-10 affected flows, or entity-level shared data.
   - **Large:** 4+ modules, 10+ affected flows, or critical security-sensitive entities.

## Procedure: Entity Change

1. **Identify the target entity.** Locate it in `routes/by-entity.md`. Record module, CRUD flows, shown-on pages.

2. **Flow impact.** All flows listed in the Create, Update, Delete, and Read columns are **directly affected**.

3. **Page impact.** All pages in the "Shown on pages" column are **directly affected**.

4. **Association impact.** Read `modules/<Module>/DOMAIN.md` for this entity's associations. For each associated entity, check its own CRUD flows and pages in `routes/by-entity.md`. These are **indirectly affected**.

5. **Cross-module impact.** Check `routes/cross-module.md` "Association Links" for cross-module associations involving this entity.

6. **Rate blast radius** using the same scale as above.

## Procedure: Page Change

1. **Identify the target page.** Locate it in `routes/by-page.md`. Record module, allowed roles, shown-by flows.

2. **Flow impact.** All flows in the "Shown by flows" column are **directly affected** (they open or navigate to this page). Additionally, check the page's L1 overview for data source flows and on-click action flows.

3. **Entity impact.** All entities used as data sources on the page are **indirectly affected** (UI changes may require different data shapes or access patterns).

4. **Rate blast radius** using the same scale as above.

## Output

```markdown
## Impact Analysis: [Target Name] ([flow/entity/page])

Blast radius: **[Small / Medium / Large]**

### Directly Affected
| Type | Name | Module | Reason |
|---|---|---|---|

### Indirectly Affected
| Type | Name | Module | Reason |
|---|---|---|---|

### Module Blast Radius
| Module | Impact Type | Affected Items Count |
|---|---|---|

### Security Considerations
- [XPath constraints, role boundaries, or sensitive entity access that may be affected]

### Risk Assessment
- [Cross-module boundaries crossed, data integrity concerns, user-facing impact]
```

## Notes

- Impact analysis is read-only; it identifies what would be affected, not how to fix it.
- For flow-level blast radius, consider invoking the `flow-chain-tracing` skill first to understand the full call tree before assessing impact.
- For entity-level analysis, association partners are critical — a change to a parent entity may cascade through all child entities via associations.
- The blast radius rating is a heuristic guide, not an exact measure. Complex apps may have large blast radii for seemingly small changes.
