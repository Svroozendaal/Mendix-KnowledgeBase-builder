<#
.SYNOPSIS
    Scaffold or validate a Knowledge Base folder from a model overview export run.

.DESCRIPTION
    Two modes:
    - Scaffold (default): reads manifest.json from a run folder, creates the KB folder tree,
      copies manifest to _sources/ for traceability.
    - Validate (-Validate): checks that all expected KB files exist and reports missing ones.

.PARAMETER RunFolder
    Path to the model overview export run folder (contains manifest.json).

.PARAMETER OutputRoot
    Root folder for knowledge bases. Default: mendix-data/knowledge-base

.PARAMETER AppName
    Name for this KB. Default: derived from the run folder name.

.PARAMETER Validate
    Switch to validate an existing KB instead of scaffolding a new one.

.EXAMPLE
    .\run-kb-scaffold.ps1 -RunFolder mendix-data/app-overview/cli-test-v2 -AppName SmartExpenses
    .\run-kb-scaffold.ps1 -Validate -OutputRoot mendix-data/knowledge-base -AppName SmartExpenses
#>

param(
    [string]$RunFolder,
    [string]$OutputRoot = "mendix-data/knowledge-base",
    [string]$AppName,
    [switch]$Validate
)

$ErrorActionPreference = "Stop"

# --- Resolve paths ---
if (-not $Validate -and -not $RunFolder) {
    Write-Error "RunFolder is required in scaffold mode. Use -RunFolder <path>"
    exit 1
}

if ($RunFolder) {
    $RunFolder = Resolve-Path $RunFolder -ErrorAction Stop
    $manifestPath = Join-Path $RunFolder "manifest.json"
    if (-not (Test-Path $manifestPath)) {
        Write-Error "manifest.json not found in $RunFolder"
        exit 1
    }
    $manifest = Get-Content $manifestPath -Raw | ConvertFrom-Json
    if ($manifest.schemaVersion -ne "2.0") {
        Write-Error "Expected schema version 2.0, got $($manifest.schemaVersion)"
        exit 1
    }
}

if (-not $AppName) {
    if ($RunFolder) {
        $AppName = Split-Path $RunFolder -Leaf
    } else {
        Write-Error "AppName is required when RunFolder is not specified."
        exit 1
    }
}

$kbRoot = Join-Path $OutputRoot $AppName

# --- Discover modules from manifest ---
function Get-ModulesFromManifest($manifest) {
    $modules = @()
    foreach ($artifact in $manifest.artifacts) {
        if ($artifact.type -eq "module-domain-model-json") {
            $parts = $artifact.path -split '[/\\]'
            # Path pattern: .../modules/<ModuleName>/domain-model.json
            for ($i = 0; $i -lt $parts.Length; $i++) {
                if ($parts[$i] -eq "modules" -and ($i + 2) -lt $parts.Length) {
                    $modules += $parts[$i + 1]
                    break
                }
            }
        }
    }
    return $modules | Sort-Object -Unique
}

# --- Expected file list ---
function Get-ExpectedFiles($modules) {
    $files = @(
        "READER.md",
        "ROUTING.md",
        "app/APP_OVERVIEW.md",
        "app/MODULE_LANDSCAPE.md",
        "app/CALL_GRAPH.md",
        "app/SECURITY.md",
        "routes/by-entity.md",
        "routes/by-page.md",
        "routes/by-flow.md",
        "routes/cross-module.md",
        "_sources/manifest.json"
    )
    foreach ($mod in $modules) {
        $files += "modules/$mod/README.md"
        $files += "modules/$mod/DOMAIN.md"
        $files += "modules/$mod/FLOWS.md"
        $files += "modules/$mod/PAGES.md"
        $files += "modules/$mod/RESOURCES.md"
    }
    return $files
}

# ====================
# VALIDATE MODE
# ====================
if ($Validate) {
    if (-not (Test-Path $kbRoot)) {
        Write-Error "KB root does not exist: $kbRoot"
        exit 1
    }

    # Try to read modules from _sources/manifest.json if available
    $sourcesManifest = Join-Path $kbRoot "_sources/manifest.json"
    if (Test-Path $sourcesManifest) {
        $manifest = Get-Content $sourcesManifest -Raw | ConvertFrom-Json
        $modules = Get-ModulesFromManifest $manifest
    } elseif ($manifest) {
        $modules = Get-ModulesFromManifest $manifest
    } else {
        # Fall back to scanning modules/ folder
        $modulesDir = Join-Path $kbRoot "modules"
        if (Test-Path $modulesDir) {
            $modules = Get-ChildItem $modulesDir -Directory | ForEach-Object { $_.Name } | Sort-Object
        } else {
            $modules = @()
        }
    }

    $expected = Get-ExpectedFiles $modules
    $missing = @()
    $present = @()

    foreach ($file in $expected) {
        $fullPath = Join-Path $kbRoot $file
        if (Test-Path $fullPath) {
            $present += $file
        } else {
            $missing += $file
        }
    }

    Write-Host ""
    Write-Host "=== KB Validation: $AppName ==="
    Write-Host "Root: $kbRoot"
    Write-Host "Modules: $($modules -join ', ')"
    Write-Host "Expected files: $($expected.Count)"
    Write-Host "Present: $($present.Count)"
    Write-Host "Missing: $($missing.Count)"

    if ($missing.Count -gt 0) {
        Write-Host ""
        Write-Host "MISSING FILES:" -ForegroundColor Red
        foreach ($f in $missing) {
            Write-Host "  - $f" -ForegroundColor Red
        }
        exit 1
    } else {
        Write-Host ""
        Write-Host "All files present." -ForegroundColor Green
        exit 0
    }
}

# ====================
# SCAFFOLD MODE
# ====================
$modules = Get-ModulesFromManifest $manifest

Write-Host ""
Write-Host "=== KB Scaffold ==="
Write-Host "Source: $RunFolder"
Write-Host "Output: $kbRoot"
Write-Host "App: $AppName"
Write-Host "Modules: $($modules -join ', ')"
Write-Host ""

# Create folder tree
$folders = @(
    $kbRoot,
    (Join-Path $kbRoot "app"),
    (Join-Path $kbRoot "modules"),
    (Join-Path $kbRoot "routes"),
    (Join-Path $kbRoot "_sources")
)
foreach ($mod in $modules) {
    $folders += Join-Path $kbRoot "modules/$mod"
}

foreach ($folder in $folders) {
    if (-not (Test-Path $folder)) {
        New-Item -ItemType Directory -Path $folder -Force | Out-Null
        Write-Host "  Created: $folder"
    }
}

# Copy manifest to _sources/
$destManifest = Join-Path $kbRoot "_sources/manifest.json"
Copy-Item $manifestPath $destManifest -Force
Write-Host "  Copied: manifest.json -> _sources/manifest.json"

# Write source-reference file
$sourceRef = @"
# Source Reference

This knowledge base was generated from:
- Run folder: $RunFolder
- Generated at: $($manifest.generatedAtUtc)
- Schema version: $($manifest.schemaVersion)
- Selected modules: $($manifest.selectedModules -join ', ')
- Artifact count: $($manifest.artifactCount)
"@
$sourceRefPath = Join-Path $kbRoot "_sources/SOURCE_REF.md"
Set-Content -Path $sourceRefPath -Value $sourceRef -Encoding UTF8
Write-Host "  Written: _sources/SOURCE_REF.md"

Write-Host ""
Write-Host "Scaffold complete. $($folders.Count) folders ready."
Write-Host "Next: run KNOWLEDGEBASE_CREATOR agent to populate KB files."
