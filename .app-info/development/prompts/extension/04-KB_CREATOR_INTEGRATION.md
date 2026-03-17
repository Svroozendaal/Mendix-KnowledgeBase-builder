# PROMPT 04: KB Creator Pipeline Integration

## Priority

High — second feature area after Copilot.

## Context

Read before starting:

1. `.app-info/product-plan/12-UNIFIED_EXTENSION_SPEC.md` — architecture overview.
2. Phase 01–03 output — extension infrastructure + Copilot services.
3. `KnowledgeBase-Creator/wizard/src/KnowledgeBaseCreator.Wizard/WizardRuntime.cs` — existing pipeline orchestration.
4. `KnowledgeBase-Creator/Mendix-model-overview-parser/` — parser projects.
5. `KnowledgeBase-Creator/wizard/run-dump-parser.ps1` — pipeline script.
6. `.app-info/product-plan/03-TOOLCHAIN_ARCHITECTURE.md` — pipeline architecture spec.

## Problem Statement

The KB Creator currently runs as a standalone wizard executable or via PowerShell scripts. This phase integrates the pipeline into the extension so users can generate/update the knowledge base directly from Studio Pro.

## Deliverable

### 1. KBCreatorService (C#)

Wrap the existing pipeline steps as a service within the extension:

```csharp
public class KBCreatorService
{
    /// Run the full pipeline (dump → parse → scaffold → compose → validate).
    public async Task RunFullPipelineAsync(
        CreatorConfig config,
        IProgress<PipelineProgress> progress,
        CancellationToken ct);

    /// Run a specific pipeline step.
    public async Task RunStepAsync(
        PipelineStep step,
        CreatorConfig config,
        IProgress<PipelineProgress> progress,
        CancellationToken ct);

    /// Get the current pipeline status.
    public PipelineStatus GetStatus();
}

public enum PipelineStep
{
    Dump,       // mx dump-mpr
    Parse,      // ModelOverviewCli
    Scaffold,   // Create KB folder structure
    Compose,    // Generate markdown files
    Validate    // Run quality gates
}

public record PipelineProgress(
    PipelineStep Step,
    string Message,
    double PercentComplete,
    bool IsError = false);
```

**Integration approaches (choose one):**

A. **Project reference:** Add the wizard and parser projects as project references. Call pipeline methods directly.

B. **Process invocation:** Shell out to `ModelOverviewCli.exe` and `mx dump-mpr` as processes. Parse stdout for progress.

Approach A is preferred for tighter integration and better error handling. Approach B is acceptable if the existing projects have hard-to-resolve dependency conflicts.

### 2. Auto-Detection of App Context

The extension runs inside Studio Pro, which knows the current Mendix app:

- **MPR path:** Detect from `ICurrentApp` (ExtensionsAPI) or discover the `.mpr` file in the app directory.
- **App directory:** The directory containing the MPR file.
- **KB output directory:** `{appDir}/mendix-data/knowledge-base/` (default, configurable).
- **Parser binary:** Bundled alongside the extension DLL in `tools/ModelOverviewCli.exe`.

### 3. Creator Message Handler

```csharp
// CreatorMessageHandler
"creator" / "runFull"     → RunFullPipelineAsync (streaming progress)
"creator" / "runStep"     → RunStepAsync (streaming progress)
"creator" / "getStatus"   → GetStatus
"creator" / "getConfig"   → Load creator-specific config
"creator" / "saveConfig"  → Save creator-specific config
```

### 4. Frontend Creator Tab

Add a "Creator" tab to the React SPA:

**Layout:**
```
┌──────────────────────────────────────────┐
│  Pipeline Configuration                  │
│  ┌────────────────────────────────────┐  │
│  │ MPR Path:    [auto-detected]  [📂] │  │
│  │ Output Dir:  [auto-detected]  [📂] │  │
│  │ Skip Modules: [multi-select]       │  │
│  └────────────────────────────────────┘  │
│                                          │
│  Pipeline Steps                          │
│  ┌────────────────────────────────────┐  │
│  │ ○ Dump MPR      [Run]             │  │
│  │ ○ Parse Model   [Run]             │  │
│  │ ○ Scaffold KB   [Run]             │  │
│  │ ○ Compose KB    [Run]             │  │
│  │ ○ Validate KB   [Run]             │  │
│  │                                    │  │
│  │ [▶ Run Full Pipeline]             │  │
│  └────────────────────────────────────┘  │
│                                          │
│  Log Output                              │
│  ┌────────────────────────────────────┐  │
│  │ [2026-03-17 10:30:01] Starting... │  │
│  │ [2026-03-17 10:30:02] Dumping...  │  │
│  │ ...                                │  │
│  └────────────────────────────────────┘  │
└──────────────────────────────────────────┘
```

**Components:**
- `CreatorTab` — container with config form + pipeline controls.
- `PipelineSteps` — step list with status indicators (pending/running/done/error).
- `PipelineLog` — scrollable log output with auto-scroll.
- `ConfigForm` — MPR path, output dir, skip modules.

### 5. Build Integration

Update the extension build to:
1. Include `ModelOverviewCli.exe` in the output (under `tools/`).
2. Reference or embed the composer/scaffold/validator assemblies.

## Exit Criteria

1. "Creator" tab appears in the SPA.
2. MPR path auto-detected from current Studio Pro app.
3. Full pipeline runs from UI with progress streaming.
4. Individual steps can be run independently.
5. Log output streams in real-time.
6. Generated KB appears in `mendix-data/knowledge-base/`.
7. Validation results displayed after pipeline completes.
8. `dotnet build` succeeds with all new dependencies.

## Out of Scope

- Modifying the pipeline logic itself (only wrapping/exposing it).
- KB quality improvements (separate product plan track).
- mx CLI commands beyond `dump-mpr` (Phase 05).
