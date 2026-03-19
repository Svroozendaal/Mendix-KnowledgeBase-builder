[CmdletBinding()]
param(
    [string]$ProjectPath = "C:\Workspaces\Mendix\Emixa_InspectionApp\Emixa_InspectionApp.mpr",
    [string]$WorkingDirectory
)

$ErrorActionPreference = "Stop"

$wizardRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$packageRoot = Split-Path -Parent $wizardRoot
. (Join-Path $wizardRoot "lib/mxcli-foundation.ps1")

if ([string]::IsNullOrWhiteSpace($WorkingDirectory)) {
    $WorkingDirectory = $packageRoot
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

function Get-ResultCount {
    param([object]$Value)

    if ($null -eq $Value) { return 0 }
    if ($Value -is [string]) { return 1 }
    if ($Value -is [System.Collections.IEnumerable]) {
        return @($Value | ForEach-Object { $_ }).Count
    }

    return 1
}

if (-not (Test-Path $ProjectPath -PathType Leaf)) {
    throw "ProjectPath does not exist: $ProjectPath"
}

$checks = New-Object 'System.Collections.Generic.List[object]'

Write-Host "=== mxcli foundation check ===" -ForegroundColor Cyan
Write-Host "Project: $ProjectPath"
Write-Host "Working directory: $WorkingDirectory"
Write-Host ""

$mxcliPath = Resolve-MxCliExecutable
Add-Check -Checks $checks -Name "Resolve mxcli from PATH" -Passed $true -Detail "Resolved to $mxcliPath"
Write-Host "mxcli: $mxcliPath"

$originalPath = [Environment]::GetEnvironmentVariable("PATH")
try {
    [Environment]::SetEnvironmentVariable("PATH", "")
    try {
        Resolve-MxCliExecutable | Out-Null
        Add-Check -Checks $checks -Name "Missing PATH diagnostic" -Passed $false -Detail "Resolve-MxCliExecutable unexpectedly succeeded with an empty PATH."
    }
    catch {
        $message = $_.Exception.Message
        $passed = $message -match 'mxcli was not found on PATH'
        Add-Check -Checks $checks -Name "Missing PATH diagnostic" -Passed $passed -Detail $message
    }
}
finally {
    [Environment]::SetEnvironmentVariable("PATH", $originalPath)
}

$versionResult = Invoke-MxCliCommand -Arguments @("--version") -WorkingDirectory $WorkingDirectory
$versionText = Get-MxCliTextOutput -Result $versionResult
Add-Check -Checks $checks -Name "Version command" -Passed ($versionResult.ExitCode -eq 0 -and $versionText -match '^mxcli version ') -Detail $versionText

$describeResult = Invoke-MxCliCommand -Arguments @("describe", "microflow", "Inspection.ACT_Task_Save", "-p", $ProjectPath) -WorkingDirectory $WorkingDirectory
$mdl = ConvertFrom-MxCliMdlOutput -Result $describeResult
$mdlPassed = $mdl.Text -match '^CREATE MICROFLOW Inspection\.ACT_Task_Save' -and $mdl.LineCount -gt 0
Add-Check -Checks $checks -Name "MDL parsing" -Passed $mdlPassed -Detail "LineCount=$($mdl.LineCount)"

$searchResult = Invoke-MxCliCommand -Arguments @("search", "-p", $ProjectPath, "Task", "--format", "json") -WorkingDirectory $WorkingDirectory -UseQuietMode
$searchJson = ConvertFrom-MxCliJsonOutput -Result $searchResult
$searchCount = Get-ResultCount -Value $searchJson.Data
$searchPassed = $searchCount -gt 0
Add-Check -Checks $checks -Name "JSON parsing" -Passed $searchPassed -Detail "Search result count=$searchCount"

$refsResult = Invoke-MxCliCatalogQuery -ProjectPath $ProjectPath -Query "SELECT SourceName, TargetName, RefKind FROM CATALOG.refs LIMIT 10" -CatalogStage Full -WorkingDirectory $WorkingDirectory
$refsTable = ConvertFrom-MxCliMarkdownTableOutput -Result $refsResult
$refsPassed = $refsTable.RowCount -gt 0 -and @($refsTable.Headers) -contains "SourceName" -and @($refsTable.Headers) -contains "TargetName" -and @($refsTable.Headers) -contains "RefKind"
Add-Check -Checks $checks -Name "Table parsing" -Passed $refsPassed -Detail "RowCount=$($refsTable.RowCount); Headers=$(@($refsTable.Headers) -join ', ')"

$lintResult = Invoke-MxCliCommand -Arguments @("lint", "-p", $ProjectPath, "--format", "json") -WorkingDirectory $WorkingDirectory
$lintJson = ConvertFrom-MxCliJsonOutput -Result $lintResult
$lintSummary = $lintJson.Data.summary
$lintPassed = $null -ne $lintSummary -and $null -ne $lintSummary.total
Add-Check -Checks $checks -Name "JSON preamble stripping" -Passed $lintPassed -Detail "Lint summary total=$($lintSummary.total)"

$warningSeparated = (@($searchResult.WarningLines).Count -eq 0) -and (@($lintResult.WarningLines).Count -gt 0) -and ($lintJson.Text.TrimStart().StartsWith("{"))
Add-Check -Checks $checks -Name "Warning separation" -Passed $warningSeparated -Detail "searchWarnings=$(@($searchResult.WarningLines).Count); lintWarnings=$(@($lintResult.WarningLines).Count)"

$errorResult = Invoke-MxCliCommand -Arguments @("open", "--help") -WorkingDirectory $WorkingDirectory
$errorCaptured = $errorResult.ExitCode -ne 0 -and ((@($errorResult.ErrorLines) -join " ") -match 'unknown command')
Add-Check -Checks $checks -Name "Error capture" -Passed $errorCaptured -Detail "ExitCode=$($errorResult.ExitCode); Error=$((@($errorResult.ErrorLines) -join ' '))"

Write-Host ""
Write-Host "Catalog stage plan:" -ForegroundColor Yellow
foreach ($planItem in Get-MxCliCatalogStagePlan) {
    Write-Host "- $($planItem.Stage): $($planItem.Usage)"
}

Write-Host ""
foreach ($check in $checks) {
    $colour = if ($check.Passed) { "Green" } else { "Red" }
    $status = if ($check.Passed) { "PASS" } else { "FAIL" }
    Write-Host "$status | $($check.Name) | $($check.Detail)" -ForegroundColor $colour
}

$overallPass = (@($checks | Where-Object { -not $_.Passed }).Count -eq 0)
Write-Host ""
Write-Host ("Overall: " + $(if ($overallPass) { "PASS" } else { "FAIL" })) -ForegroundColor $(if ($overallPass) { "Green" } else { "Red" })

if (-not $overallPass) {
    exit 1
}
