# PROMPT 13: Define Context Overlay and TODO Artifact Contracts

## Priority

Critical - this prompt locks the I/O schema that downstream agents and reviewers depend on.

## Depends On

Prompts 11 and 12.

## Context

Read before starting:

1. `.agents/AGENTS.md`
2. `.agents/FRAMEWORK.md`
3. `.app-info/product-plan/11-CONTEXT_CONVERSATION_AGENT_SPEC.md`
4. `.app-info/agents/GAPSMITH.md`
5. `.app-info/docs/GAPSMITH_TODO_TEMPLATE.md`

## Problem Statement

Without strict artifact schemas, context findings cannot be consumed reliably by KB readers, enrichment steps, or GAPSMITH. We need explicit contracts for overlay records, TODO records, and confidence taxonomy.

## Deliverable

Define the exact structure for:

1. `<kb-root>/_reports/APP_CONTEXT_OVERLAY.md`
2. `<kb-root>/_reports/APP_CONTEXT_TODO.md`

## Overlay Contract

Each record must contain:

1. `Context ID` (`CTX-###`)
2. `Statement`
3. `Source` (quote or summary)
4. `Coverage in KB` (file link or `missing`)
5. `Confidence` (`Corroborated`, `Interview-stated`, `Unverified`, `Contradicted`)
6. `Action` (`none`, `enrich`, `investigate`, `gapsmith`)

Required overlay sections:

1. Summary metadata (date, app, stakeholder profile, interviewer if known)
2. Captured context table
3. Contradictions section
4. Open assumptions section

## TODO Contract

Each TODO item must contain:

1. `Todo ID` (`CTX-TODO-###`)
2. `Type` (`CONTENT_ENRICHMENT`, `AI_INTERPRETATION_GAP`, `PARSER_GAP_CANDIDATE`)
3. `Priority` (`P0..P3`)
4. `Owner Track` (`Composer/Routing`, `Parser`, `Enrichment Agent`, `Benchmark`)
5. `Source Context ID(s)`
6. `Acceptance Check`

Required TODO sections:

1. Summary counts by type and priority
2. Actionable TODO table
3. Deferred items

## Confidence Semantics Extension Rules

1. Keep existing KB confidence semantics unchanged in base KB files.
2. Use interview-layer confidence tags only in context overlay and context TODO artifacts.
3. Never rewrite base KB confidence markers based solely on interview evidence.

## ID and Ordering Rules

1. IDs are stable within a single interview cycle.
2. Sort by priority, then type, then ID.
3. Keep deterministic table column order.

## Mapping Rules to GAPSMITH

1. `AI_INTERPRETATION_GAP` TODOs map to GAPSMITH `AI_INTERPRETATION_GAP`.
2. `PARSER_GAP_CANDIDATE` TODOs map to GAPSMITH `PARSER_GAP`.
3. `CONTENT_ENRICHMENT` items remain enrichment backlog unless escalated.

## Acceptance Criteria

1. Both artifact schemas are explicit and complete.
2. All required fields are mandatory, not optional.
3. Confidence tags are defined once and used consistently.
4. Mapping to GAPSMITH categories is explicit.

## Verification Steps

1. Generate one sample overlay row for each confidence state.
2. Generate one TODO row for each TODO type.
3. Confirm each TODO row has an acceptance check.

## Exit Criteria

1. Artifact contracts can be implemented without further schema decisions.
2. Downstream GAPSMITH consumption requirements are already satisfied by structure.

