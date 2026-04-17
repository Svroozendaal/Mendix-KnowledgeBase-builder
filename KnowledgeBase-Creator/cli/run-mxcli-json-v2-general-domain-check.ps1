[CmdletBinding()]
param(
    [string]$ProjectPath = "C:\Workspaces\Mendix\Emixa_InspectionApp\Emixa_InspectionApp.mpr",
    [string]$AppOverviewRoot
)

$ErrorActionPreference = "Stop"

$cliRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$packageRoot = Split-Path -Parent $cliRoot
$repoRoot = Split-Path -Parent $packageRoot
. (Join-Path $cliRoot "lib/mxcli-json-v2-general-domain.ps1")

if ([string]::IsNullOrWhiteSpace($AppOverviewRoot)) {
    $AppOverviewRoot = Join-Path $repoRoot "mendix-data/app-overview"
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
$runId = "mxcli_prompt03_{0}" -f (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH-mm-ss.fffZ")

Write-Host "=== mxcli json v2 general/domain check ===" -ForegroundColor Cyan
Write-Host "Project: $ProjectPath"
Write-Host "Output root: $AppOverviewRoot"
Write-Host "Run id: $runId"
Write-Host ""

$generation = New-MxCliJsonV2GeneralDomainRun -ProjectPath $ProjectPath -AppOverviewRoot $AppOverviewRoot -RunId $runId
$runFolder = $generation.RunFolder
$manifest = Get-Content -Raw (Join-Path $runFolder "manifest.json") | ConvertFrom-Json
$appInfo = Get-Content -Raw (Join-Path $runFolder "general/app-info.json") | ConvertFrom-Json
$userRoles = Get-Content -Raw (Join-Path $runFolder "general/user-roles.json") | ConvertFrom-Json
$allModules = Get-Content -Raw (Join-Path $runFolder "general/all-modules.json") | ConvertFrom-Json
$marketplaceModules = Get-Content -Raw (Join-Path $runFolder "general/marketplace-modules.json") | ConvertFrom-Json

$requiredPaths = New-Object 'System.Collections.Generic.List[string]'
$requiredPaths.Add((Join-Path $runFolder "manifest.json")) | Out-Null
$requiredPaths.Add((Join-Path $runFolder "general/app-info.json")) | Out-Null
$requiredPaths.Add((Join-Path $runFolder "general/user-roles.json")) | Out-Null
$requiredPaths.Add((Join-Path $runFolder "general/all-modules.json")) | Out-Null
$requiredPaths.Add((Join-Path $runFolder "general/marketplace-modules.json")) | Out-Null

foreach ($moduleInfo in @($allModules.modules)) {
    $relativeDir = if ([string]$moduleInfo.category -eq "Marketplace") {
        "modules/marketplace/$([string]$moduleInfo.module)"
    } else {
        "modules/$([string]$moduleInfo.module)"
    }
    $requiredPaths.Add((Join-Path $runFolder (($relativeDir -replace "/", "\") + "\domain-model.json"))) | Out-Null
}

$missingPaths = @($requiredPaths | Where-Object { -not (Test-Path $_ -PathType Leaf) })
Add-Check -Checks $checks -Name "Expected file tree" -Passed ($missingPaths.Count -eq 0) -Detail $(if ($missingPaths.Count -eq 0) { "All required Prompt 03 files exist." } else { "Missing: $($missingPaths -join ', ')" })

$manifestKeys = @($manifest.PSObject.Properties.Name)
$appInfoKeys = @($appInfo.PSObject.Properties.Name)
$userRolesKeys = @($userRoles.PSObject.Properties.Name)
$allModulesKeys = @($allModules.PSObject.Properties.Name)
$marketplaceKeys = @($marketplaceModules.PSObject.Properties.Name)
$domainSamplePath = @($requiredPaths | Where-Object { $_ -like '*domain-model.json' } | Select-Object -First 1)[0]
$domainSample = Get-Content -Raw $domainSamplePath | ConvertFrom-Json
$domainKeys = @($domainSample.PSObject.Properties.Name)

$structuralPass = @(
    (@("schemaVersion", "generatedAtUtc", "selectedModules", "generator", "artifactCount", "artifacts") | Where-Object { $_ -notin $manifestKeys }).Count -eq 0,
    (@("schemaVersion", "generatedAtUtc", "sourceMprPath", "sourceDumpPath", "summary") | Where-Object { $_ -notin $appInfoKeys }).Count -eq 0,
    (@("projectSecurity") | Where-Object { $_ -notin $userRolesKeys }).Count -eq 0,
    (@("modules") | Where-Object { $_ -notin $allModulesKeys }).Count -eq 0,
    (@("modules") | Where-Object { $_ -notin $marketplaceKeys }).Count -eq 0,
    (@("module", "domainModel") | Where-Object { $_ -notin $domainKeys }).Count -eq 0
) -notcontains $false
Add-Check -Checks $checks -Name "Top-level JSON keys" -Passed $structuralPass -Detail "Manifest=$($manifestKeys -join ', '); AppInfo=$($appInfoKeys -join ', '); DomainModel=$($domainKeys -join ', ')"

$manifestGeneratorPass = ([string]$manifest.generator -eq "mxcli") -and ($appInfo.PSObject.Properties.Name -contains "sourceDumpPath") -and ($null -eq $appInfo.sourceDumpPath)
Add-Check -Checks $checks -Name "Manifest generator and sourceDumpPath" -Passed $manifestGeneratorPass -Detail "generator=$([string]$manifest.generator); sourceDumpPath=$($appInfo.sourceDumpPath)"

. (Join-Path $cliRoot "lib/mxcli-foundation.ps1")
$inspectionAssociationResult = Invoke-MxCliCommand -Arguments @("show", "associations", "Inspection", "-p", $ProjectPath) -ThrowOnError
$inspectionAssociationTable = ConvertFrom-MxCliMarkdownTableOutput -Result $inspectionAssociationResult
$taskDescribeResult = Invoke-MxCliCommand -Arguments @("describe", "entity", "Inspection.Task", "-p", $ProjectPath) -ThrowOnError
$taskDescribe = ConvertFrom-MxCliMdlOutput -Result $taskDescribeResult
$enumDescribeResult = Invoke-MxCliCommand -Arguments @("describe", "enumeration", "Inspection.Enum_TaskStatus", "-p", $ProjectPath) -ThrowOnError
$enumDescribe = ConvertFrom-MxCliMdlOutput -Result $enumDescribeResult

$inspectionDomainPath = Join-Path $runFolder "modules/Inspection/domain-model.json"
$inspectionDomain = Get-Content -Raw $inspectionDomainPath | ConvertFrom-Json
$taskEntity = @($inspectionDomain.domainModel.entities | Where-Object { $_.name -eq "Inspection.Task" })[0]
$taskStatusAttribute = @($taskEntity.attributes | Where-Object { $_.name -eq "Status" })[0]
$taskInspectorAssociation = @($inspectionDomain.domainModel.associations | Where-Object { $_.name -eq "Inspection.Task_Inspector" })[0]
$taskStatusEnumeration = @($inspectionDomain.domainModel.enumerations | Where-Object { $_.name -eq "Inspection.Enum_TaskStatus" })[0]

$spotCheckPass = $null -ne $taskEntity `
    -and $null -ne $taskStatusAttribute `
    -and $taskStatusAttribute.enumerationName -eq "Inspection.Enum_TaskStatus" `
    -and $taskStatusAttribute.type -eq "EnumerationAttributeType" `
    -and $null -ne $taskInspectorAssociation `
    -and $taskInspectorAssociation.type -eq "Reference" `
    -and $taskInspectorAssociation.owner -eq "Default" `
    -and $taskInspectorAssociation.cardinality -eq "*-1" `
    -and $null -ne $taskStatusEnumeration `
    -and (@($taskStatusEnumeration.values) | Where-Object { $_ -eq "To_do" }).Count -gt 0 `
    -and (@($inspectionAssociationTable.Rows | Where-Object { (Get-MxCliJsonRowValue -Row $_ -ColumnName "Qualified Name") -eq "Inspection.Task_Inspector" }).Count -eq 1) `
    -and ($taskDescribe.Text -match 'CREATE PERSISTENT ENTITY Inspection\.Task') `
    -and ($enumDescribe.Text -match 'CREATE ENUMERATION Inspection\.Enum_TaskStatus')
Add-Check -Checks $checks -Name "Inspection spot-check against live mxcli output" -Passed $spotCheckPass -Detail "Task attribute and association data match live mxcli sources."

$artifactPathsExist = @($manifest.artifacts | Where-Object { -not (Test-Path ([string]$_.path) -PathType Leaf) }).Count -eq 0
$artifactCountPass = ([int]$manifest.artifactCount -eq @($manifest.artifacts).Count) -and $artifactPathsExist
Add-Check -Checks $checks -Name "Manifest artifact list" -Passed $artifactCountPass -Detail "artifactCount=$([int]$manifest.artifactCount); listedArtifacts=$(@($manifest.artifacts).Count)"

$ledgerPath = Join-Path $repoRoot ".app-info/docs/MXCLI_PARITY_GAP_LEDGER.md"
$ledgerText = Get-Content -Raw $ledgerPath
$ledgerPass = $ledgerText.Contains("GAP-011") -and $ledgerText.Contains("GAP-012") -and $ledgerText.Contains("GAP-013") -and $ledgerText.Contains("GAP-014")
Add-Check -Checks $checks -Name "Parity gap ledger coverage" -Passed $ledgerPass -Detail "Expected Prompt 03 gap rows are present."

$unchangedComposerFiles = & git diff --name-only -- "KnowledgeBase-Creator/cli/run-kb-compose.ps1" "KnowledgeBase-Creator/cli/run-dump-parser.ps1" "tool-usage/knowledgebase-reader"
$legacyPass = [string]::IsNullOrWhiteSpace(($unchangedComposerFiles | Out-String))
Add-Check -Checks $checks -Name "Legacy default unchanged" -Passed $legacyPass -Detail $(if ($legacyPass) { "No composer, KB-reader, or legacy-entry changes detected." } else { "Changed paths: $($unchangedComposerFiles -join ', ')" })

Write-Host ""
foreach ($check in $checks) {
    $status = if ($check.Passed) { "PASS" } else { "FAIL" }
    $colour = if ($check.Passed) { "Green" } else { "Red" }
    Write-Host "$status | $($check.Name) | $($check.Detail)" -ForegroundColor $colour
}

$overallPass = (@($checks | Where-Object { -not $_.Passed }).Count -eq 0)
Write-Host ""
Write-Host ("Run folder: " + $runFolder)
Write-Host ("Overall: " + $(if ($overallPass) { "PASS" } else { "FAIL" })) -ForegroundColor $(if ($overallPass) { "Green" } else { "Red" })

if (-not $overallPass) {
    exit 1
}
