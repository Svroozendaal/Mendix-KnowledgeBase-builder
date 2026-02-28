# Masterprompt A0 - Auto-detect Mendix Version and mx.exe Path
**Status: Implement immediately - Phase A (runs before all other features)**
**Complexity: Low-Medium**

---

## Goal

Eliminate manual Mendix version/path configuration by auto-detecting the correct `mx.exe` at extension startup, with a Settings fallback for detection failures.

## Entry Criteria

1. Clarifying workflow questions have been asked as needed.
2. Scope and non-goals are confirmed.
3. Existing `MxToolService` behaviour and public interface are understood.
4. Startup path resolution flow is understood from the existing extension entry points.

## Required First Action

1. Read `.agents/AGENTS.md`.
2. Read `.agents/FRAMEWORK.md`.
3. Read `.app-info/ROUTING.md`.
4. Read `.app-info/development/prompts/OVERVIEW.md`.
5. Read:
   - `studio-pro-extension-csharp/Processing/Services/MxToolService.cs`
   - `studio-pro-extension-csharp/UI/DockablePane/AutoCommitMessageDockablePaneExtension.cs`
   - `studio-pro-extension-csharp/UI/Web/AutoCommitMessageWebServerExtension.cs`
   - `studio-pro-extension-csharp/UI/Web/AutoCommitMessagePanelHtml.cs`

## Skill Suggestion Step

Ask: "Which skills should be used for this prompt?"

Default suggestions:
- `.app-info/skills/mendix-studio-pro-10/SKILL.md`
- `.agents/skills/testing/SKILL.md`
- `.agents/skills/documentation/SKILL.md`

---

## Background

The extension currently relies on development-time `.env` values for Mendix install path/version. End users should not need this configuration. The extension should detect the correct `mx.exe` automatically from project context.

Detection logic:
1. Run `mx.exe show-version <mprFilePath>` to get required Mendix version.
2. Resolve installation under `C:\Program Files\Mendix\`.
3. Build full path to `mx.exe`.
4. Use Settings manual override when detection fails.

---

## Confirmed Current Code Pointers

1. `mx.exe` invocation entry point:
   - `studio-pro-extension-csharp/Processing/Services/MxToolService.cs`
2. Extension startup and project-path resolution:
   - `studio-pro-extension-csharp/UI/DockablePane/AutoCommitMessageDockablePaneExtension.cs` in `Open()` via `CurrentApp?.Root?.DirectoryPath`
3. Web route handling and query parameter flow:
   - `studio-pro-extension-csharp/UI/Web/AutoCommitMessageWebServerExtension.cs`
4. Settings and localStorage UI:
   - `studio-pro-extension-csharp/UI/Web/AutoCommitMessagePanelHtml.cs`

---

## What you need to implement

### 1. New service: `MendixInstallationDetectorService`

Create:
- `studio-pro-extension-csharp/Processing/Services/MendixInstallationDetectorService.cs`

```csharp
/// <summary>
/// Detects the correct mx.exe path for a given Mendix project by:
///   1. Running mx.exe show-version on the .mpr file to determine the required version.
///   2. Scanning the Mendix installations root (default: C:\Program Files\Mendix\)
///      for a matching version folder.
///   3. Returning the full path to mx.exe within that folder.
///
/// Detection steps in order:
///   Step 1 - Determine required version:
///     Run: <any available mx.exe> show-version <mprFilePath>
///     To bootstrap this, scan the installations root for any installed version
///     and use the first found mx.exe to run show-version. The version string
///     returned identifies which installation the project needs.
///
///   Step 2 - Find matching installation:
///     Look for C:\Program Files\Mendix\<requiredVersion>\modeler\mx.exe
///     Match on exact version string as returned by show-version.
///
///   Step 3 - Fallback:
///     If no exact match is found, attempt a major.minor match (e.g. 10.24.x).
///     Log a warning if fallback matching is used.
///
/// The installations root can be overridden via the Settings UI or the
/// MENDIX_INSTALL_ROOT environment variable.
/// </summary>
public class MendixInstallationDetectorService
{
    public DetectionResult Detect(string mprFilePath, string? installRootOverride = null) { ... }
}

public record DetectionResult
{
    public bool Success { get; init; }
    public string? MxExePath { get; init; }
    public string? DetectedVersion { get; init; }
    public string? InstallRoot { get; init; }
    public string? FailureReason { get; init; }
}
```

Install root resolution order:
1. `installRootOverride` parameter (from Settings UI)
2. Environment variable `MENDIX_INSTALL_ROOT`
3. Default: `C:\Program Files\Mendix\`

### 2. Integration at extension startup

Use confirmed startup flow:
1. Start from `studio-pro-extension-csharp/UI/DockablePane/AutoCommitMessageDockablePaneExtension.cs` (`Open()`).
2. Reuse the project path already resolved there (`CurrentApp?.Root?.DirectoryPath`) and passed through `projectPath` query parameter.
3. Call `MendixInstallationDetectorService.Detect(mprFilePath)`.
4. Store detection result in shared configuration/context used by `MxToolService`.
5. If detection fails, store failure reason and surface it in Settings UI.

Trigger detection:
- Once at startup.
- Again when user saves manual install-root override.
- Again when user clicks "Re-detect" in Settings.

### 3. `MxToolService` integration

Update:
- `studio-pro-extension-csharp/Processing/Services/MxToolService.cs`

Requirements:
- Keep public interface and method signatures unchanged.
- Replace current `mx.exe` path source with detector result.
- If no valid path is available, throw descriptive user-facing error.

### 4. Settings UI

Update:
- `studio-pro-extension-csharp/UI/Web/AutoCommitMessagePanelHtml.cs`

Add section: **Mendix Installation**

Display (read-only, always visible):
- Detected version (example: `10.24.15`)
- Detected mx.exe path (example: `C:\Program Files\Mendix\10.24.15\modeler\mx.exe`)
- Status indicator:
  - green: `Detected automatically`
  - amber: `Using manual override`
  - red: `Detection failed - manual path required`

Override (editable):
- Input: `Mendix installations folder`
- Button: `Re-detect`
- Persist override in localStorage key: `mendixInstallRoot`

When detection fails:
- Show prominent inline error with failure reason.
- Disable Refresh and Export actions until valid `mx.exe` path is confirmed.
- Do not show blocking modal.

### 5. Remove `.env` dependency for Mendix path/version

Replace runtime reads of Mendix path/version from `.env` or dev-only env keys with detector output.

Do not delete `.env`.

Add comment where removal occurs:

```csharp
// Previously read from .env (MendixVersion / MendixInstallPath).
// Now resolved automatically by MendixInstallationDetectorService at startup.
```

---

## Documentation requirements

1. Add XML comment block at top of `MendixInstallationDetectorService.cs` (as above).
2. Update:
   - `studio-pro-extension-csharp/Docs/ARCHITECTURE.md`
3. Add section: **Mendix Installation Detection** covering:
   - detection algorithm (3 steps)
   - install root resolution order
   - detection failure behaviour
   - manual override behaviour
   - `.env` no longer used for Mendix path config

---

## Constraints

- `MxToolService` public interface must not change.
- Detection must not block the Studio Pro UI thread.
- Do not hardcode `C:\Program Files\Mendix\` more than once.
- Do not add new NuGet dependencies.
- Use `System.Diagnostics.Process` for `mx.exe show-version`.
- Do not delete `.env`.

---

## Deliverables

1. `studio-pro-extension-csharp/Processing/Services/MendixInstallationDetectorService.cs` (new).
2. Updated startup integration (`AutoCommitMessageDockablePaneExtension` / startup flow wiring).
3. Updated `studio-pro-extension-csharp/Processing/Services/MxToolService.cs`.
4. Updated `studio-pro-extension-csharp/UI/Web/AutoCommitMessagePanelHtml.cs`.
5. Removed runtime Mendix path/version `.env` dependency with explanatory comments.
6. Updated `studio-pro-extension-csharp/Docs/ARCHITECTURE.md`.
7. Unit tests for:
   - exact version match
   - major.minor fallback
   - no match found
   - empty install root

---

## Acceptance criteria

- [ ] On clean install without `.env`, extension detects `mx.exe` automatically and Settings shows green status.
- [ ] Exact version match shows no warning.
- [ ] Major.minor fallback shows warning and extension continues.
- [ ] No match shows red error, Refresh/Export disabled, install-root input editable.
- [ ] Clicking `Re-detect` after correcting install root updates status.
- [ ] Override persists in localStorage (`mendixInstallRoot`).
- [ ] `MxToolService` public interface is unchanged.
- [ ] No hardcoded `mx.exe` path strings remain outside detector service.
- [ ] `ARCHITECTURE.md` contains Mendix installation detection section.
- [ ] Unit tests pass for all four detector scenarios.

## Exit Criteria

1. All deliverables are implemented.
2. Acceptance criteria pass.
3. Prompt updates are documented in `.app-info/memory/PROMPT_CHANGES.md` when accepted.
