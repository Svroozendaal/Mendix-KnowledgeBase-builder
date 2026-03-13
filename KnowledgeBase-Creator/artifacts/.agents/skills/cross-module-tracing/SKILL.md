# SKILL: Cross-Module Tracing

## Purpose

Trace dependencies and data flows across module boundaries to understand coupling, impact, and architectural structure.

## Used By

KB Analyst, Planner, Best Practice Recommender

## Procedure

1. Read `routes/cross-module.md` for the dependency matrix.
2. Read `app/CALL_GRAPH.md` for flow-level cross-module calls.
3. For a specific trace, start at the source flow in `modules/<Source>/FLOWS.md`.
4. Follow each cross-module call to its target module.
5. Build a call chain: `Module.Flow → Module.Flow → Module.Flow`.
6. Check `routes/by-entity.md` for entity-level cross-module usage.

## Output

A dependency trace showing:
- Call chain (flow-level path across modules).
- Data flow (which entities are passed between modules).
- Coupling assessment (tight / loose / none).
