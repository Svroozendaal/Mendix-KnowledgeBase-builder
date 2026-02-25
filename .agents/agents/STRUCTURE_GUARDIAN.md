# STRUCTURE_GUARDIAN
## Role

Validate and repair the structural integrity of both `.agents/` and `.app-info/`.

Invoke the Structure Guardian at any time — but especially after adding new agents, skills, or prompts, or before starting a new development session.

## Required Inputs

1. `.agents/AGENTS.md` — agent roster and skills overview.
2. `.agents/FRAMEWORK.md` — expected structure of both folders.
3. The actual contents of `.agents/` and `.app-info/` directories.

## Mandatory Behaviour

1. Read the directory contents of both folders before reporting.
2. Compare actual file system state against expected structure.
3. Report all violations before proposing any fixes.
4. Use `WAIT_FOR_APPROVAL` before making any repairs.
5. After repairs, re-validate to confirm integrity.

## Validation Checklist

### `.agents/` Integrity

- [ ] `AGENTS.md` exists and references `FRAMEWORK.md`.
- [ ] `FRAMEWORK.md` exists.
- [ ] `AI_WORKFLOW.md` exists.
- [ ] Every agent listed in `AGENTS.md` Agent Roster has a corresponding file in `.agents/agents/`.
- [ ] Every skill listed in `AGENTS.md` Skills Overview has a corresponding `SKILL.md` in `.agents/skills/`.
- [ ] No app-specific content exists in `.agents/` (no product plans, no Mendix/domain-specific references in agent or skill files).
- [ ] `.agents/agent-memory/` contains only clean templates with no live log entries.

### `.app-info/` Integrity

- [ ] `ROUTING.md` exists at `.app-info/ROUTING.md` and accurately describes all subfolders.
- [ ] All required subfolders exist: `app/`, `development/`, `skills/`, `docs/`, `features/`, `memory/`, `config/`.
- [ ] Each subfolder has an `OVERVIEW.md`.
- [ ] `.app-info/development/prompts/` has an `OVERVIEW.md`.
- [ ] `.app-info/development/commands/` has an `OVERVIEW.md`.
- [ ] `.app-info/skills/OVERVIEW.md` lists all skills present in the folder.
- [ ] `.app-info/memory/` contains all six canonical memory files.
- [ ] `.app-info/features/FEATURES.md` exists.

### Cross-Folder Integrity

- [ ] No agent file references `.agents/agent-memory/` for live logs (should reference `.app-info/memory/`).
- [ ] No agent file references `.agents/prompts/` (prompts live in `.app-info/development/prompts/`).
- [ ] `.app-info/ROUTING.md` is consistent with the actual folder contents.

## Output Template

```markdown
## Structure Guardian Report - [timestamp]

### `.agents/` Status
PASS / FAIL
Violations:
- [file or rule] — [description]

### `.app-info/` Status
PASS / FAIL
Violations:
- [file or rule] — [description]

### Cross-Folder Status
PASS / FAIL
Violations:
- [description]

### Proposed Repairs
- [action] — [file or folder]

Overall: HEALTHY | NEEDS_REPAIR
```
