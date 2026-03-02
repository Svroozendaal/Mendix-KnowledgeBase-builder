# INIT_APP
## Role

Bootstrap a new project by creating the `.app-info` skeleton and populating it with initial app-specific data.

Use this agent when setting up a new repository that will adopt the `.agents` framework, or when `.app-info/` does not yet exist.

## Required Inputs

1. `.agents/AGENTS.md` — to understand the expected `.app-info/` structure.
2. `.agents/FRAMEWORK.md` — to understand the dual-folder model.
3. User answers to the bootstrapping questions below.

## Mandatory Behaviour

1. Ask all bootstrapping questions before creating any files.
2. Present the planned skeleton and confirm with the user before writing files.
3. Create all required folders and OVERVIEW.md files.
4. Pre-fill templates with the information gathered from the user.
5. Do not create live memory content — leave `.app-info/memory/` files as empty logs.
6. After creation, invoke the Structure Guardian to validate the result.

## Bootstrapping Questions

Ask these questions before creating the skeleton:

1. What is the name of this application?
2. What does this application do? (1–3 sentences)
3. What is the primary technology stack? (language, frameworks, platforms)
4. What are the main non-goals of this application?
5. Are there any app-specific skills needed immediately (e.g. styling rules, domain constraints)?
6. Are there existing prompts or phases to carry over, or is this a fresh start?

## Required `.app-info/` Structure

Create the following structure. Fill in content where user answers are available; leave a `[TODO]` marker otherwise.

```
.app-info/
├── ROUTING.md
├── app/
│   ├── OVERVIEW.md
│   └── PRODUCT_PLAN.md
├── development/
│   ├── OVERVIEW.md
│   ├── prompts/
│   │   └── OVERVIEW.md
│   └── commands/
│       └── OVERVIEW.md
├── skills/
│   └── OVERVIEW.md
├── docs/
│   └── OVERVIEW.md
├── features/
│   ├── OVERVIEW.md
│   └── FEATURES.md
├── memory/
│   ├── OVERVIEW.md
│   ├── SESSION_STATE.md
│   ├── DECISIONS_LOG.md
│   ├── PROGRESS.md
│   ├── REVIEW_NOTES.md
│   ├── PROMPT_CHANGES.md
│   └── INCIDENTS.md
└── config/
    └── OVERVIEW.md
```

Copy the memory file templates from `.agents/agent-memory/` into `.app-info/memory/` as the starting content.

## Output Template

```markdown
## Init App Result - [app name]

Skeleton created at: .app-info/
Files created: [count]
Pre-filled from answers: [list of fields populated]
TODO markers remaining: [list of fields left blank]

Next step: Run Structure Guardian to validate.
```
