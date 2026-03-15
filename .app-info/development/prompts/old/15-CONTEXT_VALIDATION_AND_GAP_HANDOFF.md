# PROMPT 15: Validate Context Output and Handoff to GAPSMITH

## Priority

High - this prompt closes the loop by ensuring interview findings become actionable and auditable.

## Depends On

Prompts 11 to 14.

## Context

Read before starting:

1. `.agents/AGENTS.md`
2. `.agents/FRAMEWORK.md`
3. `.app-info/product-plan/11-CONTEXT_CONVERSATION_AGENT_SPEC.md`
4. `.app-info/development/prompts/13-CONTEXT_OVERLAY_AND_TODO_CONTRACT.md`
5. `.app-info/agents/GAPSMITH.md`
6. `.app-info/docs/GAPSMITH_TODO_TEMPLATE.md`

## Problem Statement

Interview notes are useful only if validated and transformed into fix tracks with acceptance checks. We need explicit QA checks and a deterministic mapping from context findings into GAPSMITH categories.

## Deliverable

A validation and handoff procedure specification that the implementer can execute after context conversation output is generated.

## Validation Checklist

Validate these before handoff:

1. Output files exist:
   - `APP_CONTEXT_OVERLAY.md`
   - `APP_CONTEXT_TODO.md`
2. All required fields are present in each record.
3. Confidence values are from allowed set only.
4. Contradicted and unverified high-impact statements have TODO items.
5. Every TODO has an acceptance check and owner track.

## Failure Modes and Required Handling

1. Missing required field:
   - mark validation fail and block handoff.
2. Confidence tag outside allowed taxonomy:
   - normalise or fail with explicit error.
3. Contradicted statement without TODO:
   - create TODO immediately before handoff.
4. TODO without owner track:
   - set owner track before handoff.

## Handoff Mapping Table (Mandatory)

| Context Finding Pattern | Context TODO Type | GAPSMITH Category | Example | Default Owner Track |
|---|---|---|---|---|
| Interview says behaviour differs from KB narrative, export evidence exists | `AI_INTERPRETATION_GAP` | `AI_INTERPRETATION_GAP` | "Users describe approval step that KB omits despite flow evidence." | `Composer/Routing` |
| Interview reveals missing relationship details not present in export fields | `PARSER_GAP_CANDIDATE` | `PARSER_GAP` | "Stakeholder names page entrypoint but export has no navigation metadata." | `Parser` |
| Interview adds useful business context with no contradiction | `CONTENT_ENRICHMENT` | none by default | "Role intent description missing but no structural gap." | `Enrichment Agent` |
| Interview identifies benchmark blind spot | `AI_INTERPRETATION_GAP` | `AI_INTERPRETATION_GAP` | "Critical user journey not covered by benchmark checks." | `Benchmark` |

## Handoff Output Requirements

Minimum handoff package must include:

1. path to context overlay,
2. path to context TODO,
3. list of escalated TODO IDs,
4. mapping evidence for each escalated item.

## Acceptance Criteria

1. Validation checks are explicit, reproducible, and complete.
2. Mapping table covers parser and AI interpretation gap routes with examples.
3. Handoff package requirements are sufficient for GAPSMITH triage.
4. Non-gap enrichment items are kept distinct from structural gaps.

## Verification Steps

1. Run checklist on one sample context output set.
2. Confirm at least one sample maps to each GAPSMITH category.
3. Confirm `CONTENT_ENRICHMENT` does not auto-escalate to GAPSMITH without reason.

## Exit Criteria

1. Context output QA and handoff flow are decision-complete.
2. GAPSMITH can consume escalated findings without additional schema interpretation.

