[CmdletBinding()]
param(
    [string]$AppPath,
    [ValidateSet('Debug', 'Release')]
    [string]$Configuration = 'Debug',
    [string]$DataRootPath,
    [switch]$SkipBuild
)

$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$projectPath = Join-Path $repoRoot 'studio-pro-extension-csharp\AutoCommitMessage.csproj'
$buildArtifactsRoot = Join-Path $repoRoot 'build-artifacts\AutoCommitMessage'
$buildBaseOutputPath = Join-Path $buildArtifactsRoot 'bin\'
$buildBaseIntermediatePath = Join-Path $buildArtifactsRoot 'obj\'
$buildOutput = Join-Path $buildBaseOutputPath "$Configuration\net8.0-windows"

function Read-DotEnv {
    param([string]$Path)

    $result = @{}
    if (-not (Test-Path $Path -PathType Leaf)) {
        return $result
    }

    foreach ($rawLine in Get-Content -Path $Path) {
        $line = $rawLine.Trim()
        if ([string]::IsNullOrWhiteSpace($line) -or $line.StartsWith('#')) {
            continue
        }

        $separatorIndex = $line.IndexOf('=')
        if ($separatorIndex -lt 1) {
            continue
        }

        $key = $line.Substring(0, $separatorIndex).Trim()
        if ([string]::IsNullOrWhiteSpace($key)) {
            continue
        }

        $value = $line.Substring($separatorIndex + 1).Trim()
        if (
            $value.Length -ge 2 -and (
                ($value.StartsWith('"') -and $value.EndsWith('"')) -or
                ($value.StartsWith("'") -and $value.EndsWith("'"))
            )
        ) {
            $value = $value.Substring(1, $value.Length - 2)
        }

        $result[$key] = $value
    }

    return $result
}

$dotEnvPath = Join-Path $repoRoot '.env'
$dotEnv = Read-DotEnv -Path $dotEnvPath

if (-not $PSBoundParameters.ContainsKey('AppPath') -and $dotEnv.ContainsKey('MENDIX_APP_PATH')) {
    $AppPath = $dotEnv['MENDIX_APP_PATH']
}

if ([string]::IsNullOrWhiteSpace($AppPath)) {
    $AppPath = 'C:\MendixWorkers\Smart Expenses app-main'
}

if (-not $PSBoundParameters.ContainsKey('DataRootPath') -and $dotEnv.ContainsKey('MENDIX_DATA_ROOT')) {
    $DataRootPath = $dotEnv['MENDIX_DATA_ROOT']
}

if ([string]::IsNullOrWhiteSpace($DataRootPath)) {
    $DataRootPath = Join-Path $AppPath 'mendix-data'
}

$AppPath = [System.IO.Path]::GetFullPath($AppPath)
$DataRootPath = [System.IO.Path]::GetFullPath($DataRootPath)

# Folders must match runtime paths in ExtensionDataPaths.cs and services.
# Last verified: 2026-02-28
$rawChangesPath = Join-Path $DataRootPath 'raw-changes'
$processedPath = Join-Path $DataRootPath 'processed'
$errorsPath = Join-Path $DataRootPath 'errors'
$appOverviewPath = Join-Path $DataRootPath 'app-overview'
$dumpsPath = Join-Path $DataRootPath 'dumps'
$commitMessagesPath = Join-Path $DataRootPath 'Commit messages'

$extensionName = 'AutoCommitMessage'
$dllName = "$extensionName.dll"
$pdbName = "$extensionName.pdb"
$manifestName = 'manifest.json'

$targetDir = Join-Path $AppPath "extensions\$extensionName"
$targetDll = Join-Path $targetDir $dllName
$targetPdb = Join-Path $targetDir $pdbName
$targetManifest = Join-Path $targetDir $manifestName

if (-not (Test-Path $AppPath -PathType Container)) {
    throw "Mendix app path not found: $AppPath"
}

if (-not (Test-Path $projectPath -PathType Leaf)) {
    throw "Extension project not found: $projectPath"
}

New-Item -ItemType Directory -Force -Path $rawChangesPath | Out-Null
New-Item -ItemType Directory -Force -Path $processedPath | Out-Null
New-Item -ItemType Directory -Force -Path $errorsPath | Out-Null
New-Item -ItemType Directory -Force -Path $appOverviewPath | Out-Null
New-Item -ItemType Directory -Force -Path $dumpsPath | Out-Null
New-Item -ItemType Directory -Force -Path $commitMessagesPath | Out-Null
New-Item -ItemType Directory -Force -Path $buildBaseOutputPath | Out-Null
New-Item -ItemType Directory -Force -Path $buildBaseIntermediatePath | Out-Null

if (-not $SkipBuild) {
    Write-Host "Building extension ($Configuration)..." -ForegroundColor Cyan
    Write-Host "Configured Mendix data root: $DataRootPath" -ForegroundColor Cyan
    Write-Host "Build artifacts root: $buildArtifactsRoot" -ForegroundColor Cyan

    $buildArgs = @(
        'build'
        $projectPath
        '-c'
        $Configuration
        "/p:MendixDataRoot=$DataRootPath"
        "/p:BaseOutputPath=$buildBaseOutputPath"
        "/p:BaseIntermediateOutputPath=$buildBaseIntermediatePath"
    )

    dotnet @buildArgs
    if ($LASTEXITCODE -ne 0) {
        throw "dotnet build failed with exit code $LASTEXITCODE"
    }
} else {
    Write-Host "Skipping build. Existing build artifacts keep their previously compiled Mendix data root." -ForegroundColor Yellow
}

$sourceDll = Join-Path $buildOutput $dllName
$sourcePdb = Join-Path $buildOutput $pdbName
$sourceManifest = Join-Path $buildOutput $manifestName

if (-not (Test-Path $sourceDll -PathType Leaf)) {
    throw "Built DLL not found: $sourceDll"
}

if (-not (Test-Path $sourceManifest -PathType Leaf)) {
    throw "Built manifest not found: $sourceManifest"
}

New-Item -ItemType Directory -Force -Path $targetDir | Out-Null

Copy-Item -Path $sourceDll -Destination $targetDll -Force
Copy-Item -Path $sourceManifest -Destination $targetManifest -Force

if (Test-Path $sourcePdb -PathType Leaf) {
    Copy-Item -Path $sourcePdb -Destination $targetPdb -Force
}

$legacyDll = Join-Path $targetDir 'WellBased_Copilot_StudioPro10.dll'
if (Test-Path $legacyDll -PathType Leaf) {
    Remove-Item -Path $legacyDll -Force
}

Write-Host ''
Write-Host 'Deployment complete.' -ForegroundColor Green
Write-Host "App path:           $AppPath"
Write-Host "Target folder:      $targetDir"
Write-Host "Data root:          $DataRootPath"
Write-Host "Raw changes:        $rawChangesPath"
Write-Host "Processed:          $processedPath"
Write-Host "Errors:             $errorsPath"
Write-Host "App overview:       $appOverviewPath"
Write-Host "Dumps:              $dumpsPath"
Write-Host "Commit messages:    $commitMessagesPath"
Write-Host "DLL:                $targetDll"
Write-Host "Manifest:           $targetManifest"
Write-Host "Build output:       $buildOutput"
if (Test-Path $targetPdb -PathType Leaf) {
    Write-Host "PDB:                $targetPdb"
}
Write-Host "Data root hint: `$env:MENDIX_GIT_DATA_ROOT = '$DataRootPath'"
