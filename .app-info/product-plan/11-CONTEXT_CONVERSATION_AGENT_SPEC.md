# Context Conversation Agent Specification

## Objective

Define a post-generation agent that interviews users about real application usage context so the KB can answer questions with better business meaning and fewer interpretation gaps.

This specification is additive. It does not change parser, composer, or current required KB file contracts.

## Pipeline Position

The context conversation agent runs in this order:

1. KB generation and validation complete.
2. Optional KB enrichment complete.
3. Context conversation agent runs (this spec).
4. GAPSMITH runs with context output included as evidence.

Position rule: post-KB, pre-GAPSMITH.

## Purpose Boundary

The context conversation agent:

1. Conducts a structured interview with a product owner by default.
2. Produces additive context artifacts under `<kb-root>/_reports/`.
3. Marks confidence and unresolved assumptions explicitly.
4. Produces TODO items for follow-up work.

The agent must not:

1. Overwrite export-backed facts in existing KB files.
2. Replace deterministic route/index content directly.
3. Convert interview claims into facts without corroboration.

## Inputs Contract

Required inputs:

1. `kb_root`
2. `run_folder`
3. `app_name`
4. `stakeholder_profile` (default: `product_owner`)

Optional inputs:

1. `session_date_utc`
2. `interviewer`
3. `scope_notes`
4. `validation_participants` (for optional admin or power-user follow-up pass)

## Outputs Contract

The agent writes:

1. `<kb-root>/_reports/APP_CONTEXT_OVERLAY.md`
2. `<kb-root>/_reports/APP_CONTEXT_TODO.md`

Optional:

1. session metadata section inside `APP_CONTEXT_OVERLAY.md`

Output lifecycle:

1. Outputs are per-app.
2. Outputs are regenerated per interview cycle.
3. Previous cycle can be retained by timestamp section or archived copy, but current files stay at fixed paths above.

## Interview Audience Policy

Default audience:

1. Product owner (required track).

Optional follow-up audience:

1. Technical admin.
2. Power user.

Usage rule:

1. Product-owner interview is mandatory.
2. Optional follow-up is used only to confirm or challenge high-impact assumptions from the first pass.

## Interview Protocol (Five Phases)

The interview must be structured into these five phases:

1. App mission and business outcomes.
2. Primary users and role intent.
3. Core journeys and happy path.
4. Exceptions, edge cases, and pain points.
5. Domain vocabulary and critical terms.

Each phase must produce:

1. concise statement set,
2. source pointer (quote or summary),
3. KB coverage check,
4. confidence tag,
5. action tag.

## Confidence and Contradiction Policy

Confidence tags for overlay records:

1. `Corroborated`
2. `Interview-stated`
3. `Unverified`
4. `Contradicted`

Policy rules:

1. If statement is supported by export-backed KB evidence: `Corroborated`.
2. If stated in interview and not yet checked: `Interview-stated`.
3. If checked but no supporting KB evidence exists: `Unverified`.
4. If statement conflicts with export-backed KB evidence: `Contradicted`.

Hard guardrail:

1. Missing corroboration never upgrades to factual KB content automatically.
2. Contradictions always generate TODO items.

## Overlay Record Schema

Every overlay row must include:

1. `Context ID` (`CTX-###`)
2. `Statement`
3. `Source` (interview quote or summary)
4. `Coverage in KB` (linked file path or `missing`)
5. `Confidence`
6. `Action` (`none`, `enrich`, `investigate`, `gapsmith`)

## TODO Record Schema

Every TODO row must include:

1. `Todo ID` (`CTX-TODO-###`)
2. `Type` (`CONTENT_ENRICHMENT`, `AI_INTERPRETATION_GAP`, `PARSER_GAP_CANDIDATE`)
3. `Priority` (`P0..P3`)
4. `Owner Track` (`Composer/Routing`, `Parser`, `Enrichment Agent`, `Benchmark`)
5. `Acceptance Check`
6. `Source Context ID(s)`

## Linking Policy

Context outputs are additive and must be referenced from:

1. `READER.md`
2. `ROUTING.md`

Linking rules:

1. Add links only; do not remove existing navigation entries.
2. Mark context files as interview-derived.
3. Keep existing confidence semantics intact for base KB files.

## GAPSMITH Handoff Contract

Handoff rules:

1. Any TODO with type `AI_INTERPRETATION_GAP` must map to GAPSMITH `AI_INTERPRETATION_GAP`.
2. Any TODO with type `PARSER_GAP_CANDIDATE` must map to GAPSMITH `PARSER_GAP`.
3. Contradicted statements must be included in GAPSMITH review input.

Minimum handoff fields:

1. issue id,
2. evidence path,
3. contradiction or unknown summary,
4. proposed fix track,
5. acceptance check.

## Privacy and Redaction Guidance

This phase does not introduce new data-retention systems. The agent must still:

1. avoid storing personal data unnecessary for technical context,
2. redact direct personal identifiers from interview quotes where possible,
3. store only the minimum context needed for KB improvement.

## Acceptance Criteria

1. Input and output contracts are explicit and stable.
2. Five interview phases are defined and mandatory.
3. Confidence and contradiction policy is explicit.
4. Overlay and TODO schemas are fully specified.
5. GAPSMITH handoff mapping is explicit.
6. Existing KB file contract remains unchanged.

## Verification Checklist

1. `APP_CONTEXT_OVERLAY.md` and `APP_CONTEXT_TODO.md` paths are documented identically across related docs.
2. Confidence tags and action tags are listed with no ambiguity.
3. Contradiction policy includes mandatory TODO generation.
4. Pipeline position states post-KB, pre-GAPSMITH.
5. Product-owner-first audience policy is present.
