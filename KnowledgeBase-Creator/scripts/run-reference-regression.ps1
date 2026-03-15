[CmdletBinding()]
param(
    [string]$ReferenceRunFolder = "tests/reference/app-overview/cli_reference_minimal",
    [string]$BaselineKbFolder = "tests/reference/baseline-kb/ReferenceApp",
    [string]$TempOutputRoot = ".app-info/reference-regression-output",
    [string]$AppName = "ReferenceApp",
    [string]$GeneratedAtUtc = "2026-03-05T00:00:00Z"
)

$ErrorActionPreference = "Stop"

$scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$repoRoot = (Resolve-Path (Join-Path $scriptRoot "..\\..")).Path

$referenceRunFolderPath = Join-Path $repoRoot $ReferenceRunFolder
$baselineKbFolderPath = Join-Path $repoRoot $BaselineKbFolder
$tempOutputRootPath = Join-Path $repoRoot $TempOutputRoot
$runToken = (Get-Date).ToUniversalTime().ToString("yyyyMMddHHmmss")
$generatedRunRoot = Join-Path $tempOutputRootPath "run_$runToken"
$generatedKbFolder = Join-Path $generatedRunRoot $AppName

$scaffoldScript = Join-Path $repoRoot "KnowledgeBase-Creator/wizard/run-kb-scaffold.ps1"
$composeScript = Join-Path $repoRoot "KnowledgeBase-Creator/wizard/run-kb-compose.ps1"
$qualityScript = Join-Path $repoRoot "KnowledgeBase-Creator/wizard/run-kb-quality-gate.ps1"
$benchmarkScript = Join-Path $repoRoot "KnowledgeBase-Creator/wizard/run-kb-semantic-benchmark.ps1"

if (-not (Test-Path $referenceRunFolderPath -PathType Container)) {
    throw "Reference run folder not found: $referenceRunFolderPath"
}
if (-not (Test-Path $baselineKbFolderPath -PathType Container)) {
    throw "Baseline KB folder not found: $baselineKbFolderPath"
}

New-Item -ItemType Directory -Path $generatedKbFolder -Force | Out-Null

Write-Host ""
Write-Host "=== Reference Regression ===" -ForegroundColor Cyan
Write-Host "Reference run: $ReferenceRunFolder"
Write-Host "Baseline KB:   $BaselineKbFolder"
Write-Host "Generated KB:  $generatedKbFolder"

& powershell -NoProfile -ExecutionPolicy Bypass -File $scaffoldScript -RunFolder $ReferenceRunFolder -OutputRoot $generatedKbFolder -AppName $AppName
if ($LASTEXITCODE -ne 0) { throw "Scaffold failed with exit code $LASTEXITCODE" }

& powershell -NoProfile -ExecutionPolicy Bypass -File $composeScript -RunFolder $ReferenceRunFolder -OutputRoot $generatedKbFolder -AppName $AppName -GeneratedAtUtc $GeneratedAtUtc
if ($LASTEXITCODE -ne 0) { throw "Compose failed with exit code $LASTEXITCODE" }

& powershell -NoProfile -ExecutionPolicy Bypass -File $qualityScript -OutputRoot $generatedKbFolder -AppName $AppName -GeneratedAtUtc $GeneratedAtUtc -KbRootDisplay "reference/$AppName"
if ($LASTEXITCODE -ne 0) { throw "Quality gate failed with exit code $LASTEXITCODE" }

& powershell -NoProfile -ExecutionPolicy Bypass -File $benchmarkScript -OutputRoot $generatedKbFolder -AppName $AppName -GeneratedAtUtc $GeneratedAtUtc -KbRootDisplay "reference/$AppName"
if ($LASTEXITCODE -ne 0) { throw "Semantic benchmark failed with exit code $LASTEXITCODE" }

Write-Host "Running regression diff against baseline..." -ForegroundColor Yellow
& git diff --no-index --exit-code -- $baselineKbFolderPath $generatedKbFolder
if ($LASTEXITCODE -ne 0) {
    throw "Regression diff failed: generated KB differs from baseline."
}

Write-Host "Reference regression passed." -ForegroundColor Green
