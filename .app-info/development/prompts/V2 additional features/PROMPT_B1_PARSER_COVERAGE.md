# Masterprompt B1 - Expand Parser Coverage for Missing Mendix Resource Types
**Status: Future development**
**Complexity: Medium per resource type (incremental)**

---

## Goal

Expand semantic diff coverage so high-value Mendix resource types emit type-specific `MendixModelChange` details, instead of only generic property metadata.

## Entry Criteria

1. Clarifying workflow questions have been asked as needed.
2. Scope, non-goals, and acceptance criteria are confirmed.
3. A real dump sample exists for at least one target resource type.
4. Current diff, structuring, and display flow is reviewed in source.
5. Work sequencing is confirmed as single-type increments (one pull request per type).

## Required First Action

1. Read `.agents/AGENTS.md`.
2. Read `.agents/FRAMEWORK.md`.
3. Read `.app-info/ROUTING.md`.
4. Read `.app-info/development/prompts/OVERVIEW.md`.
5. Read:
   - `studio-pro-extension-csharp/Processing/ModelDiff/MendixModelDiffService.cs`
   - `studio-pro-extension-csharp/Processing/ModelDiff/MendixModelChangeStructurer.cs`
   - `studio-pro-extension-csharp/Processing/Formatting/MendixModelChangeDisplayTextFormatter.cs`
   - `studio-pro-extension-csharp/Docs/ARCHITECTURE.md`
   - `studio-pro-extension-csharp/Docs/PROCESSING_PIPELINE.md`
6. Read skill guidance:
   - `.app-info/skills/mendix-model-dump-inspection/SKILL.md`
   - `.app-info/skills/mendix-studio-pro-10/SKILL.md`
7. Ask: "Which skills should be used for this prompt?" and confirm defaults.
8. Pause at `WAIT_FOR_APPROVAL` before implementation, unless `AUTO_APPROVE` is explicitly provided.

## Skill Suggestion Step

Ask: "Which skills should be used for this prompt?"

Default suggestions:
- `.app-info/skills/mendix-model-dump-inspection/SKILL.md`
- `.app-info/skills/mendix-studio-pro-10/SKILL.md`
- `.agents/skills/testing/SKILL.md`
- `.agents/skills/documentation/SKILL.md`

---

## Your role

You are an expert C# developer working on a Mendix Studio Pro 10 extension called `AutoCommitMessage`. Your job is to add parser coverage for unsupported resource types while preserving existing behaviour and fallback safety.

---

## Confirmed current pointers

1. Diff engine entry point:
   - `studio-pro-extension-csharp/Processing/ModelDiff/MendixModelDiffService.cs` (`CompareDumps(...)`, `AddResourceSpecificDetails(...)`, `BuildResourceSpecificDetails(...)`)
2. Model-change grouping:
   - `studio-pro-extension-csharp/Processing/ModelDiff/MendixModelChangeStructurer.cs`
3. Display text formatting:
   - `studio-pro-extension-csharp/Processing/Formatting/MendixModelChangeDisplayTextFormatter.cs`
4. Generic fallback behaviour:
   - `studio-pro-extension-csharp/Processing/ModelDiff/MendixModelDiffService.cs` (`BuildGenericResourceDetails(...)`)
5. Known limitation reference:
   - `studio-pro-extension-csharp/Docs/ARCHITECTURE.md` (generic summary limitation)
6. Processing responsibilities reference:
   - `studio-pro-extension-csharp/Docs/PROCESSING_PIPELINE.md`

Note:
- There is currently no dedicated `PARSER_GAP_ANALYSIS.md` in `studio-pro-extension-csharp/Docs/`.
- If formal gap tracking is needed, create `studio-pro-extension-csharp/Docs/PARSER_GAP_ANALYSIS.md` before implementation starts.

---

## Scope for this session

Implement one resource type at a time (independent, mergeable units), in this priority order:

### Priority 1: Constants
- Candidate `$Type` to verify: `System$Constant`
- Meaningful changes: value changed, type changed, added, removed

### Priority 2: Scheduled Events
- Candidate `$Type` to verify: `System$ScheduledEvent`
- Meaningful changes: enabled/disabled, interval changed, target microflow changed, added, removed

### Priority 3: Consumed REST Services
- Candidate `$Type` to verify from dumps (do not assume)
- Meaningful changes: base URL changed, operation added/removed, authentication changed

### Priority 4: Published REST Services
- Candidate `$Type` to verify from dumps (do not assume)
- Meaningful changes: operation added/removed, microflow mapping changed, security changed

### Priority 5: Java Actions
- Candidate `$Type` to verify from dumps (do not assume)
- Meaningful changes: parameter added/removed/type changed, return type changed, added, removed

---

## Implementation workflow (per resource type)

1. Inspect dumps and verify exact `$Type`, key fields, and nesting.
   - Source from `modelDumpArtifact.*` pointers or `<DataRoot>/dumps/`.
2. Define change signal mapping before code edits.
   - Added, Deleted, Modified semantics.
   - Which fields drive deterministic detail text.
3. Implement parser-specific detail extraction in:
   - `studio-pro-extension-csharp/Processing/ModelDiff/MendixModelDiffService.cs`
   - Extend `BuildResourceSpecificDetails(...)` with focused handler logic.
4. Keep or improve grouping behaviour in:
   - `studio-pro-extension-csharp/Processing/ModelDiff/MendixModelChangeStructurer.cs`
5. Add deterministic display text output in:
   - `studio-pro-extension-csharp/Processing/Formatting/MendixModelChangeDisplayTextFormatter.cs`
6. Add isolated tests in `studio-pro-extension-csharp-tests/` with anonymised dump fragments.
7. Record ambiguities:
   - Verified `$Type` values.
   - Unknown/unstable keys.
   - Explicit fallback behaviour used.

---

## Determinism rules

For each implemented type:

1. Similar input deltas must produce identical detail text ordering.
2. Added/removed lists must be sorted before formatting.
3. Field labels must be stable and human-readable.
4. Empty or unknown values must not generate misleading statements.

---

## Constraints

- Do not change `MendixModelChange` contract shape in this prompt.
- Do not change export contract/schema in this prompt.
- Keep generic fallback for unknown or partially parsed types.
- Implement one priority type per change; do not batch multiple priority types together.
- If dump shape is ambiguous, add an explicit TODO with exact field/key uncertainty and preserve safe fallback.

---

## Deliverables (per resource type)

1. Updated `studio-pro-extension-csharp/Processing/ModelDiff/MendixModelDiffService.cs`.
2. Updated `studio-pro-extension-csharp/Processing/ModelDiff/MendixModelChangeStructurer.cs` (if needed).
3. Updated `studio-pro-extension-csharp/Processing/Formatting/MendixModelChangeDisplayTextFormatter.cs`.
4. Unit tests for the specific resource type parser in `studio-pro-extension-csharp-tests/`.
5. Short ambiguity note (verified keys, unresolved structure details, fallback behaviour).

---

## Acceptance criteria (per resource type)

- [ ] Changes for that resource type no longer degrade to only generic metadata summaries.
- [ ] `displayText` is meaningful, deterministic, and reviewable.
- [ ] Change rows are grouped under the correct module/category in UI.
- [ ] Unit tests pass for the new parser logic.
- [ ] Generic fallback still works for unsupported or unknown types.

## Exit Criteria

1. Deliverables are completed for at least one selected priority type.
2. Acceptance criteria pass for implemented type(s).
3. Prompt updates are documented in `.app-info/memory/PROMPT_CHANGES.md` when accepted.
