# Masterprompt B2 - Cross-Module Impact Detection
**Status: Future development**
**Complexity: High**

---

## Goal

Design and implement a second-pass analyser that detects cross-module dependencies and annotates model changes with downstream impact metadata.

## Entry Criteria

1. Clarifying workflow questions have been asked as needed.
2. Scope and non-goals are confirmed.
3. Design phase output format is agreed before implementation begins.
4. Export schema baseline is verified in source.
5. If schema baseline is not `1.1` yet, versioning sequence is explicitly agreed before coding.

## Required First Action

1. Read `.agents/AGENTS.md`.
2. Read `.agents/FRAMEWORK.md`.
3. Read `.app-info/ROUTING.md`.
4. Read `.app-info/development/prompts/OVERVIEW.md`.
5. Read:
   - `studio-pro-extension-csharp/Processing/Services/AutoCommitMessageChangeService.cs`
   - `studio-pro-extension-csharp/Processing/Services/AutoCommitMessageExportService.cs`
   - `studio-pro-extension-csharp/Processing/ModelDiff/MendixModelOverviewParser.cs`
   - `studio-pro-extension-csharp/Processing/Services/AutoCommitMessageModelOverviewService.cs`
   - `studio-pro-extension-csharp/Processing/Contracts/MendixModelChange.cs`
   - `studio-pro-extension-csharp/UI/Web/AutoCommitMessagePanelHtml.cs`
   - `studio-pro-extension-csharp/Docs/PROCESSING_PIPELINE.md`
6. Verify current export schema constant in `AutoCommitMessageExportService` before version planning.

## Skill Suggestion Step

Ask: "Which skills should be used for this prompt?"

Default suggestions:
- `.app-info/skills/mendix-model-dump-inspection/SKILL.md`
- `.app-info/skills/mendix-model-overview-export/SKILL.md`
- `.app-info/skills/mendix-studio-pro-10/SKILL.md`
- `.agents/skills/testing/SKILL.md`
- `.agents/skills/documentation/SKILL.md`

---

## Your role

You are an expert C# developer working on a Mendix Studio Pro 10 extension called `AutoCommitMessage`. Your job is to introduce cross-module impact detection in a way that is performant, contract-safe, and reviewable.

---

## Design phase first (mandatory)

Before implementation, produce a design document that covers:

1. Dependency model: concrete cross-module reference patterns from real dump structures.
2. Reference index design: data structures, lookup key strategy, memory profile.
3. Impact algorithm: how changed elements map to impacted elements in other modules.
4. Contract extension: exact JSON shape and backward compatibility strategy.
5. Performance budget: target limits and measurement approach.

Submit this design for review and approval before coding.

---

## Confirmed current pointers

1. Primary diff orchestration:
   - `studio-pro-extension-csharp/Processing/Services/AutoCommitMessageChangeService.cs`
2. Export serialization and schema constant:
   - `studio-pro-extension-csharp/Processing/Services/AutoCommitMessageExportService.cs`
3. Overview parsing (candidate source for reusable parsed structures):
   - `studio-pro-extension-csharp/Processing/ModelDiff/MendixModelOverviewParser.cs`
4. Overview generation/listing flow:
   - `studio-pro-extension-csharp/Processing/Services/AutoCommitMessageModelOverviewService.cs`
5. Model-change contract:
   - `studio-pro-extension-csharp/Processing/Contracts/MendixModelChange.cs`
6. UI model-change rendering:
   - `studio-pro-extension-csharp/UI/Web/AutoCommitMessagePanelHtml.cs`

---

## Proposed architecture (baseline)

### New data structure

```csharp
public record CrossModuleImpact
{
    public string AffectedModule { get; init; }
    public string AffectedElementName { get; init; }
    public string AffectedElementType { get; init; }
    public string ReferenceKind { get; init; }
    public MendixModelChangeSeverity ImpliedSeverity { get; init; }
}
```

Add:
- `CrossModuleImpacts` collection to `MendixModelChange`

### New analyser service

Create:
- `studio-pro-extension-csharp/Processing/ModelDiff/MendixCrossModuleImpactAnalyser.cs`

Inputs:
- primary diff `MendixModelChange` list
- committed model dump/parsed structures

Output:
- same change list annotated with `CrossModuleImpacts`

### New reference index

Create:
- `studio-pro-extension-csharp/Processing/ModelDiff/MendixModelReferenceIndex.cs`

Responsibilities:
- build once per refresh
- map stable element key -> reference locations
- avoid per-change rebuild

---

## Integration points

1. Call analyser in:
   - `studio-pro-extension-csharp/Processing/Services/AutoCommitMessageChangeService.cs`
   - after primary diff
   - before payload return
2. Reuse existing overview parsing flow where feasible to avoid duplicate parsing.
3. Update export payload in:
   - `studio-pro-extension-csharp/Processing/Services/AutoCommitMessageExportService.cs`

Schema rule:
- Target schema version for this feature: `1.2`.
- Precondition: schema `1.1` already exists (severity scoring merged).
- If baseline is still `1.0`, stop and align version sequencing with user before implementation.

---

## UI changes

Update:
- `studio-pro-extension-csharp/UI/Web/AutoCommitMessagePanelHtml.cs`

Requirements:
1. Add expandable impact section under change rows when impacts exist.
2. Add summary banner when any impacts are present.
3. Add Settings toggle: `Enable cross-module impact analysis`.
4. When toggle is off:
   - analyser does not run
   - `CrossModuleImpacts` is empty array

---

## Constraints

- No extra `mx.exe` invocations for this feature.
- Keep primary diff performance unaffected when analysis is disabled or no impacts exist.
- Do not modify existing `MendixModelChange` fields except additive `CrossModuleImpacts`.
- Keep route surface unchanged unless explicitly approved.

---

## Deliverables

1. Design document approved before implementation.
2. `studio-pro-extension-csharp/Processing/ModelDiff/MendixModelReferenceIndex.cs` (new).
3. `studio-pro-extension-csharp/Processing/ModelDiff/MendixCrossModuleImpactAnalyser.cs` (new).
4. Updated `studio-pro-extension-csharp/Processing/Contracts/MendixModelChange.cs`.
5. Updated `studio-pro-extension-csharp/Processing/Services/AutoCommitMessageChangeService.cs`.
6. Updated `studio-pro-extension-csharp/Processing/Services/AutoCommitMessageExportService.cs`.
7. Updated `studio-pro-extension-csharp/UI/Web/AutoCommitMessagePanelHtml.cs`.
8. Integration test with two-module reference scenario.

---

## Acceptance criteria

- [ ] Cross-module reference impacts are attached to relevant change records.
- [ ] Disabled setting bypasses analyser and returns empty impact arrays.
- [ ] Export contains `crossModuleImpacts` for each change.
- [ ] Schema version update is correctly applied according to agreed version sequence.
- [ ] UI shows impact details and summary banner when applicable.
- [ ] Reference index is built once per refresh.
- [ ] Integration test passes.

## Exit Criteria

1. Design is approved and implementation completed accordingly.
2. Acceptance criteria pass.
3. Prompt updates are documented in `.app-info/memory/PROMPT_CHANGES.md` when accepted.
