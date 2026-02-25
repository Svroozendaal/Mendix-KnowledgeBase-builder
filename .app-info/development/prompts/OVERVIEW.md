# development/prompts/
## Application Prompts

This folder contains all phase prompts and development playbooks for this application.

## How Prompts Work

Each prompt defines a self-contained unit of work with:
1. A goal.
2. Entry criteria — what must be true before starting.
3. Exit criteria — what defines "done".
4. A skill suggestion step.

## Prompt Execution

When executing a prompt:
1. Read `.agents/AGENTS.md` first.
2. Read `.agents/FRAMEWORK.md`.
3. Read this OVERVIEW.md.
4. Open the relevant prompt file.
5. Use the Agent Finder to identify which agents and skills to use.

## Contents

| File | Phase | Description |
|---|---|---|
| `PHASE_1_UNPACK_AND_INIT.md` | 1 | Initialise the `.agents` workflow and memory baseline |
| `PHASE_2_PLANNING.md` | 2 | Product planning and requirements |
| `PHASE_3_IMPLEMENTATION.md` | 3 | Core implementation |
| `PHASE_4_TESTING.md` | 4 | Testing and validation |
| `PHASE_5_REVIEW.md` | 5 | Review and quality gate |
| `PHASE_5.5_MODEL_DIFF_ANALYSIS.md` | 5.5 | Model diff analysis |
| `PHASE_6_DATA_COLLECTION.md` | 6 | Data collection and export |
| `PHASE_7_COMMIT_PARSER_AGENT.md` | 7 | Commit parser agent |
