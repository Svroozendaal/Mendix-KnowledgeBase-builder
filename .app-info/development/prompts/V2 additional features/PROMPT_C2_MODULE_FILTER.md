# Masterprompt C2 - Module Filter on Change Analysis (MPR v1 + v2)
**Status: Implement immediately**
**Complexity: Medium-High**

---

## Goal

Add module-level filtering to change analysis with format-aware behaviour:
- MPR v2: pre-diff module selection (skip work)
- MPR v1: post-diff UI filtering only

## Entry Criteria

1. Clarifying workflow questions have been asked as needed.
2. Scope and non-goals are confirmed.
3. Current refresh pipeline and UI refresh flow are verified from source.
4. MPR format detection assumptions are validated against real project structure.

## Required First Action

1. Read `.agents/AGENTS.md`.
2. Read `.agents/FRAMEWORK.md`.
3. Read `.app-info/ROUTING.md`.
4. Read `.app-info/development/prompts/OVERVIEW.md`.
5. Read:
   - `studio-pro-extension-csharp/Processing/Services/AutoCommitMessageChangeService.cs`
   - `studio-pro-extension-csharp/UI/Web/AutoCommitMessageWebServerExtension.cs`
   - `studio-pro-extension-csharp/UI/Web/AutoCommitMessagePanelHtml.cs`
   - `studio-pro-extension-csharp/Processing/Core/ExtensionConstants.cs`
   - `studio-pro-extension-csharp/Docs/PROCESSING_PIPELINE.md`

## Skill Suggestion Step

Ask: "Which skills should be used for this prompt?"

Default suggestions:
- `.app-info/skills/mendix-studio-pro-10/SKILL.md`
- `.app-info/skills/mendix-model-dump-inspection/SKILL.md`
- `.agents/skills/testing/SKILL.md`
- `.agents/skills/documentation/SKILL.md`

---

## Your role

You are an expert C# developer working on a Mendix Studio Pro 10 extension called `AutoCommitMessage`. Your task is to add module filtering in a format-aware way and document why behaviour differs between MPR v1 and MPR v2.

---

## Confirmed current pointers

1. Refresh logic:
   - `studio-pro-extension-csharp/Processing/Services/AutoCommitMessageChangeService.cs`
2. Web route handling:
   - `studio-pro-extension-csharp/UI/Web/AutoCommitMessageWebServerExtension.cs`
3. UI query parameter builder and refresh trigger:
   - `studio-pro-extension-csharp/UI/Web/AutoCommitMessagePanelHtml.cs`
4. Existing query constants:
   - `studio-pro-extension-csharp/Processing/Core/ExtensionConstants.cs`
   - Note: `moduleFilter` and `list-change-modules` constants are not present yet and must be added.
5. Existing use of `mprcontents` in current processing code:
   - `AutoCommitMessageChangeService` HEAD reconstruction helpers
   - `AutoCommitMessageModelOverviewService` reconstruction helpers

---

## Critical prerequisite: MPR format detection

Create:
- `studio-pro-extension-csharp/Processing/ModelDiff/MendixMprFormatDetector.cs`

Required helper:

```csharp
/// <summary>
/// Detects whether a Mendix project uses MPR v2 storage format.
/// Detection rule: presence of 'mprcontents' directory next to the .mpr file.
/// </summary>
public static bool IsMprV2(string mprFilePath) { ... }
```

Use real on-disk project structure to validate this rule before rollout.

---

## Feature behaviour by format

### MPR v2 (pre-diff filtering)

1. Detect changed modules from changed files under `mprcontents/` using Git status.
2. Show module pre-selection in UI before Refresh.
3. Pass selected modules to refresh.
4. Skip dump/diff work for unselected modules.

### MPR v1 (post-diff UI filtering)

1. Keep backend refresh pipeline unchanged.
2. Build module filter list from returned model-change groups after Refresh.
3. Apply filtering in UI only.
4. Show explanatory notice:
   - `Module filtering is applied after analysis. Upgrade to MPR v2 for faster pre-analysis filtering.`

---

## Implementation plan

### 1. Format detector

Create:
- `studio-pro-extension-csharp/Processing/ModelDiff/MendixMprFormatDetector.cs`

### 2. v2 changed-module detector

Create:
- `studio-pro-extension-csharp/Processing/ModelDiff/MendixV2ChangedModuleDetector.cs`

Requirements:
- consume `LibGit2Sharp.IRepository`
- extract module names from changed `mprcontents` paths
- document verified path pattern in code comment

### 3. New route action: `list-change-modules`

Update:
- `studio-pro-extension-csharp/Processing/Core/ExtensionConstants.cs`
- `studio-pro-extension-csharp/UI/Web/AutoCommitMessageWebServerExtension.cs`

Add action constant and route handling:
- action: `list-change-modules`

Response shape:

```json
{
  "mprVersion": "v1" | "v2",
  "modules": ["ModuleA", "ModuleB"],
  "supportsPreFilter": true | false
}
```

### 4. UI module filter panel

Update:
- `studio-pro-extension-csharp/UI/Web/AutoCommitMessagePanelHtml.cs`

Requirements:
- module badges/toggles
- select all / deselect all
- localStorage key: `changeModuleFilter`
- v2: pre-refresh selection + pass `moduleFilter`
- v1: post-refresh client-side filtering + notice text

### 5. Refresh route and backend filter

Update:
- `ExtensionConstants.cs` with `ModuleFilterQueryKey = "moduleFilter"`
- `AutoCommitMessageWebServerExtension.cs` to parse and pass filter
- `AutoCommitMessageChangeService.cs` to apply filter only when `IsMprV2(...) == true`

For v1, ignore backend `moduleFilter`.

---

## Documentation requirements

1. Add XML docs to all new classes and non-trivial methods.
2. Create:
   - `studio-pro-extension-csharp/Docs/MPR_FORMAT_SUPPORT.md`
3. Required sections:
   1. What is MPR v1 vs MPR v2
   2. How format detection works
   3. Behaviour matrix by feature and format
   4. How to verify project format
   5. Upgrade notes (v1 to v2)
4. Update:
   - `studio-pro-extension-csharp/Docs/PROCESSING_PIPELINE.md`
   - add reference to `MPR_FORMAT_SUPPORT.md`

---

## Constraints

- No regression in v1 refresh pipeline.
- `MendixV2ChangedModuleDetector` must not depend on dump pipeline or UI layers.
- `list-change-modules` route must not invoke `mx.exe`.
- Do not add NuGet dependencies unless explicitly required and approved.
- New localStorage key for this feature: `changeModuleFilter` only.

---

## Deliverables

1. `studio-pro-extension-csharp/Processing/ModelDiff/MendixMprFormatDetector.cs` (new).
2. `studio-pro-extension-csharp/Processing/ModelDiff/MendixV2ChangedModuleDetector.cs` (new).
3. Updated `studio-pro-extension-csharp/Processing/Core/ExtensionConstants.cs`.
4. Updated `studio-pro-extension-csharp/UI/Web/AutoCommitMessageWebServerExtension.cs`.
5. Updated `studio-pro-extension-csharp/Processing/Services/AutoCommitMessageChangeService.cs`.
6. Updated `studio-pro-extension-csharp/UI/Web/AutoCommitMessagePanelHtml.cs`.
7. New `studio-pro-extension-csharp/Docs/MPR_FORMAT_SUPPORT.md`.
8. Updated `studio-pro-extension-csharp/Docs/PROCESSING_PIPELINE.md`.
9. Unit tests for format detection and module extraction.

---

## Acceptance criteria

- [ ] v2: pane can list changed modules before Refresh.
- [ ] v2: deselected modules are skipped from backend dump/diff.
- [ ] v2: all-selected behaviour matches current baseline.
- [ ] v1: refresh pipeline remains unchanged.
- [ ] v1: module filter works client-side after refresh.
- [ ] v1: notice text is visible near module filter.
- [ ] `MPR_FORMAT_SUPPORT.md` exists with required sections.
- [ ] Detector/extractor tests pass.

## Exit Criteria

1. Deliverables completed.
2. Acceptance criteria pass.
3. Prompt updates are documented in `.app-info/memory/PROMPT_CHANGES.md` when accepted.
