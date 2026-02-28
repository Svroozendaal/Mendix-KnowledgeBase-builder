# PROMPT_CHANGES

## TEMPLATE

```markdown
## PROMPT_CHANGE - [id] - [timestamp]
REQUESTED_BY: [...]
FILES_UPDATED: [...]
SUMMARY: [...]
COMPATIBILITY: BACKWARD_COMPATIBLE | BREAKING
```

## LIVE_LOG

## PROMPT_CHANGE - 001 - 2026-02-18
REQUESTED_BY: Developer
FILES_UPDATED: .agents/*
SUMMARY: Rebuilt `.agents` framework in English, moved Mendix constraints into a dedicated skill, and standardised governance around AGENTS-first and question-first execution.
COMPATIBILITY: BREAKING

## PROMPT_CHANGE - 002 - 2026-02-18
REQUESTED_BY: Developer
FILES_UPDATED: .agents/AGENTS.md, .agents/AI_WORKFLOW.md, .agents/agents/*, .agents/prompts/*, .agents/agent-memory/INCIDENTS.md
SUMMARY: Added WAIT_FOR_APPROVAL policy with AUTO_APPROVE exception, made prompts require entry and exit criteria, added skill-suggestion step in prompts, updated role defaults (Implementer, Tester, Reviewer, Prompt Refiner), and added incident tracking template.
COMPATIBILITY: BACKWARD_COMPATIBLE

## PROMPT_CHANGE - 003 - 2026-02-18
REQUESTED_BY: User
FILES_UPDATED: .agents/prompts/PHASE_6_DATA_COLLECTION.md
SUMMARY: Expanded phase 6 with explicit workflow alignment, skill defaults, schema and folder contracts, validation coverage, memory-log expectations, and clearer parser hand-off criteria.
COMPATIBILITY: BACKWARD_COMPATIBLE

## PROMPT_CHANGE - 004 - 2026-02-23
REQUESTED_BY: User
FILES_UPDATED: development/prompts/PHASE_8_SEMANTIC_CHANGE_QUALITY.md
SUMMARY: Added a new phase 8 planning prompt focused on semantic-only Mendix change reporting, explicit per-element delta contracts, gap analysis, parser/source remediation planning, and validation strategy without implementation work.
COMPATIBILITY: BACKWARD_COMPATIBLE

## PROMPT_CHANGE - 005 - 2026-02-28
REQUESTED_BY: User
FILES_UPDATED: .agents/agents/PROMPT_REFINER.md, .app-info/agents/PROMPT_REFINER.md, .app-info/agents/references/PROMPT_REFINER_RULES.md, .app-info/agents/OVERVIEW.md, .app-info/memory/PROMPT_CHANGES.md
SUMMARY: Reworked Prompt Refiner into a production-ready base-plus-extension workflow with deterministic linting, ambiguity-to-hard-pointer rules, approval checkpoints, conflict severity policy, and skill mapping defaults for V2 prompt batches.
COMPATIBILITY: BACKWARD_COMPATIBLE

## PROMPT_CHANGE - 006 - 2026-02-28
REQUESTED_BY: User
FILES_UPDATED: .app-info/development/prompts/V2 additional features/PROMPT_A0_AUTO_DETECT_MENDIX.md, .app-info/development/prompts/V2 additional features/PROMPT_A1_STORE_COMMIT_MESSAGE.md, .app-info/development/prompts/V2 additional features/PROMPT_A2_FOLDER_MIGRATION.md
SUMMARY: Refined Phase A prompts using the new Prompt Refiner contract by adding Entry/Exit criteria, AGENTS-first startup steps, explicit skill suggestion steps, and repo-verified hard pointers for startup flow, route contract, localStorage keys, and deploy/runtime folder sources.
COMPATIBILITY: BACKWARD_COMPATIBLE

## PROMPT_CHANGE - 007 - 2026-02-28
REQUESTED_BY: User
FILES_UPDATED: .app-info/development/prompts/V2 additional features/PROMPT_B1_PARSER_COVERAGE.md, .app-info/development/prompts/V2 additional features/PROMPT_B2_CROSS_MODULE_IMPACT.md, .app-info/development/prompts/V2 additional features/PROMPT_B3_SEVERITY_SCORING.md
SUMMARY: Refined Phase B prompts with the Prompt Refiner workflow by adding Entry/Exit criteria, AGENTS-first startup steps, deterministic skill suggestion steps, repo-verified code/doc pointers, and explicit schema/versioning and design-phase guardrails.
COMPATIBILITY: BACKWARD_COMPATIBLE

## PROMPT_CHANGE - 008 - 2026-02-28
REQUESTED_BY: User
FILES_UPDATED: .app-info/development/prompts/V2 additional features/PROMPT_C1_HEAD_DUMP_CACHE.md, .app-info/development/prompts/V2 additional features/PROMPT_C2_MODULE_FILTER.md
SUMMARY: Refined Phase C prompts with the Prompt Refiner workflow by adding required prompt structure, AGENTS-first startup steps, deterministic skill suggestion steps, repo-verified refresh/route/UI pointers, and explicit constants/schema guardrails for new query keys and actions.
COMPATIBILITY: BACKWARD_COMPATIBLE

## PROMPT_CHANGE - 009 - 2026-02-28
REQUESTED_BY: User
FILES_UPDATED: .app-info/development/prompts/V2 additional features/PROMPT_D1_COMMIT_MESSAGE_HISTORY.md
SUMMARY: Refined Phase D prompt with Prompt Refiner by adding Entry/Exit criteria, AGENTS-first startup steps, deterministic skill suggestion step, and repo-verified hard pointers for store service, route actions, UI tab integration, constants, and path-guard requirements.
COMPATIBILITY: BACKWARD_COMPATIBLE

## PROMPT_CHANGE - 010 - 2026-02-28
REQUESTED_BY: User
FILES_UPDATED: PROMPT_A0_AUTO_DETECT_MENDIX.md (accepted and implemented)
SUMMARY: DEVELOPER agent implemented PROMPT_A0_AUTO_DETECT_MENDIX.md with MendixInstallationDetectorService (version-specific auto-detection via show-version), startup integration, Settings UI with re-detect button, API endpoint for manual override, fallback to major.minor matching, and comprehensive unit tests covering exact match, fallback, and failure scenarios.
COMPATIBILITY: BACKWARD_COMPATIBLE
IMPLEMENTATION_STATUS: COMPLETE
NEXT_STEPS: TESTER to validate detection on real Mendix projects with varying installed versions; Implementer to handle any build/deployment issues
