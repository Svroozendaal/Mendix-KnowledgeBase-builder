# SKILL: agent-extender

## Purpose

Correctly create an app-specific extension for an existing generic agent.

Use this skill when an agent's generic behaviour needs to be supplemented or partially overridden for this specific application, without modifying the base agent file.

## When to Use

- A generic agent needs additional Required Inputs specific to this app (e.g. always read a certain `.app-info` file).
- A generic agent needs extra Mandatory Behaviour rules for this project's conventions.
- The Output Template needs to include app-specific fields.
- A section of the generic agent is wrong for this project and must be replaced entirely.

## Step 1: Confirm This is an Extension, Not a New Agent

An extension augments an existing agent. Check:

- Does the base agent already exist in `.agents/agents/`? → Write an **extension**.
- Is this an entirely new responsibility with no existing base? → Use the `agent-writer` skill instead.

## Step 2: Identify the Merge Intent for Each Section

For each section you want to change, decide:

| Intent | Marker | Result |
|---|---|---|
| Add items to the base section | *(no marker — default)* | Extension items are appended to the base |
| Completely replace the base section | `[OVERRIDE]` after the heading | Base section is ignored; extension section is used |

## Step 3: Write the Extension File

**File location:** `.app-info/agents/<AGENT>.md`
Use the same filename as the base agent (e.g. `DOCUMENTER.md`).

**Required structure:**

```markdown
# <AGENT_NAME> — App Extension
## Extends: `.agents/agents/<AGENT>.md`
## Merge rule: Sections here ADD TO the base unless marked [OVERRIDE].

---

## Required Inputs

[Continue numbering from where the base ends]
N. [Additional input specific to this app]

## Mandatory Behaviour

[Continue numbering from where the base ends]
N. [Additional rule specific to this app]

## Output Template [OVERRIDE]

[Full replacement output template if the base template does not suit this app]
```

**Rules:**
- The preamble (`## Extends:` and `## Merge rule:`) is mandatory.
- Only include sections you are changing. Omit sections you want to inherit unchanged.
- Continue numbering from where the base agent ends to make additions obvious.
- Use UK English.
- Do not duplicate content already in the base agent.

## Step 4: Register the Extension

After creating the file, add an entry to `.app-info/agents/OVERVIEW.md`:

```
| AGENT_NAME | `AGENT.md` | [one-line description of what the extension adds] |
```

## Step 5: Validate

Invoke the Structure Guardian to confirm:
- The extension file has a matching base agent in `.agents/agents/`.
- The `## Extends:` preamble is present.
- No content duplicates the base agent.

## Notes

- Extensions are app-specific. They live in `.app-info/agents/`, never in `.agents/agents/`.
- A single extension file can override multiple sections — use `[OVERRIDE]` on each affected heading.
- If you find yourself overriding most sections, consider whether a new agent (`agent-writer`) is more appropriate.
