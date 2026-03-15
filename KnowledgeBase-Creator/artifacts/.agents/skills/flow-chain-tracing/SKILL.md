# SKILL: Flow Chain Tracing

## Purpose

Follow the calls/called-by chain from a starting flow to build a complete execution tree. This skill resolves the full chain of sub-calls, aggregates all entities touched and pages shown, and identifies module boundary crossings.

## Used By

KB Flow Tracer, KB Analyst, KB Feature Interpreter

## When to Use

- The user asks to trace, follow, or understand the complete execution of a flow.
- An agent needs to know all downstream effects of a specific flow.
- An agent needs the full call tree to assess impact or understand a feature end-to-end.

## Procedure

1. **Initialise.** Set the starting flow. Create an empty visited set and an empty chain tree. Set current depth to 0.

2. **Locate.** Find the starting flow in `routes/by-flow.md`. Record: module, type (Microflow/Nanoflow/Rule), tier, L0 link, L1 link, L2 link.

3. **Read L1 overview.** Open the L1 overview file (`flows/<slug>.overview.md`). Extract:
   - **Calls:** list of flows this flow calls (from the "Called / Called By" section).
   - **Called by:** list of flows that call this one.
   - **Key Entities Touched:** entities mutated or read.
   - **Shown Pages:** pages opened by this flow.
   - **Main Steps:** summary of what the flow does.
   - **Retrieves/Decisions/Mutations:** detailed action list.

4. **Forward trace (calls).** For each flow in the Calls list:
   a. If the flow is already in the visited set, mark it as a **cycle** and skip. Record the cycle in the output.
   b. Add the flow to the visited set.
   c. Increment depth. If depth exceeds **10**, mark as **truncated** and skip. Record the truncation in the output.
   d. Recurse from step 2 with the called flow.
   e. If the called flow is in a different module than its caller, note the **module boundary crossing**.

5. **Backward trace (called by).** For the root flow only (depth 0), read L0 abstracts of all callers listed in "Called by". This provides entry context (who triggers this chain?). Do not recurse upward beyond one level.

6. **Entity aggregation.** Collect all entities touched across the entire chain. For each entity, record which flow(s) touch it and the operation type (create/read/update/delete) if derivable from the L1 overview. Cross-reference `routes/by-entity.md` for additional context (CRUD coverage, security).

7. **Page aggregation.** Collect all pages shown across the entire chain. For each page, record which flow shows it. Cross-reference `routes/by-page.md` for role visibility.

8. **Assemble output.** Build the chain tree, entity summary, page summary, boundary crossings, and any warnings (cycles, truncations).

## Output

```markdown
## Flow Chain: [Starting Flow]

### Chain Diagram
[Starting Flow] (Module) [Tier]
  -> [Called Flow 1] (Module) [Tier]
    -> [Called Flow 1.1] (Module) [Tier]
  -> [Called Flow 2] (Module) [Tier]

### Chain Detail
| Depth | Flow | Module | Type | Entities Touched | Pages Shown | Key Steps |
|---|---|---|---|---|---|---|

### Entities Across Chain
| Entity | Operations | By Flow(s) |
|---|---|---|

### Pages Across Chain
| Page | Shown By | Allowed Roles |
|---|---|---|

### Entry Context (who calls the root?)
| Caller | Module | Type |
|---|---|---|

### Module Boundaries Crossed
| From | To | Via Flow Call |
|---|---|---|

### Warnings
- [Cycles detected / Truncations at depth 10 / None]

### Evidence Files Consulted
- [List of KB files read during this trace]
```

## Notes

- The depth limit of 10 prevents runaway recursion in deeply nested call chains. If truncation occurs, report it and suggest the user read the truncated flow's L1 overview directly.
- Cycle detection guards against infinite loops. Well-formed Mendix apps should not have recursive microflow calls, but the guard is a safety measure.
- When tracing into marketplace modules (`modules/_marktplace/<Module>/`), the same L0/L1 reading pattern applies.
- For architectural interpretation of the traced chain, escalate to KB Analyst.
- For business-level feature synthesis from the traced chain, escalate to KB Feature Interpreter.
