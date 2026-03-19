param(
    [string]$ProjectPath = "C:\Workspaces\Mendix\Emixa_InspectionApp\Emixa_InspectionApp.mpr",
    [string]$AppOverviewRoot,
    [string]$RunId,
    [string[]]$SelectedModules,
    [switch]$SyncCurrent,
    [string]$CurrentAliasPath
)

$ErrorActionPreference = "Stop"

$wizardRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$packageRoot = Split-Path -Parent $wizardRoot
$repoRoot = Split-Path -Parent $packageRoot
. (Join-Path $wizardRoot "lib/mxcli-json-v2-full-run.ps1")

if ([string]::IsNullOrWhiteSpace($AppOverviewRoot)) {
    $AppOverviewRoot = Join-Path $repoRoot "mendix-data/app-overview"
}

$result = New-MxCliJsonV2FullRun `
    -ProjectPath $ProjectPath `
    -AppOverviewRoot $AppOverviewRoot `
    -RunId $RunId `
    -SelectedModules $SelectedModules `
    -SyncCurrent:$SyncCurrent `
    -CurrentAliasPath $CurrentAliasPath

Write-Host "Run folder: $($result.RunFolder)"
Write-Host "Manifest: $($result.ManifestPath)"
