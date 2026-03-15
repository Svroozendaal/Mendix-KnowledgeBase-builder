# PROMPT 12: Implement the Structured Interview Protocol

## Priority

High - without a stable interview protocol, context output will be inconsistent and difficult to validate.

## Depends On

Prompt 11.

## Context

Read before starting:

1. `.agents/AGENTS.md`
2. `.agents/FRAMEWORK.md`
3. `.app-info/product-plan/11-CONTEXT_CONVERSATION_AGENT_SPEC.md`
4. `.app-info/development/prompts/11-CONTEXT_AGENT_ROLE_AND_BOUNDARY.md`

## Problem Statement

Interview quality varies by operator unless question flow, branching, and stop rules are explicit. We need a product-owner-first protocol with optional validation loop for admin and power-user stakeholders.

## Deliverable

Define a deterministic conversation protocol for the context conversation agent, including:

1. phase order,
2. question bank,
3. branch logic,
4. stop conditions,
5. output capture requirements.

## Required Interview Phases

The protocol must use exactly these five phases:

1. App mission and business outcomes.
2. Primary users and role intent.
3. Core journeys and happy path.
4. Exceptions, edge cases, and pain points.
5. Vocabulary and domain terms.

## Question Bank Requirements

For each phase include:

1. core questions (required),
2. probe questions (optional),
3. anti-ambiguity checks,
4. minimum capture fields (statement, source, confidence seed, linked KB area).

## Branching Rules

1. If stakeholder gives low-confidence claim, ask one corroboration probe.
2. If claim conflicts with KB evidence, mark as contradiction and continue.
3. If mission or primary-user intent remains unclear after probes, escalate with explicit unresolved item.
4. Optional validation branch:
   - run short confirmation pass with admin or power user only for high-impact unresolved items.

## Stop Rules

The interview should stop when one of the following is true:

1. all five phases have at least one captured statement,
2. all critical unresolved items are logged as TODO,
3. no new material information appears in two consecutive probe cycles.

## Output Capture Rules

Each captured statement must be mapped to:

1. context id,
2. phase,
3. source summary,
4. initial confidence label,
5. linked KB coverage path or `missing`.

## Acceptance Criteria

1. Five mandatory phases are present and in order.
2. Product-owner-first path is the default.
3. Optional admin or power-user validation loop is documented.
4. Branching and stop rules are explicit and testable.

## Verification Steps

1. Trace one sample interview from phase 1 to phase 5.
2. Confirm branch behaviour for contradiction and uncertainty.
3. Confirm protocol produces enough structure for Prompt 13 output contracts.

## Exit Criteria

1. Interview protocol is repeatable across runs and operators.
2. No major ambiguity remains about what to ask, when to branch, and when to stop.

