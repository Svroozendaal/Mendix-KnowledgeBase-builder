# KnowledgeBase Creator - AI Start

Use this file as the AI starting point for KB creation.

## Mandatory Start Sequence

1. Read `.agents/AGENTS.md`.
2. Read `.agents/AI_WORKFLOW.md`.
3. Execute `.agents/agents/KNOWLEDGEBASE_CREATOR.md`.

## Scope

This package is only for creating a Mendix knowledge base from model-overview export files.
Do not use unrelated agents or skills.

## Input and Output

- Input source: `mendix-data/app-overview/<run-folder>/`
- Output target: `mendix-data/knowledge-base/<app-name>/`

## Required Validation Before Completion

1. `./run-kb-scaffold.ps1 -Validate -OutputRoot mendix-data/knowledge-base -AppName <app-name>`
2. `./run-kb-quality-gate.ps1 -OutputRoot mendix-data/knowledge-base -AppName <app-name>`

Only report success when both validations pass.
