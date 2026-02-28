# Masterprompt C1 - HEAD Dump Caching
**Status: Implement immediately**
**Complexity: Medium**

---

## Goal

Add HEAD dump caching to reduce repeated `mx.exe dump-mpr` calls during refresh while keeping working-tree dump behaviour unchanged.

## Entry Criteria

1. Clarifying workflow questions have been asked as needed.
2. Scope and non-goals are confirmed.
3. Current HEAD dump flow is verified from source.
4. Route/query plumbing points for settings-driven toggles are verified from source.

## Required First Action

1. Read `.agents/AGENTS.md`.
2. Read `.agents/FRAMEWORK.md`.
3. Read `.app-info/ROUTING.md`.
4. Read `.app-info/development/prompts/OVERVIEW.md`.
5. Read:
   - `studio-pro-extension-csharp/Processing/Services/AutoCommitMessageChangeService.cs`
   - `studio-pro-extension-csharp/Processing/Services/MxToolService.cs`
   - `studio-pro-extension-csharp/UI/Web/AutoCommitMessageWebServerExtension.cs`
   - `studio-pro-extension-csharp/UI/Web/AutoCommitMessagePanelHtml.cs`
   - `studio-pro-extension-csharp/Processing/Core/ExtensionConstants.cs`
   - `studio-pro-extension-csharp/Docs/PROCESSING_PIPELINE.md`

## Skill Suggestion Step

Ask: "Which skills should be used for this prompt?"

Default suggestions:
- `.app-info/skills/mendix-studio-pro-10/SKILL.md`
- `.agents/skills/testing/SKILL.md`
- `.agents/skills/documentation/SKILL.md`

---

## Your role

You are an expert C# developer working on a Mendix Studio Pro 10 extension called `AutoCommitMessage`. Your task is to cache HEAD model dumps so repeated refreshes avoid redundant committed-state dump work.

---

## Confirmed current pointers

1. Refresh orchestration and dump flow:
   - `studio-pro-extension-csharp/Processing/Services/AutoCommitMessageChangeService.cs`
   - HEAD dump currently occurs in `AnalyzeMprChanges(...)` via:
     - `TryWriteHeadMpr(...)`
     - `MxToolService.DumpMpr(headMprPath, headDumpPath)`
2. Refresh route handler:
   - `studio-pro-extension-csharp/UI/Web/AutoCommitMessageWebServerExtension.cs` (`HandleRefreshRequestAsync`)
3. UI refresh URL construction and query parameter assembly:
   - `studio-pro-extension-csharp/UI/Web/AutoCommitMessagePanelHtml.cs` (`getActionParameters(...)`, `runRefresh()`)
4. Existing query constants:
   - `studio-pro-extension-csharp/Processing/Core/ExtensionConstants.cs`
   - Note: `headDumpCacheEnabled` query key is not present yet and must be added.

---

## What you need to implement

### 1. Cache key definition

Cache key:

```
<normalized mpr path> + <HEAD commit SHA>
```

Source of values:
- `.mpr` path from status iteration in `AutoCommitMessageChangeService.ReadChanges(...)`
- HEAD SHA from `repository.Head?.Tip?.Sha` (same repository instance used in `ReadChanges(...)`)

### 2. Cache storage location

Store under:

```
<DataRoot>/dumps/head-cache/<commitHash>/<mpr-filename-without-extension>.json
```

Base folders are resolved with existing `ExtensionDataPaths` helpers.

### 3. New service: `AutoCommitMessageHeadDumpCacheService`

Create:
- `studio-pro-extension-csharp/Processing/Services/AutoCommitMessageHeadDumpCacheService.cs`

Responsibilities:
- `bool TryGetCachedDump(string mprPath, string headCommitHash, out string dumpFilePath)`
- `string GetCachePath(string mprPath, string headCommitHash)`
- `void PruneOldCacheEntries(string dataRoot, string currentHeadCommitHash)`

Rules:
- prune once per refresh (not per file)
- prune failures log warning and do not throw

### 4. Integrate with refresh flow

In `AutoCommitMessageChangeService.cs`:
1. Before HEAD `DumpMpr`, attempt cache lookup.
2. On hit, skip HEAD `mx.exe` invocation and reuse cached JSON path.
3. On miss, run current HEAD dump flow, then copy dump into cache path.
4. After refresh batch, prune stale hash folders.

Do not change working-tree dump behaviour.

### 5. Settings toggle and route plumbing

Add settings toggle in:
- `studio-pro-extension-csharp/UI/Web/AutoCommitMessagePanelHtml.cs`

Requirements:
- Label: `Cache HEAD dumps (faster refresh)`
- Default: `true`
- localStorage key: `autocommitmessage.headDumpCacheEnabled`

Add query constant and route wiring:
1. Add query key constant in `ExtensionConstants.cs`:
   - `HeadDumpCacheEnabledQueryKey = "headDumpCacheEnabled"`
2. Include query parameter from UI `getActionParameters(...)`.
3. Parse boolean in `AutoCommitMessageWebServerExtension.HandleRequestAsync(...)`.
4. Pass to `AutoCommitMessageChangeService.ReadChanges(...)` via new optional parameter.

---

## Documentation requirements

1. Add XML summary on `AutoCommitMessageHeadDumpCacheService`.
2. Update:
   - `studio-pro-extension-csharp/Docs/PROCESSING_PIPELINE.md`
3. Document:
   - cache path
   - cache key
   - prune policy
   - settings toggle and disable path

---

## Constraints

- Keep working-tree dump flow unchanged.
- Do not change export contract shape or route names.
- Cache must not serve stale dumps after HEAD changes.
- Prune must be non-blocking and non-throwing.
- No new NuGet dependencies.

---

## Deliverables

1. `studio-pro-extension-csharp/Processing/Services/AutoCommitMessageHeadDumpCacheService.cs` (new).
2. Updated `studio-pro-extension-csharp/Processing/Services/AutoCommitMessageChangeService.cs`.
3. Updated `studio-pro-extension-csharp/UI/Web/AutoCommitMessagePanelHtml.cs`.
4. Updated `studio-pro-extension-csharp/UI/Web/AutoCommitMessageWebServerExtension.cs`.
5. Updated `studio-pro-extension-csharp/Processing/Core/ExtensionConstants.cs`.
6. Updated `studio-pro-extension-csharp/Docs/PROCESSING_PIPELINE.md`.
7. Unit tests for cache hit/miss/prune scenarios.

---

## Acceptance criteria

- [ ] First refresh for a HEAD SHA generates and caches HEAD dump.
- [ ] Subsequent refreshes with same HEAD reuse cache and skip HEAD `mx.exe` dump.
- [ ] HEAD change invalidates prior cache usage automatically.
- [ ] Prune removes old hash folders and keeps current hash folder.
- [ ] Disabling cache in settings restores original behaviour.
- [ ] Unit tests pass for cache service behaviour.
- [ ] Processing pipeline docs include HEAD cache section.

## Exit Criteria

1. Deliverables completed.
2. Acceptance criteria pass.
3. Prompt updates are documented in `.app-info/memory/PROMPT_CHANGES.md` when accepted.
