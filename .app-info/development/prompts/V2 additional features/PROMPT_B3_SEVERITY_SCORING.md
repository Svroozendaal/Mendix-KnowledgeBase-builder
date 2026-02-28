# Masterprompt B3 - Change Severity Scoring
**Status: Implement immediately**
**Complexity: Medium**

---

## Goal

Add additive severity metadata (`Breaking`, `Risky`, `Informational`) to model changes across diff, export, and UI layers without breaking existing contracts.

## Entry Criteria

1. Clarifying workflow questions have been asked as needed.
2. Scope and non-goals are confirmed.
3. Current model-change contract and export schema are verified from source.
4. Existing model-changes UI rendering path is reviewed.

## Required First Action

1. Read `.agents/AGENTS.md`.
2. Read `.agents/FRAMEWORK.md`.
3. Read `.app-info/ROUTING.md`.
4. Read `.app-info/development/prompts/OVERVIEW.md`.
5. Read:
   - `studio-pro-extension-csharp/Processing/Contracts/MendixModelChange.cs`
   - `studio-pro-extension-csharp/Processing/ModelDiff/MendixModelDiffService.cs`
   - `studio-pro-extension-csharp/Processing/ModelDiff/MendixModelChangeStructurer.cs`
   - `studio-pro-extension-csharp/Processing/Formatting/MendixModelChangeDisplayTextFormatter.cs`
   - `studio-pro-extension-csharp/Processing/Services/AutoCommitMessageExportService.cs`
   - `studio-pro-extension-csharp/UI/Web/AutoCommitMessagePanelHtml.cs`
   - `studio-pro-extension-csharp/Docs/EXPORT_CONTRACT.md`

## Skill Suggestion Step

Ask: "Which skills should be used for this prompt?"

Default suggestions:
- `.app-info/skills/mendix-model-dump-inspection/SKILL.md`
- `.app-info/skills/mendix-studio-pro-10/SKILL.md`
- `.agents/skills/testing/SKILL.md`
- `.agents/skills/documentation/SKILL.md`

---

## Your role

You are an expert C# developer working on a Mendix Studio Pro 10 extension called `AutoCommitMessage`. Your job is to add a severity scoring system that is pure, testable, and contract-safe.

---

## Confirmed current pointers

1. Change contract:
   - `studio-pro-extension-csharp/Processing/Contracts/MendixModelChange.cs`
2. Diff construction:
   - `studio-pro-extension-csharp/Processing/ModelDiff/MendixModelDiffService.cs`
3. Grouping:
   - `studio-pro-extension-csharp/Processing/ModelDiff/MendixModelChangeStructurer.cs`
4. Display text:
   - `studio-pro-extension-csharp/Processing/Formatting/MendixModelChangeDisplayTextFormatter.cs`
5. Export schema baseline:
   - `studio-pro-extension-csharp/Processing/Services/AutoCommitMessageExportService.cs` (currently `1.0`)
6. UI model-change list rendering:
   - `studio-pro-extension-csharp/UI/Web/AutoCommitMessagePanelHtml.cs`

---

## What you need to implement

### 1. Severity enum

Create:
- `studio-pro-extension-csharp/Processing/ModelDiff/MendixModelChangeSeverity.cs`

```csharp
public enum MendixModelChangeSeverity
{
    Breaking,
    Risky,
    Informational
}
```

### 2. Severity scorer

Create:
- `studio-pro-extension-csharp/Processing/ModelDiff/MendixModelChangeSeverityScorer.cs`

Public API:

```csharp
public MendixModelChangeSeverity Score(MendixModelChange change)
```

Baseline rules:

| Condition | Severity |
|---|---|
| Entity attribute removed | Breaking |
| Entity removed | Breaking |
| Association removed | Breaking |
| Microflow parameter removed or type changed | Breaking |
| Page removed | Breaking |
| Java action signature changed | Breaking |
| Entity attribute added (non-required) | Informational |
| Entity added | Informational |
| Microflow added | Informational |
| Page added | Informational |
| Microflow logic changed (actions modified) | Risky |
| Page layout/widget changed | Risky |
| Association cardinality changed | Risky |
| Default fallback | Risky |

Keep rule definitions easy to extend.

### 3. Extend `MendixModelChange`

Update:
- `studio-pro-extension-csharp/Processing/Contracts/MendixModelChange.cs`

Add property:
- `Severity` of type `MendixModelChangeSeverity`

Populate in diff creation path:
- `studio-pro-extension-csharp/Processing/ModelDiff/MendixModelDiffService.cs`

### 4. Export severity and bump schema

Update:
- `studio-pro-extension-csharp/Processing/Services/AutoCommitMessageExportService.cs`

Requirements:
- Include `severity` field on each change record.
- Bump schema from `1.0` to `1.1`.
- Add code comment documenting this contract bump.
- Update export contract documentation:
  - `studio-pro-extension-csharp/Docs/EXPORT_CONTRACT.md`

### 5. Surface severity in UI

Update:
- `studio-pro-extension-csharp/UI/Web/AutoCommitMessagePanelHtml.cs`

Requirements:
1. Add severity indicator per change row:
   - Breaking: red
   - Risky: amber/orange
   - Informational: grey/blue
2. Respect existing dark/light theme.
3. Add client-side filter dropdown:
   - `All`
   - `Breaking`
   - `Risky`
   - `Informational`
4. Do not redesign other sections.

---

## Constraints

- Scorer must be pure domain logic (no UI/export dependencies).
- Severity logic must be unit-testable in isolation.
- `displayText` output format must remain unchanged.
- Do not change route API surface.
- Schema bump to `1.1` is mandatory.

---

## Deliverables

1. `studio-pro-extension-csharp/Processing/ModelDiff/MendixModelChangeSeverity.cs` (new).
2. `studio-pro-extension-csharp/Processing/ModelDiff/MendixModelChangeSeverityScorer.cs` (new).
3. Updated `studio-pro-extension-csharp/Processing/Contracts/MendixModelChange.cs`.
4. Updated `studio-pro-extension-csharp/Processing/ModelDiff/MendixModelDiffService.cs`.
5. Updated `studio-pro-extension-csharp/Processing/Services/AutoCommitMessageExportService.cs`.
6. Updated `studio-pro-extension-csharp/UI/Web/AutoCommitMessagePanelHtml.cs`.
7. Updated `studio-pro-extension-csharp/Docs/EXPORT_CONTRACT.md`.
8. Unit tests covering:
   - one Breaking rule
   - one Risky rule
   - one Informational rule
   - default fallback

---

## Acceptance criteria

- [ ] Every `MendixModelChange` has non-null `Severity`.
- [ ] Export includes `"severity"` on all change records.
- [ ] Export schema version is `"1.1"`.
- [ ] UI shows red indicator for Breaking changes.
- [ ] Client-side severity filter works.
- [ ] Scorer has no compile-time dependency on UI/export namespaces.
- [ ] Unit tests pass.

## Exit Criteria

1. All deliverables completed.
2. Acceptance criteria pass.
3. Prompt updates are documented in `.app-info/memory/PROMPT_CHANGES.md` when accepted.
