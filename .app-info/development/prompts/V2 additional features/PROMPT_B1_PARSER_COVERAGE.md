# Masterprompt B1 - Expand Parser Coverage for Missing Mendix Resource Types
**Status: Future development**
**Complexity: Medium per resource type (incremental)**

---

## Goal

Expand semantic diff coverage so high-value Mendix resource types produce type-specific `MendixModelChange` records instead of generic property-diff summaries.

## Entry Criteria

1. Clarifying workflow questions have been asked as needed.
2. Scope and non-goals are confirmed.
3. A dump sample for at least one target resource type is available.
4. Current diff/structuring/display flow is reviewed in source.

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
6. Read dump-parsing skill guidance:
   - `.app-info/skills/mendix-model-dump-inspection/SKILL.md`

## Skill Suggestion Step

Ask: "Which skills should be used for this prompt?"

Default suggestions:
- `.app-info/skills/mendix-model-dump-inspection/SKILL.md`
- `.app-info/skills/mendix-studio-pro-10/SKILL.md`
- `.agents/skills/testing/SKILL.md`
- `.agents/skills/documentation/SKILL.md`

---

## Your role

You are an expert C# developer working on a Mendix Studio Pro 10 extension called `AutoCommitMessage`. Your job is to add type-specific parser coverage for unsupported Mendix resource types while keeping fallback behaviour intact.

---

## Confirmed current pointers

1. Diff engine entry point:
   - `studio-pro-extension-csharp/Processing/ModelDiff/MendixModelDiffService.cs` (`CompareDumps(...)`)
2. Model-change grouping:
   - `studio-pro-extension-csharp/Processing/ModelDiff/MendixModelChangeStructurer.cs`
3. Display text formatting:
   - `studio-pro-extension-csharp/Processing/Formatting/MendixModelChangeDisplayTextFormatter.cs`
4. Known limitation reference:
   - `studio-pro-extension-csharp/Docs/ARCHITECTURE.md` (generic summary limitation)
5. Processing responsibilities reference:
   - `studio-pro-extension-csharp/Docs/PROCESSING_PIPELINE.md`

Note:
- There is currently no dedicated `PARSER_GAP_ANALYSIS.md` file in `studio-pro-extension-csharp/Docs/`.
- If this analysis document is required for planning, create it in the same feature branch before implementation work starts.

---

## Scope for this session

Implement one resource type at a time (independent, mergeable units), in this priority order:

### Priority 1: Constants
- Candidate dump type key to verify: `System$Constant`
- Meaningful changes: value changed, type changed, added, removed

### Priority 2: Scheduled Events
- Candidate dump type key to verify: `System$ScheduledEvent`
- Meaningful changes: enabled/disabled, interval changed, target microflow changed, added, removed

### Priority 3: Consumed REST Services
- Meaningful changes: base URL changed, operation added/removed, authentication changed

### Priority 4: Published REST Services
- Meaningful changes: operation added/removed, microflow mapping changed, security changed

### Priority 5: Java Actions
- Meaningful changes: parameter added/removed/type changed, return type changed, added, removed

---

## Implementation workflow per resource type

1. Obtain sample dump JSON for the specific type from persisted dumps.
   - Use paths from export payload `modelDumpArtifact.*` or resolved dumps under `<DataRoot>/dumps/`.
2. Verify exact `$Type` discriminator and payload shape from dump data.
3. Add dedicated parser logic in:
   - `studio-pro-extension-csharp/Processing/ModelDiff/MendixModelDiffService.cs`
4. Update module/category grouping if required in:
   - `studio-pro-extension-csharp/Processing/ModelDiff/MendixModelChangeStructurer.cs`
5. Add deterministic, human-readable `displayText` handling in:
   - `studio-pro-extension-csharp/Processing/Formatting/MendixModelChangeDisplayTextFormatter.cs`
6. Add isolated tests for the new type using anonymised dump snippets.
7. Document ambiguities and verified dump keys.

---

## Constraints

- Do not change `MendixModelChange` record shape in this prompt.
- Do not change export contract shape.
- Keep generic fallback for unknown types.
- Implement and test each type independently; do not bundle all priorities in one change.
- If dump shape is ambiguous, add explicit TODO with exact unknown field/key and keep safe fallback.

---

## Deliverables (per resource type)

1. Updated `studio-pro-extension-csharp/Processing/ModelDiff/MendixModelDiffService.cs`.
2. Updated `studio-pro-extension-csharp/Processing/ModelDiff/MendixModelChangeStructurer.cs` (if needed).
3. Updated `studio-pro-extension-csharp/Processing/Formatting/MendixModelChangeDisplayTextFormatter.cs`.
4. Unit tests for the specific resource type parser.
5. Short ambiguity note (verified keys, unresolved structure details, fallback behaviour).

---

## Acceptance criteria (per resource type)

- [ ] Changes for that resource type no longer produce only generic "property changed" output.
- [ ] `displayText` is meaningful and deterministic.
- [ ] Change is grouped under correct module/category in UI.
- [ ] Unit tests pass for the new type.
- [ ] Generic fallback remains functional for unsupported types.

## Exit Criteria

1. Deliverables completed for at least one selected priority type.
2. Acceptance criteria pass for implemented type(s).
3. Prompt updates are documented in `.app-info/memory/PROMPT_CHANGES.md` when accepted.
