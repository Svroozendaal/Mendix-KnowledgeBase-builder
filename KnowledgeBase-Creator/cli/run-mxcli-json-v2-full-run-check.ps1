[CmdletBinding()]
param(
    [string]$ProjectPath = "C:\Workspaces\Mendix\Emixa_InspectionApp\Emixa_InspectionApp.mpr",
    [string]$AppOverviewRoot,
    [string]$KbOutputRoot,
    [string]$AppName
)

$ErrorActionPreference = "Stop"

$wizardRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$packageRoot = Split-Path -Parent $wizardRoot
$repoRoot = Split-Path -Parent $packageRoot

. (Join-Path $wizardRoot "lib/mxcli-json-v2-full-run.ps1")

if ([string]::IsNullOrWhiteSpace($AppOverviewRoot)) {
    $AppOverviewRoot = Join-Path $repoRoot "mendix-data/app-overview"
}

if ([string]::IsNullOrWhiteSpace($AppName)) {
    $AppName = [System.IO.Path]::GetFileNameWithoutExtension($ProjectPath)
}

if ([string]::IsNullOrWhiteSpace($KbOutputRoot)) {
    $KbOutputRoot = Join-Path $repoRoot ("mendix-data/knowledge-base-mxcli-prompt04-{0}" -f (Get-Date).ToUniversalTime().ToString("yyyyMMddHHmmss"))
}

function Add-Check {
    param(
        [System.Collections.Generic.List[object]]$Checks,
        [string]$Name,
        [bool]$Passed,
        [string]$Detail
    )

    $Checks.Add([pscustomobject]@{
        Name = $Name
        Passed = $Passed
        Detail = $Detail
    }) | Out-Null
}

$checks = New-Object 'System.Collections.Generic.List[object]'
$runId = "mxcli_prompt04_{0}" -f (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH-mm-ss.fffZ")

Write-Host "=== mxcli json v2 full-run check ===" -ForegroundColor Cyan
Write-Host "Project: $ProjectPath"
Write-Host "App-overview root: $AppOverviewRoot"
Write-Host "KB output root: $KbOutputRoot"
Write-Host "AppName: $AppName"
Write-Host "Run id: $runId"
Write-Host ""

$generation = New-MxCliJsonV2FullRun -ProjectPath $ProjectPath -AppOverviewRoot $AppOverviewRoot -RunId $runId
$runFolder = $generation.RunFolder
$manifestPath = Join-Path $runFolder "manifest.json"
$manifest = Get-Content -Raw $manifestPath | ConvertFrom-Json

Add-Check -Checks $checks -Name "Run folder generated" -Passed (Test-Path $runFolder -PathType Container) -Detail $runFolder

$generalRequired = @(
    "general/app-info.json",
    "general/app-info.pseudo.txt",
    "general/user-roles.json",
    "general/user-roles.pseudo.txt",
    "general/all-modules.json",
    "general/all-modules.pseudo.txt",
    "general/marketplace-modules.json",
    "general/marketplace-modules.pseudo.txt"
) | ForEach-Object { Join-Path $runFolder $_ }

$generalMissing = @($generalRequired | Where-Object { -not (Test-Path $_ -PathType Leaf) })
Add-Check -Checks $checks -Name "General JSON + pseudo contract" -Passed ($generalMissing.Count -eq 0) -Detail $(if ($generalMissing.Count -eq 0) { "All required general files exist." } else { "Missing: $($generalMissing -join ', ')" })

$moduleCatalog = @(Get-OverviewModuleCatalog -RunFolder $runFolder -Manifest $manifest)
$moduleCatalogByName = Get-OverviewModuleCatalogMap -ModuleCatalog $moduleCatalog
$moduleMissing = New-Object 'System.Collections.Generic.List[string]'
$flowDetailMissing = New-Object 'System.Collections.Generic.List[string]'
$pageDetailMissing = New-Object 'System.Collections.Generic.List[string]'

foreach ($moduleEntry in @($moduleCatalog)) {
    $moduleName = [string]$moduleEntry.Name
    foreach ($fileName in @(
            "domain-model.json",
            "domain-model.pseudo.txt",
            "flows.json",
            "flows.pseudo.txt",
            "flows/INDEX.json",
            "pages.json",
            "pages.pseudo.txt",
            "pages/INDEX.json",
            "resources.json",
            "resources.pseudo.txt"
        )) {
        $path = Get-OverviewModuleFilePath -RootPath $runFolder -ModuleName $moduleName -FileName $fileName -ModuleCatalogByName $moduleCatalogByName
        if (-not (Test-Path $path -PathType Leaf)) {
            $moduleMissing.Add($path) | Out-Null
        }
    }

    $flowsIndexPath = Get-OverviewModuleFilePath -RootPath $runFolder -ModuleName $moduleName -FileName "flows/INDEX.json" -ModuleCatalogByName $moduleCatalogByName
    if (Test-Path $flowsIndexPath -PathType Leaf) {
        $flowsIndex = Get-Content -Raw $flowsIndexPath | ConvertFrom-Json
        foreach ($item in @($flowsIndex.items)) {
            $detailPath = Get-OverviewModuleFilePath -RootPath $runFolder -ModuleName $moduleName -FileName ("flows/{0}.json" -f [string]$item.slug) -ModuleCatalogByName $moduleCatalogByName
            if (-not (Test-Path $detailPath -PathType Leaf)) {
                $flowDetailMissing.Add($detailPath) | Out-Null
            }
        }
    }

    $pagesIndexPath = Get-OverviewModuleFilePath -RootPath $runFolder -ModuleName $moduleName -FileName "pages/INDEX.json" -ModuleCatalogByName $moduleCatalogByName
    if (Test-Path $pagesIndexPath -PathType Leaf) {
        $pagesIndex = Get-Content -Raw $pagesIndexPath | ConvertFrom-Json
        foreach ($item in @($pagesIndex.items)) {
            $detailPath = Get-OverviewModuleFilePath -RootPath $runFolder -ModuleName $moduleName -FileName ("pages/{0}.json" -f [string]$item.slug) -ModuleCatalogByName $moduleCatalogByName
            if (-not (Test-Path $detailPath -PathType Leaf)) {
                $pageDetailMissing.Add($detailPath) | Out-Null
            }
        }
    }
}

Add-Check -Checks $checks -Name "Module aggregate contract files" -Passed ($moduleMissing.Count -eq 0) -Detail $(if ($moduleMissing.Count -eq 0) { "All required module aggregate files exist." } else { "Missing: $($moduleMissing -join ', ')" })
Add-Check -Checks $checks -Name "Flow detail files from INDEX" -Passed ($flowDetailMissing.Count -eq 0) -Detail $(if ($flowDetailMissing.Count -eq 0) { "All flow detail files exist." } else { "Missing: $($flowDetailMissing -join ', ')" })
Add-Check -Checks $checks -Name "Page detail files from INDEX" -Passed ($pageDetailMissing.Count -eq 0) -Detail $(if ($pageDetailMissing.Count -eq 0) { "All page detail files exist." } else { "Missing: $($pageDetailMissing -join ', ')" })

$pseudoFiles = @(Get-ChildItem -Path $runFolder -Recurse -Filter "*.pseudo.txt" -File)
$pseudoWithBom = New-Object 'System.Collections.Generic.List[string]'
foreach ($file in @($pseudoFiles)) {
    $bytes = [System.IO.File]::ReadAllBytes($file.FullName)
    if ($bytes.Length -ge 3 -and $bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF) {
        $pseudoWithBom.Add($file.FullName) | Out-Null
    }
}
Add-Check -Checks $checks -Name "Pseudo encoding (UTF-8 no BOM)" -Passed ($pseudoWithBom.Count -eq 0) -Detail $(if ($pseudoWithBom.Count -eq 0) { "All pseudo files are UTF-8 without BOM." } else { "BOM found in: $($pseudoWithBom -join ', ')" })

$blankPseudocodeFlows = New-Object 'System.Collections.Generic.List[string]'
$truncatedPageNames = New-Object 'System.Collections.Generic.List[string]'
foreach ($moduleEntry in @($moduleCatalog)) {
    $moduleName = [string]$moduleEntry.Name

    $flowsPath = Get-OverviewModuleFilePath -RootPath $runFolder -ModuleName $moduleName -FileName "flows.json" -ModuleCatalogByName $moduleCatalogByName
    $flowsObject = Get-Content -Raw $flowsPath | ConvertFrom-Json
    foreach ($flow in @($flowsObject.flows)) {
        if ([string]::IsNullOrWhiteSpace([string]$flow.pseudocode)) {
            $blankPseudocodeFlows.Add([string]$flow.qualifiedName) | Out-Null
        }
    }

    $pagesPath = Get-OverviewModuleFilePath -RootPath $runFolder -ModuleName $moduleName -FileName "pages.json" -ModuleCatalogByName $moduleCatalogByName
    $pagesObject = Get-Content -Raw $pagesPath | ConvertFrom-Json
    foreach ($page in @($pagesObject.pages)) {
        $qualifiedName = [string]$page.qualifiedName
        if ($qualifiedName.IndexOf("...") -ge 0 -or $qualifiedName.IndexOf([char]0x2026) -ge 0) {
            $truncatedPageNames.Add($qualifiedName) | Out-Null
        }
    }
}
Add-Check -Checks $checks -Name "Flow pseudocode population" -Passed ($blankPseudocodeFlows.Count -eq 0) -Detail $(if ($blankPseudocodeFlows.Count -eq 0) { "All flows contain pseudocode." } else { "Blank pseudocode: $($blankPseudocodeFlows -join ', ')" })
Add-Check -Checks $checks -Name "Page qualified-name normalisation" -Passed ($truncatedPageNames.Count -eq 0) -Detail $(if ($truncatedPageNames.Count -eq 0) { "No truncated page qualified names in output." } else { "Truncated names: $($truncatedPageNames -join ', ')" })

$evidencePass = $true
$evidenceFailures = New-Object 'System.Collections.Generic.List[string]'
foreach ($command in @(
        @("describe", "microflow", "Inspection.ACT_Task_Save", "-p", $ProjectPath),
        @("describe", "page", "Inspection.Dashboard_Home", "-p", $ProjectPath),
        @("refs", "Inspection.Dashboard_Home", "-p", $ProjectPath),
        @("callers", "Inspection.ACT_Task_Save", "-p", $ProjectPath, "--transitive"),
        @("show", "constants", "Inspection", "-p", $ProjectPath)
    )) {
    try {
        Invoke-MxCliCommand -Arguments $command -ThrowOnError | Out-Null
    }
    catch {
        $evidencePass = $false
        $evidenceFailures.Add(("mxcli " + ($command -join " "))) | Out-Null
    }
}
Add-Check -Checks $checks -Name "Prompt 04 evidence commands" -Passed $evidencePass -Detail $(if ($evidencePass) { "All evidence commands executed successfully." } else { "Failed: $($evidenceFailures -join '; ')" })

$scaffoldScript = Join-Path $wizardRoot "run-kb-scaffold.ps1"
$composeScript = Join-Path $wizardRoot "run-kb-compose.ps1"
$qualityScript = Join-Path $wizardRoot "run-kb-quality-gate.ps1"
$benchmarkScript = Join-Path $wizardRoot "run-kb-semantic-benchmark.ps1"

$scaffoldPass = $false
$composePass = $false
$validatePass = $false
$qualityPass = $false
$benchmarkPass = $false

try {
    & $scaffoldScript -RunFolder $runFolder -OutputRoot $KbOutputRoot -AppName $AppName
    $scaffoldPass = $true
}
catch {
    $scaffoldPass = $false
}
Add-Check -Checks $checks -Name "KB scaffold (create)" -Passed $scaffoldPass -Detail $KbOutputRoot

if ($scaffoldPass) {
    try {
        & $composeScript -RunFolder $runFolder -OutputRoot $KbOutputRoot -AppName $AppName
        $composePass = $true
    }
    catch {
        $composePass = $false
    }
}
Add-Check -Checks $checks -Name "KB composer run" -Passed $composePass -Detail $KbOutputRoot

if ($composePass) {
    try {
        & $scaffoldScript -Validate -OutputRoot $KbOutputRoot -AppName $AppName
        $validatePass = $true
    }
    catch {
        $validatePass = $false
    }
}
Add-Check -Checks $checks -Name "KB scaffold validate" -Passed $validatePass -Detail $KbOutputRoot

if ($validatePass) {
    try {
        & $qualityScript -OutputRoot $KbOutputRoot -AppName $AppName
        $qualityPass = $true
    }
    catch {
        $qualityPass = $false
    }
}
Add-Check -Checks $checks -Name "KB quality gate" -Passed $qualityPass -Detail $KbOutputRoot

if ($qualityPass) {
    try {
        & $benchmarkScript -OutputRoot $KbOutputRoot -AppName $AppName
        $benchmarkPass = $true
    }
    catch {
        $benchmarkPass = $false
    }
}
Add-Check -Checks $checks -Name "KB semantic benchmark" -Passed $benchmarkPass -Detail $KbOutputRoot

$referenceKbRoot = Join-Path $repoRoot "mendix-data/knowledge-base"
$referenceCoreFiles = @(
    "READER.md",
    "ROUTING.md",
    "QUICKSTART.md",
    "app/APP_OVERVIEW.md",
    "app/MODULE_LANDSCAPE.md",
    "app/SECURITY.md",
    "routes/by-entity.md",
    "routes/by-page.md",
    "routes/by-flow.md",
    "routes/cross-module.md",
    "routes/keyword-index.md"
)

$referenceExists = Test-Path $referenceKbRoot -PathType Container
$referenceMissingCore = @()
if ($referenceExists) {
    $referenceMissingCore = @($referenceCoreFiles | Where-Object { -not (Test-Path (Join-Path $referenceKbRoot $_) -PathType Leaf) })
}
$outputMissingCore = @($referenceCoreFiles | Where-Object { -not (Test-Path (Join-Path $KbOutputRoot $_) -PathType Leaf) })
$structureParityPass = $referenceExists -and ($referenceMissingCore.Count -eq 0) -and ($outputMissingCore.Count -eq 0)

Add-Check -Checks $checks -Name "KB structure contract reference check" -Passed $structureParityPass -Detail $(if ($structureParityPass) { "Core contract files exist in reference and generated KB." } else { "referenceExists=$referenceExists; referenceMissing=$($referenceMissingCore.Count); outputMissing=$($outputMissingCore.Count)" })

$ledgerPath = Join-Path $repoRoot ".app-info/docs/MXCLI_PARITY_GAP_LEDGER.md"
$ledgerText = Get-Content -Raw $ledgerPath
$ledgerPass = $ledgerText.Contains("GAP-016") -and $ledgerText.Contains("GAP-017")
Add-Check -Checks $checks -Name "Prompt 04 parity ledger updates" -Passed $ledgerPass -Detail "Ledger includes Prompt 04 gap entries."

Write-Host ""
foreach ($check in $checks) {
    $status = if ($check.Passed) { "PASS" } else { "FAIL" }
    $colour = if ($check.Passed) { "Green" } else { "Red" }
    Write-Host "$status | $($check.Name) | $($check.Detail)" -ForegroundColor $colour
}

$overallPass = (@($checks | Where-Object { -not $_.Passed }).Count -eq 0)
Write-Host ""
Write-Host "Run folder: $runFolder"
Write-Host "KB output root: $KbOutputRoot"
Write-Host ("Overall: " + $(if ($overallPass) { "PASS" } else { "FAIL" })) -ForegroundColor $(if ($overallPass) { "Green" } else { "Red" })

if (-not $overallPass) {
    exit 1
}
