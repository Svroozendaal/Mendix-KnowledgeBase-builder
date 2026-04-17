[CmdletBinding()]
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
. (Join-Path $wizardRoot "lib/mxcli-json-v2-general-domain.ps1")

if ([string]::IsNullOrWhiteSpace($AppOverviewRoot)) {
    $AppOverviewRoot = Join-Path $repoRoot "mendix-data/app-overview"
}

Write-Host "=== mxcli json v2 general/domain generation ===" -ForegroundColor Cyan
Write-Host "Project: $ProjectPath"
Write-Host "Output root: $AppOverviewRoot"
if (-not [string]::IsNullOrWhiteSpace($RunId)) {
    Write-Host "Run id: $RunId"
}
if ($null -ne $SelectedModules -and @($SelectedModules).Count -gt 0) {
    Write-Host "Selected modules: $(@($SelectedModules) -join ', ')"
}
Write-Host ""

$result = New-MxCliJsonV2GeneralDomainRun `
    -ProjectPath $ProjectPath `
    -AppOverviewRoot $AppOverviewRoot `
    -RunId $RunId `
    -SelectedModules $SelectedModules `
    -SyncCurrent:$SyncCurrent `
    -CurrentAliasPath $CurrentAliasPath

Write-Host "Run folder: $($result.RunFolder)" -ForegroundColor Green
Write-Host "Manifest: $($result.ManifestPath)"
Write-Host "Modules: $(@($result.Modules | ForEach-Object { $_.Name }) -join ', ')"
