# PROMPT_REFINER_RULES
## Purpose

Single source of truth for prompt-refinement linting, ambiguity handling, conflict severity, and deterministic skill suggestion defaults in this application.

## Ambiguity To Action Rules

| Ambiguous pattern | Detection hint | Required action | Severity when unresolved |
|---|---|---|---|
| Vague file location wording (`likely`, `or similar`, `locate`, `find`) | `rg -n "likely|or similar|locate|find"` | Verify with `rg --files` or `rg -n`, then replace with exact repository path(s). | MUST FIX |
| Unknown or missing artefact reference | Search expected folder and known docs with `rg --files` and targeted `rg -n` | Provide best candidate path(s). If none exists, add explicit discovery TODO and mark blocked. | MUST FIX |
| "Verify exact key/type/contract" without pointer | `rg -n "verify exact|confirm exact"` | Add explicit verification pointer: file path, symbol/key name, or command to run. | SHOULD FIX |

## Mandatory Prompt Structure Rules

1. Prompt must contain `Entry Criteria`.
2. Prompt must contain `Exit Criteria`.
3. Prompt must contain a skill suggestion step that asks which skills should be used and provides relevant defaults.
4. Prompt must include AGENTS-first startup steps aligned to:
   - `.agents/AGENTS.md`
   - `.agents/FRAMEWORK.md`
   - `.app-info/ROUTING.md`
5. Prompt must not contain stale path conventions that contradict AGENTS or ROUTING.

## Deterministic Skill Mapping

| Prompt signal | Default skills |
|---|---|
| Studio Pro integration, dockable UI, routes, mx tooling, `.mpr` runtime behaviour | `.app-info/skills/mendix-studio-pro-10/SKILL.md` |
| Mendix SDK model operations and repository integration | `.app-info/skills/mendix-sdk/SKILL.md` |
| Dump diff semantics, parser extraction, rule alignment | `.app-info/skills/mendix-model-dump-inspection/SKILL.md` |
| Full model overview export architecture and pseudocode outputs | `.app-info/skills/mendix-model-overview-export/SKILL.md` |
| Parser structuring and schema pipeline (`schemaVersion: 2.0`) | `.app-info/skills/mendix-commit-structuring/SKILL.md` |
| Technical commit message generation from export payloads | `.app-info/skills/mendix-technical-commit-message/SKILL.md` |
| Cross-cutting validation and documentation quality | `.agents/skills/testing/SKILL.md`, `.agents/skills/documentation/SKILL.md` |

## Conflict Severity Rules

### MUST FIX

1. Missing `Entry Criteria`, `Exit Criteria`, or skill suggestion step.
2. Contradiction with AGENTS/FRAMEWORK/ROUTING rules.
3. Mandatory path references that do not exist.
4. Instructions that force guessing when repository evidence is required.

### SHOULD FIX

1. Non-operational wording that is still understandable.
2. Duplicated or noisy instructions.
3. Weakly specified validation or compatibility notes that do not break execution.

## Validation Checklist For Prompt Refiner Runs

1. Compliance test: missing required sections are flagged with concrete patch proposals.
2. Hard-pointer test: vague locator language is replaced by verified paths.
3. Missing-reference test: absent artefacts are reported as blockers with discovery TODO steps.
4. Skill-mapping test: selected default skills match this table.
5. Conflict test: AGENTS/framework conflicts are labelled with `MUST FIX` or `SHOULD FIX`.
6. Approval-gate test: no prompt files are edited before explicit approval (unless `AUTO_APPROVE`).
7. Logging test: accepted refinements append an entry to `.app-info/memory/PROMPT_CHANGES.md`.
