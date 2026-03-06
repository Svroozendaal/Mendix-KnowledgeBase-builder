# SKILL: skill-writer

## Purpose

Correctly create and register a new skill in the framework.

Use this skill whenever you need to add a new skill — whether generic (for `.agents/skills/`) or app-specific (for `.app-info/skills/`).

## When to Use

- A new domain of knowledge needs to be captured as a reusable procedure.
- A prompt or agent needs a skill that does not yet exist.
- The user asks to codify a workflow or rule set.

## Step 1: Classify the Skill

Determine where the skill belongs:

| If the skill is... | Place it in... | Register it in... |
|---|---|---|
| Generic — reusable in any project | `.agents/skills/<skill-name>/SKILL.md` | `.agents/AGENTS.md` Skills Overview |
| App-specific — relevant only to this project | `.app-info/skills/<skill-name>/SKILL.md` | `.app-info/skills/OVERVIEW.md` |

Ask the user if classification is unclear.

## Step 2: Write the Skill File

Every skill file must follow this structure:

```markdown
# SKILL: <skill-name>

## Purpose

[One sentence: what this skill does and when to use it.]

## When to Use

[Bullet list of triggers — when should an agent invoke this skill?]

## Procedure

[Numbered steps the agent should follow when using this skill.]

## Output / Expected Result

[What should exist or be produced after the skill is applied?]

## Notes

[Optional: edge cases, dependencies, related skills.]
```

Rules:
- Use UK English.
- Keep procedures concise and actionable.
- Do not embed app-specific content in a generic skill.
- Name the skill file `SKILL.md` inside a kebab-case folder (`skill-name/SKILL.md`).

## Step 3: Register the Skill

After creating the file, update the appropriate index:

- **Generic skill**: Add an entry to the `Skills Overview` section of `.agents/AGENTS.md`.
- **App-specific skill**: Add an entry to `.app-info/skills/OVERVIEW.md`.

Entry format:

```
- `.agents/skills/<skill-name>/SKILL.md` — [one-line description]
```

## Step 4: Validate

Invoke the Structure Guardian to confirm the skill is correctly placed and registered.

## Notes

- A skill is a procedure, not an agent. If the task requires ongoing responsibility or a persona, create an agent instead (see `agent-writer` skill).
- Skills may reference other skills but should not depend on specific agents.
