# PHASE_7_COMMIT_PARSER_AGENT
## Goal

Build and operate the receiving parser workflow for exported change data, producing commit-message-ready structured outputs.

## Entry Criteria

1. Export contract is available.
2. Clarifying workflow questions have been asked as needed.

## Required First Action

1. Read `.agents/AGENTS.md`.
2. Read `.agents/AI_WORKFLOW.md`.
3. Ask workflow questions first.
4. Ask which skills should be used and suggest relevant defaults.
5. Load relevant skills, including:
   - `.agents/skills/mendix-studio-pro-10/SKILL.md`
   - `.agents/skills/mendix-commit-structuring/SKILL.md`
   - `.agents/skills/mendix-model-dump-inspection/SKILL.md`

## Tasks

1. Pause at `WAIT_FOR_APPROVAL` before implementation changes, unless `AUTO_APPROVE` is explicit.
2. Watch export input folder for new files.
3. Process existing export backlog on startup before watcher events.
4. Parse and enrich raw change data into structured schema output.
5. Populate commit-oriented sections (`files`, `modelSummary`, `commitMessageContext`).
6. Persist structured outputs safely.
7. Route malformed files to error handling.
8. Document pipeline behaviour and hand-off contracts.

## Exit Criteria

1. Watch/parse/store/error pipeline is operational.
2. Structured output contract is documented (`schemaVersion` and key sections).
3. Hand-off contracts are documented.
4. Validation outcomes are recorded.
