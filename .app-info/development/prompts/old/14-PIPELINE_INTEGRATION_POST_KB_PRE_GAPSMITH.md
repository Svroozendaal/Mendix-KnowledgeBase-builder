# PROMPT 14: Integrate Context Conversation Step in Pipeline and Docs

## Priority

High - this prompt ensures the new context step is invoked at the correct time and is discoverable in project documentation.

## Depends On

Prompts 11, 12, and 13.

## Context

Read before starting:

1. `.agents/AGENTS.md`
2. `.agents/FRAMEWORK.md`
3. `.app-info/product-plan/03-TOOLCHAIN_ARCHITECTURE.md`
4. `.app-info/product-plan/11-CONTEXT_CONVERSATION_AGENT_SPEC.md`
5. `.app-info/agents/KNOWLEDGEBASE_CREATOR.md`
6. `.app-info/ROUTING.md`
7. `.app-info/agents/OVERVIEW.md`

## Problem Statement

If context interview output is produced at the wrong stage, it either lacks KB grounding (too early) or misses structural triage integration (too late). Integration must be post-KB and pre-GAPSMITH.

## Deliverable

Documentation-level pipeline integration instructions (no script/code execution change in this prompt), covering:

1. agent invocation position,
2. referenced files,
3. reader navigation additions,
4. handoff points.

## Required Integration Order

Pipeline order to document:

1. KB generation (scaffold, compose, quality gate, benchmark).
2. Optional enrichment pass.
3. Context conversation agent run.
4. GAPSMITH structural gap diagnosis.

## Required Documentation Updates in Implementation

The implementer should update:

1. `KNOWLEDGEBASE_CREATOR.md` workflow section.
2. `.app-info/ROUTING.md` quick reference to include context conversation step.
3. `.app-info/agents/OVERVIEW.md` roster and pipeline summary.
4. `READER.md` guidance (template or generation logic) with additive links to:
   - `_reports/APP_CONTEXT_OVERLAY.md`
   - `_reports/APP_CONTEXT_TODO.md`

## Linking Rules

1. Add links only; do not remove existing navigation paths.
2. Mark these as interview-derived context.
3. Keep route/index pointers unchanged.

## Guardrails

1. Do not change parser/composer contracts here.
2. Do not move GAPSMITH earlier than context interview.
3. Do not make context step mandatory for structural KB validity checks.

## Acceptance Criteria

1. Integration docs state post-KB, pre-GAPSMITH order explicitly.
2. All reference files include context-step discovery pointers.
3. Integration remains additive and backward compatible.

## Verification Steps

1. Read workflow docs end-to-end and confirm ordering is unambiguous.
2. Confirm both context report paths are referenced in reader navigation.
3. Confirm GAPSMITH docs mention context reports as optional evidence input.

## Exit Criteria

1. Pipeline documentation makes context step operable without guesswork.
2. No sequencing ambiguity remains for implementers.

