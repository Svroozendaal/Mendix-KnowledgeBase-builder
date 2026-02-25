# PRODUCT_PLAN
## Mendix Studio Pro 10 Git Changes Extension

> This plan captures the current product direction. Process and governance are defined in `.agents/AGENTS.md`.

## Vision

Provide a reliable in-IDE Git changes experience for Mendix Studio Pro 10, and support future commit-intelligence workflows via structured change data.

## Current Capability Focus

1. Show uncommitted Mendix-relevant Git changes.
2. Surface file-level diff context.
3. Provide model-level change context where possible.
4. Support data pipelines for downstream parsing and analysis.

## Non-Goals

1. Replace full Git client functionality.
2. Introduce unrelated platform integrations without a defined prompt.
3. Mix governance guidance into product requirements.

## Quality Goals

1. Deterministic behaviour in normal paths.
2. Friendly error handling for common failure modes.
3. Clear operational docs for maintainers.
4. Traceable decisions through agent memory files.

## Delivery Model

Execution playbooks live in `.agents/prompts/`.
Use those prompts with the question-first workflow defined in `.agents/AI_WORKFLOW.md`.

