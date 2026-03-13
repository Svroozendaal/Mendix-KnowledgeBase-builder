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
    Knowledge base root folder. Default: mendix-data/knowledge-base

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
$runFolderDisplay = $RunFolder

# --- Resolve paths ---
if (-not $Validate -and -not $RunFolder) {
    Write-Error "RunFolder is required in scaffold mode. Use -RunFolder <path>"
    exit 1
}

if ($RunFolder) {
    $RunFolder = (Resolve-Path $RunFolder -ErrorAction Stop).Path
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
    if ($runFolderDisplay) {
        $AppName = Split-Path $runFolderDisplay -Leaf
    } else {
        Write-Error "AppName is required when RunFolder is not specified."
        exit 1
    }
}

$kbRoot = $OutputRoot

# --- Discover modules from manifest ---
function Get-ModulesFromManifest($manifest) {
    $modulesByName = @{}
    foreach ($artifact in $manifest.artifacts) {
        if ($artifact.type -ne "module-domain-model-json") { continue }

        $artifactPath = [string]$artifact.path
        if ([string]::IsNullOrWhiteSpace($artifactPath)) { continue }

        if ($artifactPath -match "[\\/]modules[\\/]marketplace[\\/]([^\\/]+)[\\/]domain-model\.json$") {
            $modulesByName[$matches[1]] = [pscustomobject]@{
                Name = $matches[1]
                Category = "Marketplace"
            }
            continue
        }

        if ($artifactPath -match "[\\/]modules[\\/]([^\\/]+)[\\/]domain-model\.json$") {
            $modulesByName[$matches[1]] = [pscustomobject]@{
                Name = $matches[1]
                Category = "Unknown"
            }
        }
    }

    return @($modulesByName.Values | Sort-Object Name)
}

function Get-ModuleRelativePath {
    param(
        [object]$Module,
        [string]$FileName = ""
    )

    $base = if ([string]$Module.Category -eq "Marketplace") {
        "modules/_marktplace/$($Module.Name)"
    } else {
        "modules/$($Module.Name)"
    }

    if ([string]::IsNullOrWhiteSpace($FileName)) {
        return $base
    }

    return "$base/$FileName"
}

function Get-ModulesFromKbRoot {
    param([string]$KbRootPath)

    $modules = New-Object System.Collections.Generic.List[object]
    $modulesDir = Join-Path $KbRootPath "modules"
    if (-not (Test-Path $modulesDir -PathType Container)) {
        return @()
    }

    foreach ($dir in @(Get-ChildItem $modulesDir -Directory | Where-Object { $_.Name -ne "_marktplace" } | Sort-Object Name)) {
        $modules.Add([pscustomobject]@{
            Name = $dir.Name
            Category = "Unknown"
        }) | Out-Null
    }

    $marketplaceDir = Join-Path $modulesDir "_marktplace"
    if (Test-Path $marketplaceDir -PathType Container) {
        foreach ($dir in @(Get-ChildItem $marketplaceDir -Directory | Sort-Object Name)) {
            $modules.Add([pscustomobject]@{
                Name = $dir.Name
                Category = "Marketplace"
            }) | Out-Null
        }
    }

    return @($modules | Sort-Object Name)
}

function Get-DisplayPath {
    param(
        [string]$BasePath,
        [string]$TargetPath
    )

    if ([string]::IsNullOrWhiteSpace($TargetPath)) { return "" }
    if ([string]::IsNullOrWhiteSpace($BasePath)) { return $TargetPath }

    try {
        $resolvedBase = (Resolve-Path $BasePath -ErrorAction Stop).Path
        $resolvedTarget = (Resolve-Path $TargetPath -ErrorAction Stop).Path
        $baseWithSeparator = $resolvedBase.TrimEnd('\', '/') + [System.IO.Path]::DirectorySeparatorChar
        $baseUri = [System.Uri]::new($baseWithSeparator)
        $targetUri = [System.Uri]::new($resolvedTarget)
        $relative = $baseUri.MakeRelativeUri($targetUri).ToString()
        if (-not [string]::IsNullOrWhiteSpace($relative) -and -not $relative.StartsWith("..")) {
            return ($relative -replace "\\", "/")
        }
    }
    catch {
        # Use the original path if relative resolution fails.
    }

    return $TargetPath
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
        "_sources/manifest.json",
        "_sources/SOURCE_REF.md"
    )
    foreach ($mod in $modules) {
        $files += Get-ModuleRelativePath -Module $mod -FileName "README.md"
        $files += Get-ModuleRelativePath -Module $mod -FileName "DOMAIN.md"
        $files += Get-ModuleRelativePath -Module $mod -FileName "FLOWS.md"
        $files += Get-ModuleRelativePath -Module $mod -FileName "PAGES.md"
        $files += Get-ModuleRelativePath -Module $mod -FileName "RESOURCES.md"
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
        $modules = Get-ModulesFromKbRoot -KbRootPath $kbRoot
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
    Write-Host "Modules: $((@($modules | ForEach-Object { $_.Name }) -join ', '))"
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
Write-Host "Source: $runFolderDisplay"
Write-Host "Output: $kbRoot"
Write-Host "App: $AppName"
Write-Host "Modules: $((@($modules | ForEach-Object { $_.Name }) -join ', '))"
Write-Host ""

$expectedModuleDirectories = @(
    $modules | ForEach-Object { Join-Path $kbRoot (Get-ModuleRelativePath -Module $_) }
) | ForEach-Object { [System.IO.Path]::GetFullPath($_) }
$modulesRoot = Join-Path $kbRoot "modules"
if (Test-Path $modulesRoot -PathType Container) {
    $existingModuleDirs = Get-ChildItem -Path $modulesRoot -Directory -Recurse | Where-Object { $_.FullName -ne (Join-Path $modulesRoot "_marktplace") }
    foreach ($dir in @($existingModuleDirs | Sort-Object FullName -Descending)) {
        if ($expectedModuleDirectories -notcontains $dir.FullName) {
            Remove-Item -Path $dir.FullName -Recurse -Force
            Write-Host "  Removed stale module folder: $($dir.FullName)"
        }
    }
}

# Create folder tree
$folders = @(
    $kbRoot,
    (Join-Path $kbRoot "app"),
    (Join-Path $kbRoot "modules"),
    (Join-Path $kbRoot "routes"),
    (Join-Path $kbRoot "_sources")
)
foreach ($mod in $modules) {
    $folders += Join-Path $kbRoot (Get-ModuleRelativePath -Module $mod)
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
$dataRoot = Split-Path -Parent $kbRoot
$runFolderForDisplay = Get-DisplayPath -BasePath $dataRoot -TargetPath $RunFolder
$sourceRef = @"
# Source Reference

This knowledge base was generated from:
- Run folder: $runFolderForDisplay
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
