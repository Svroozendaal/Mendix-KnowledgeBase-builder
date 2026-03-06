# AI_WORKFLOW
## KB Creation Workflow

1. Read `.agents/AGENTS.md`.
2. Confirm scope: create KB only.
3. Read `.agents/agents/KNOWLEDGEBASE_CREATOR.md`.
4. Read `.agents/agents/OVERVIEW_KB_BUILDER.md`.
5. Read all three `.agents/skills/*/SKILL.md` files.
6. Build or update KB markdown files under `mendix-data/knowledge-base/<app>/`.
7. Run scaffold and quality validation scripts.
8. Return a completion report with validation outcomes.

## Question-first checklist

Ask before writing only when one of these is unknown:

1. Source run folder.
2. App name for output folder.
3. Whether to include all modules or a subset.
