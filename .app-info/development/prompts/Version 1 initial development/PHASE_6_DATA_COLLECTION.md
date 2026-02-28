# PHASE_6_DATA_COLLECTION
## Goal

Collect and export structured change data for reliable downstream parsing.

## Entry Criteria

1. Data-collection scope, acceptance criteria, and non-goals are clear.
2. Outputs from `PHASE_5.5_MODEL_DIFF_ANALYSIS` are available when Mendix model files are in scope.
3. Clarifying workflow questions have been asked as needed.

## Required First Action

1. Read `.agents/AGENTS.md`.
2. Read `.agents/AI_WORKFLOW.md`.
3. Ask workflow questions first.
4. Confirm scope and non-goals.
5. Ask which skills should be used and suggest relevant defaults.
6. Load relevant skills, including `.agents/skills/mendix-studio-pro-10/SKILL.md`, `.agents/skills/mendix-sdk/SKILL.md`, `.agents/skills/mendix-model-dump-inspection/SKILL.md`, `.agents/skills/testing/SKILL.md`, and `.agents/skills/documentation/SKILL.md`.

## Tasks

1. Pause at `WAIT_FOR_APPROVAL` before implementation changes, unless `AUTO_APPROVE` is explicit.
2. Confirm data source boundaries (repository scope, change types, inclusion and exclusion rules).
3. Define and version the export schema (required fields, optional fields, enums, and timestamps).
4. Define folder and file contract for parser ingestion (naming, atomic writes, and error routing).
5. Implement export behaviour and user feedback in small verifiable steps.
6. Ensure `.mpr` export payload can carry model dump artifact locations when deep inspection is needed.
7. Validate success and failure paths, including empty change sets, malformed data, binary-model handling, and permission issues.
8. Record decisions and implementation progress in `.agents/agent-memory/DECISIONS_LOG.md` and `.agents/agent-memory/PROGRESS.md`.
9. Document parser consumer expectations, known limitations, and hand-off notes for phase 7.

## Exit Criteria

1. Export schema and folder contract are documented and parser-ready.
2. Validation outcomes cover both success and failure paths.
3. Parser consumer expectations and known limitations are clear.
4. Memory log updates and hand-off notes are complete.
