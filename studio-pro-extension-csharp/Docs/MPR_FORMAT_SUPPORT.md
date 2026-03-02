# MPR Format Support

## Overview

Mendix projects can use one of two storage formats for project model data:

- **MPR v1 (Legacy)**: Model data stored in the .mpr file itself
- **MPR v2 (Modern)**: Model data distributed across mprcontents/ directory

This document explains how the extension detects and handles differences between these formats.

## Format Detection

### Detection Rule

The `MendixMprFormatDetector` identifies the MPR format by checking for the presence of a `mprcontents` directory next to the .mpr file:

```
MyProject/
  App.mpr                  <- v1: no mprcontents directory nearby
  ... other files ...

OR

MyProject/
  App.mpr                  <- v2: mprcontents directory present
  mprcontents/
    SystemModule/
    CustomModule/
    ...
```

**Detection Logic:**
- If `mprcontents/` directory exists next to the .mpr file → **MPR v2**
- If `mprcontents/` directory does not exist → **MPR v1**
- On any error (invalid path, permission issues) → Default to **MPR v1**

## Format-Specific Behavior

### MPR v1 (Legacy Format)

| Feature | Behavior | Notes |
|---------|----------|-------|
| **Module Filtering** | Post-diff UI filtering only | Backend refresh pipeline is unchanged; all modules are analyzed |
| **Refresh Performance** | Standard | All modules dump/diff in every refresh |
| **Module Filter Notice** | Shown to user | "Module filtering is applied after analysis. Upgrade to MPR v2 for faster pre-analysis filtering." |
| **list-change-modules Endpoint** | Returns empty module list | `supportsPreFilter: false` |

### MPR v2 (Modern Format)

| Feature | Behavior | Notes |
|---------|----------|-------|
| **Module Filtering** | Pre-diff backend filtering | Unselected modules skipped from dump/diff work entirely |
| **Refresh Performance** | Optimized | Only selected modules are analyzed; faster refreshes |
| **Module Detection** | Automatic from mprcontents/ | Changed modules extracted from git status on mprcontents files |
| **list-change-modules Endpoint** | Returns changed modules | `supportsPreFilter: true`; modules extracted dynamically |

## Implementation Details

### Module Filtering Workflow

#### MPR v2 with Pre-Diff Filtering

1. User opens pane; extension queries `/list-change-modules`
2. Detector identifies MPR v2 format
3. `MendixV2ChangedModuleDetector` extracts changed modules from git status
4. UI displays module selection with changed modules pre-selected
5. User clicks Refresh with selected modules
6. `moduleFilter` query parameter passed to `/refresh` endpoint
7. `AnalyzeMprChanges` checks if MPR v2 and moduleFilter provided
8. For each .mpr file, module name extracted; if not in filter list, analysis skipped
9. Filtered model changes returned to UI

#### MPR v1 with Post-Diff Filtering

1. User opens pane; extension queries `/list-change-modules`
2. Detector identifies MPR v1 format (no mprcontents/)
3. `supportsPreFilter: false` returned; empty module list
4. UI shows message: "Module filtering is applied after analysis..."
5. User clicks Refresh (no pre-filtering available)
6. Full refresh pipeline executes; all modules analyzed
7. Model changes grouped by module returned to UI
8. UI applies client-side filtering based on user selection
9. Unselected modules hidden in UI (but were analyzed server-side)

### Changed Module Detection (MPR v2)

The `MendixV2ChangedModuleDetector` uses git status to identify modules with changes:

1. Retrieve git status for all files
2. Filter to files under `mprcontents/` directory
3. Extract module name from path pattern: `mprcontents/<ModuleName>/<files>`
4. Deduplicate module names
5. Return sorted list

**Path Pattern Examples:**
- `mprcontents/MyModule/database.yaml` → module: `MyModule`
- `mprcontents/System/config.yaml` → module: `System`
- `mprcontents/MyModule/flows/ProcessA.mxflow` → module: `MyModule`

## Upgrade Notes

### For Users: v1 to v2

To upgrade an existing Mendix project from MPR v1 to MPR v2:

1. In Mendix Studio Pro, enable MPR v2 format (Tools > Project Settings > Advanced)
2. Save and commit the project
3. Ensure `mprcontents/` directory is present in git
4. Extension will automatically detect v2 on next use
5. Pre-diff module filtering becomes available

### For Developers

When supporting both formats in features:

- **Always check format first** using `MendixMprFormatDetector.IsMprV2(mprPath)`
- **v2-specific features should degrade gracefully** in v1 (e.g., empty filter list instead of error)
- **Document per-format behavior** in feature descriptions
- **Test against both formats** in unit tests

## Testing

### Format Detection Tests

Test that `MendixMprFormatDetector.IsMprV2()` correctly identifies:

- ✓ v2 projects (mprcontents directory present)
- ✓ v1 projects (no mprcontents directory)
- ✓ Invalid/missing paths
- ✓ Permission errors

### Module Extraction Tests

Test that `MendixV2ChangedModuleDetector.DetectChangedModules()` correctly:

- ✓ Extracts module names from git status
- ✓ Handles mixed module changes
- ✓ Deduplicates module names
- ✓ Returns sorted results
- ✓ Handles repository errors gracefully

### Integration Tests

- ✓ v1 project: `/list-change-modules` returns `supportsPreFilter: false`
- ✓ v2 project: `/list-change-modules` returns `supportsPreFilter: true` with changed modules
- ✓ v2 project + moduleFilter: unselected modules skipped in refresh
- ✓ v1 project + moduleFilter: parameter ignored; all modules analyzed

## Known Limitations

1. **Module Detection Heuristic**: When extracting module names from .mpr file paths, uses directory name heuristic; may not match actual Mendix module names in complex directory structures
2. **v1 Filter Performance**: No server-side optimization; filtering happens in UI only
3. **Mixed Format Projects**: If a project has both v1 and v2 patterns, behavior is undefined; always use consistent format

## Future Enhancements

- [ ] More intelligent module name mapping (from mprcontents structure)
- [ ] Server-side v1 filter optimization
- [ ] Format migration helpers
- [ ] Telemetry on format adoption
