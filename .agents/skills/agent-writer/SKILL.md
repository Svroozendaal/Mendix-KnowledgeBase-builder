# SKILL: agent-writer

## Purpose

Correctly create and register a new agent in the framework.

Use this skill whenever you need to add a new agent role to `.agents/agents/`.

## When to Use

- A new type of responsibility is needed that is not covered by an existing agent.
- A task requires a distinct persona or ongoing role across sessions.
- The user asks to define a new agent.

## Step 1: Confirm the Need for an Agent

Agents represent **roles with ongoing responsibility**. Before creating an agent, check:

- Is this a one-off procedure? → Create a **skill** instead (see `skill-writer`).
- Is this a new ongoing role with defined inputs, behaviour, and outputs? → Create an **agent**.

If unsure, ask the user.

## Step 2: Write the Agent File

Every agent file must follow this structure:

```markdown
# <AGENT_NAME>
## Role

[One paragraph: what this agent does, when it is invoked, and what it is responsible for.]

## Required Inputs

1. [File or data the agent must read before acting.]
2. [...]

## Mandatory Behaviour

1. [Rule the agent must always follow.]
2. [...]

## Output Template

[Markdown block showing the standard output format for this agent's results.]
```

Rules:
- Use UK English.
- File name must be `UPPERCASE.md`.
- Required Inputs must always include `.agents/AGENTS.md` and `.agents/FRAMEWORK.md`.
- Mandatory Behaviour must always include "Ask clarifying questions first."
- Do not embed app-specific content in an agent file.

## Step 3: Register the Agent

After creating the file, update the Agent Roster table in `.agents/AGENTS.md`:

```markdown
| <Agent Name> | `.agents/agents/<FILENAME>.md` | [one-line responsibility description] |
```

## Step 4: Validate

Invoke the Structure Guardian to confirm the agent is correctly placed and registered.

## Notes

- All agents live in `.agents/agents/` — agents are always generic.
- If a role is app-specific and non-reusable, consider encoding it as an app-specific skill in `.app-info/skills/` instead.
- Agents may invoke skills but should not depend on specific other agents directly.
