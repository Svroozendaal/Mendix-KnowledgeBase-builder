# PROMPT 11: Define the Context Conversation Agent Role and Boundary

## Priority

High - this prompt establishes ownership, safety boundaries, and non-destructive behaviour for interview-driven context capture.

## Context

Read before starting:

1. `.agents/AGENTS.md`
2. `.agents/FRAMEWORK.md`
3. `.app-info/product-plan/11-CONTEXT_CONVERSATION_AGENT_SPEC.md`
4. `.app-info/agents/KNOWLEDGEBASE_CREATOR.md`
5. `.app-info/agents/GAPSMITH.md`

## Problem Statement

The current pipeline captures model and inferred behaviour well, but it does not systematically capture business intent explained by stakeholders. We need a dedicated context conversation agent with strict boundaries so interview input improves understanding without corrupting export-backed facts.

## Entry Criteria

1. Prompt 11 is the first prompt in the context conversation track.
2. Product-plan spec 11 exists.

## Deliverable

Define a new app-specific agent contract (target file to be created in implementation phase, for example `.app-info/agents/APP_CONTEXT_CONVERSATION.md`) with:

1. role,
2. required inputs,
3. core workflow,
4. guardrails,
5. output template.

## Required Agent Role Definition

The new agent must:

1. run after KB generation and before GAPSMITH,
2. interview product owner by default,
3. capture business context statements with confidence tags,
4. write additive context outputs only.

The agent must not:

1. rewrite base KB facts without corroboration,
2. alter parser/composer source exports,
3. bypass contradiction logging.

## Required Inputs in Agent Contract

1. `kb_root`
2. `run_folder`
3. `app_name`
4. `stakeholder_profile` (`product_owner` default)

## Required Outputs in Agent Contract

1. `<kb-root>/_reports/APP_CONTEXT_OVERLAY.md`
2. `<kb-root>/_reports/APP_CONTEXT_TODO.md`

## Mandatory Guardrails

1. Additive-only writes.
2. Explicit confidence on each captured statement.
3. Contradictions produce TODO items.
4. No claim promotion to export-backed fact from interview evidence alone.

## Acceptance Criteria

1. Agent role clearly separates interview context from deterministic KB facts.
2. Inputs and outputs match product-plan spec 11 exactly.
3. Guardrails explicitly prohibit destructive overwrites.
4. Pipeline position is stated as post-KB and pre-GAPSMITH.

## Verification Steps

1. Read the created/updated agent file and confirm all required sections exist.
2. Confirm both report output paths are stated exactly.
3. Confirm contradiction behaviour is mandatory.

## Exit Criteria

1. Agent role and boundary are decision-complete.
2. No unresolved ownership or safety ambiguity remains for later prompts.

