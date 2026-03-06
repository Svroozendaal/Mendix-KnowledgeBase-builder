# AGENTS
## KnowledgeBase Creator Agent System

This package contains only the agents and skills required to create a Mendix knowledge base.

## Purpose

Convert a Mendix `.mpr` model into:
1. `mendix-data/app-overview/<run>/` export data.
2. `mendix-data/knowledge-base/<app>/` AI-navigable KB markdown.

## Allowed Workflow

1. Read `agents.md` first.
2. Read `.agents/AI_WORKFLOW.md`.
3. Execute `.agents/agents/KNOWLEDGEBASE_CREATOR.md`.
4. Delegate markdown authoring work to `.agents/agents/OVERVIEW_KB_BUILDER.md`.
5. Use only included skills from `.agents/skills/`.

## Included Agents

- `.agents/agents/KNOWLEDGEBASE_CREATOR.md`
- `.agents/agents/OVERVIEW_KB_BUILDER.md`

## Included Skills

- `.agents/skills/mendix-overview-general-interpretation/SKILL.md`
- `.agents/skills/mendix-overview-module-interpretation/SKILL.md`
- `.agents/skills/mendix-overview-routing-synthesis/SKILL.md`

## Validation Rule

Do not report completion unless both pass:

1. `./run-kb-scaffold.ps1 -Validate -OutputRoot mendix-data/knowledge-base -AppName <app-name>`
2. `./run-kb-quality-gate.ps1 -OutputRoot mendix-data/knowledge-base -AppName <app-name>`
