[CmdletBinding()]
param(
    [string]$MprPath = "C:\Workspaces\Mendix\Smart Expenses app-main\App.mpr",
    [string]$MxExePath = "C:\Program Files\Mendix\10.24.15.93102\modeler\mx.exe",
    [string]$TempOutputRoot = ".app-info/smartexpenses-regression-output",
    [string]$AppName = "SmartExpenses",
    [string]$CustomScenariosPath = "KnowledgeBase-Creator/benchmarks/smartexpenses-custom-scenarios.json",
    [string]$ExistingDataRoot
)

$ErrorActionPreference = "Stop"

$scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$repoRoot = (Resolve-Path (Join-Path $scriptRoot "..\..")).Path
$runDumpParserScript = Join-Path $repoRoot "KnowledgeBase-Creator/wizard/run-dump-parser.ps1"
$resolverScript = Join-Path $repoRoot "KnowledgeBase-Creator/wizard/lib/app-overview-resolver.ps1"
. $resolverScript

function Write-JsonUtf8NoBom {
    param(
        [string]$Path,
        [object]$Value
    )

    $directory = Split-Path -Parent $Path
    if (-not [string]::IsNullOrWhiteSpace($directory) -and -not (Test-Path $directory -PathType Container)) {
        New-Item -Path $directory -ItemType Directory -Force | Out-Null
    }

    $json = $Value | ConvertTo-Json -Depth 10
    $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText($Path, $json + "`n", $utf8NoBom)
}

function Add-Issue {
    param(
        [System.Collections.Generic.List[object]]$IssueList,
        [string]$Check,
        [string]$File,
        [string]$Message
    )

    $IssueList.Add([pscustomobject]@{
        check = $Check
        file = $File
        message = $Message
    }) | Out-Null
}

function Get-FrontMatterMap {
    param([string]$FilePath)

    if (-not (Test-Path $FilePath -PathType Leaf)) { return @{} }

    $text = Get-Content -Raw $FilePath
    $match = [regex]::Match($text, '(?ms)\A---\s*(?<body>.*?)\s*---')
    if (-not $match.Success) { return @{} }

    $map = @{}
    foreach ($line in ($match.Groups["body"].Value -split "`r?`n")) {
        if ($line -notmatch '^\s*([^:]+):\s*(.*)$') { continue }
        $map[$matches[1].Trim()] = $matches[2].Trim()
    }

    return $map
}

function Resolve-MarkdownTarget {
    param(
        [string]$BaseFilePath,
        [string]$Target
    )

    if ([string]::IsNullOrWhiteSpace($Target)) { return $null }
    $clean = $Target.Split("#", 2)[0]
    if ([string]::IsNullOrWhiteSpace($clean)) { return $BaseFilePath }

    if ([System.IO.Path]::IsPathRooted($clean)) {
        return [System.IO.Path]::GetFullPath($clean)
    }

    return [System.IO.Path]::GetFullPath((Join-Path (Split-Path -Parent $BaseFilePath) $clean))
}

function Get-MarkdownLinks {
    param([string]$FilePath)

    if (-not (Test-Path $FilePath -PathType Leaf)) { return @() }

    $text = Get-Content -Raw $FilePath
    $text = [regex]::Replace($text, '(?ms)```.*?```', '')
    return [regex]::Matches($text, '\[[^\]]+\]\(([^)]+)\)')
}

function Get-MarkdownSectionBody {
    param(
        [string]$FilePath,
        [string]$Heading
    )

    if (-not (Test-Path $FilePath -PathType Leaf)) { return "" }

    $text = Get-Content -Raw $FilePath
    $headingPattern = '^' + [regex]::Escape($Heading) + '\s*$'
    $match = [regex]::Match($text, "(?ms)$headingPattern\s*(?<body>.*?)(?=^##\s+|\z)")
    if (-not $match.Success) { return "" }

    return $match.Groups["body"].Value.Trim()
}

function Test-PlaceholderBody {
    param([string]$Body)

    if ([string]::IsNullOrWhiteSpace($Body)) { return $true }

    $trimmed = $Body.Trim()
    if ($trimmed -match '^(?:-\s*)?(none|unknown|n/a)\.?$') { return $true }
    if ($trimmed -match '^(?:(?:-\s*)?(none|unknown|n/a)\.?\s*)+$') { return $true }
    return $false
}

function Test-UsefulSummaryText {
    param(
        [string]$Body,
        [string[]]$Keywords
    )

    if (Test-PlaceholderBody -Body $Body) { return $false }

    foreach ($keyword in @($Keywords)) {
        if ($Body -match $keyword) {
            return $true
        }
    }

    return $false
}

function Get-IndexItemCount {
    param([string]$IndexPath)

    if (-not (Test-Path $IndexPath -PathType Leaf)) { return 0 }
    $index = Get-Content -Raw $IndexPath | ConvertFrom-Json
    return @($index.items).Count
}

function Get-GeneratedObjectCount {
    param(
        [string]$DirectoryPath,
        [string]$Filter,
        [string[]]$ExcludeNames = @()
    )

    if (-not (Test-Path $DirectoryPath -PathType Container)) { return 0 }

    return @(
        Get-ChildItem -Path $DirectoryPath -Filter $Filter -File |
        Where-Object { $ExcludeNames -notcontains $_.Name }
    ).Count
}

function Invoke-SmartExpensesPipeline {
    param(
        [string]$ParserScriptPath,
        [string]$ResolvedMprPath,
        [string]$ResolvedMxExePath,
        [string]$ResolvedDataRoot,
        [string]$ResolvedAppName,
        [string]$ResolvedCustomScenariosPath
    )

    $envBackup = @{}
    $overrides = @{
        APP_NAME = $ResolvedAppName
        MPR_FILE_PATH = $ResolvedMprPath
        MENDIX_MX_EXE = $ResolvedMxExePath
        MENDIX_DATA_ROOT = $ResolvedDataRoot
        MENDIX_MODULES = "*"
        STRICT_MODE = "true"
        CUSTOM_SCENARIOS_PATH = $ResolvedCustomScenariosPath
    }

    foreach ($name in @($overrides.Keys)) {
        $envBackup[$name] = [Environment]::GetEnvironmentVariable($name)
        [Environment]::SetEnvironmentVariable($name, [string]$overrides[$name])
    }

    try {
        & powershell -NoProfile -ExecutionPolicy Bypass -File $ParserScriptPath
        if ($LASTEXITCODE -ne 0) {
            throw "run-dump-parser.ps1 failed with exit code $LASTEXITCODE"
        }
    }
    finally {
        foreach ($name in @($envBackup.Keys)) {
            [Environment]::SetEnvironmentVariable($name, $envBackup[$name])
        }
    }
}

function Convert-ToObjectArray {
    param([object]$Value)

    if ($null -eq $Value) { return @() }
    if ($Value -is [string]) { return @($Value) }
    if ($Value -is [System.Collections.IEnumerable]) {
        return @($Value | ForEach-Object { $_ })
    }
    return @($Value)
}

function Write-RegressionReport {
    param(
        [string]$KbRootPath,
        [string]$RunFolderPath,
        [string]$DataRootPath,
        [string]$GeneratedAtUtc,
        [object]$Checks,
        [object]$Issues
    )

    try {
        $reportDir = Join-Path $KbRootPath "_reports"
        if (-not (Test-Path $reportDir -PathType Container)) {
            New-Item -Path $reportDir -ItemType Directory -Force | Out-Null
        }

        $jsonPath = Join-Path $reportDir "smartexpenses-regression-latest.json"
        $mdPath = Join-Path $reportDir "smartexpenses-regression-latest.md"
        $checkArray = Convert-ToObjectArray -Value $Checks
        $issueArray = Convert-ToObjectArray -Value $Issues
        $overallPass = $issueArray.Count -eq 0

        $payload = [ordered]@{
            appName = $AppName
            generatedAtUtc = $GeneratedAtUtc
            kbRoot = $KbRootPath
            dataRoot = $DataRootPath
            runFolder = $RunFolderPath
            overallPass = $overallPass
            checkCount = $checkArray.Count
            checks = $checkArray
            issueCount = $issueArray.Count
            issues = $issueArray
        }
        Write-JsonUtf8NoBom -Path $jsonPath -Value $payload

        $lines = New-Object System.Collections.Generic.List[string]
        $lines.Add("# SmartExpenses Regression Report") | Out-Null
        $lines.Add("") | Out-Null
        $lines.Add("- App: $AppName") | Out-Null
        $lines.Add("- Generated at (UTC): $GeneratedAtUtc") | Out-Null
        $lines.Add("- Data root: $DataRootPath") | Out-Null
        $lines.Add("- Run folder: $RunFolderPath") | Out-Null
        $lines.Add("- Final verdict: $(if ($overallPass) { 'PASS' } else { 'FAIL' })") | Out-Null
        $lines.Add("") | Out-Null
        $lines.Add("## Checks") | Out-Null
        $lines.Add("") | Out-Null
        $lines.Add("| Check | Status | Detail |") | Out-Null
        $lines.Add("|---|---|---|") | Out-Null
        foreach ($check in @($checkArray)) {
            $lines.Add("| $($check.name) | $($check.status) | $($check.detail) |") | Out-Null
        }
        $lines.Add("") | Out-Null
        $lines.Add("## Issues") | Out-Null
        $lines.Add("") | Out-Null
        if ($issueArray.Count -eq 0) {
            $lines.Add("No issues.") | Out-Null
        }
        else {
            foreach ($issue in $issueArray) {
                $lines.Add("- [$($issue.check)] $($issue.file) :: $($issue.message)") | Out-Null
            }
        }

        [System.IO.File]::WriteAllText($mdPath, ($lines -join "`r`n") + "`r`n", (New-Object System.Text.UTF8Encoding($false)))

        return [pscustomobject]@{
            Json = $jsonPath
            Markdown = $mdPath
            OverallPass = $overallPass
        }
    }
    catch {
        throw "Write-RegressionReport failed: $($_.Exception.Message)"
    }
}

$resolvedMprPath = (Resolve-Path $MprPath -ErrorAction Stop).Path
$resolvedMxExePath = (Resolve-Path $MxExePath -ErrorAction Stop).Path
$resolvedCustomScenariosPath = (Resolve-Path (Join-Path $repoRoot $CustomScenariosPath) -ErrorAction Stop).Path
$tempOutputRootPath = Join-Path $repoRoot $TempOutputRoot
$runToken = (Get-Date).ToUniversalTime().ToString("yyyyMMddHHmmss")
$generatedRoot = if ([string]::IsNullOrWhiteSpace($ExistingDataRoot)) {
    Join-Path $tempOutputRootPath "run_$runToken"
} else {
    Split-Path -Parent (Resolve-Path $ExistingDataRoot -ErrorAction Stop).Path
}
$dataRoot = if ([string]::IsNullOrWhiteSpace($ExistingDataRoot)) {
    Join-Path $generatedRoot "mendix-data"
} else {
    (Resolve-Path $ExistingDataRoot -ErrorAction Stop).Path
}
$kbRoot = Join-Path $dataRoot "knowledge-base"
$generatedAtUtc = [DateTime]::UtcNow.ToString("o")

if ([string]::IsNullOrWhiteSpace($ExistingDataRoot)) {
    New-Item -ItemType Directory -Path $generatedRoot -Force | Out-Null
}

Write-Host ""
Write-Host "=== SmartExpenses Regression ===" -ForegroundColor Cyan
Write-Host "MPR:         $resolvedMprPath"
Write-Host "mx.exe:      $resolvedMxExePath"
Write-Host "Data root:   $dataRoot"
Write-Host "Benchmark:   $resolvedCustomScenariosPath"

if ([string]::IsNullOrWhiteSpace($ExistingDataRoot)) {
    Invoke-SmartExpensesPipeline `
        -ParserScriptPath $runDumpParserScript `
        -ResolvedMprPath $resolvedMprPath `
        -ResolvedMxExePath $resolvedMxExePath `
        -ResolvedDataRoot $dataRoot `
        -ResolvedAppName $AppName `
        -ResolvedCustomScenariosPath $resolvedCustomScenariosPath
} elseif (-not (Test-Path $kbRoot -PathType Container)) {
    throw "ExistingDataRoot does not contain knowledge-base output: $kbRoot"
}

$runFolder = Resolve-OverviewRunFolderFromKnowledgeBase -KbRootPath $kbRoot
if ([string]::IsNullOrWhiteSpace($runFolder)) {
    throw "Could not resolve source run folder from generated SmartExpenses KB: $kbRoot"
}
$runFolder = (Resolve-Path $runFolder).Path

try {
    $issues = New-Object System.Collections.Generic.List[object]
    $checks = New-Object System.Collections.Generic.List[object]

    $layeredFiles = @(
        Get-ChildItem -Path $kbRoot -Recurse -Include *.abstract.md, *.overview.md -File
    )

    foreach ($file in @($layeredFiles)) {
        $frontMatter = Get-FrontMatterMap -FilePath $file.FullName
        if (-not $frontMatter.ContainsKey("l2Path")) {
            Add-Issue -IssueList $issues -Check "layered-l2-paths" -File $file.FullName -Message "Missing front-matter l2Path."
            continue
        }

        $resolvedTarget = Resolve-MarkdownTarget -BaseFilePath $file.FullName -Target ([string]$frontMatter["l2Path"])
        if ([string]::IsNullOrWhiteSpace($resolvedTarget) -or -not (Test-Path $resolvedTarget -PathType Leaf)) {
            Add-Issue -IssueList $issues -Check "layered-l2-paths" -File $file.FullName -Message "Front-matter l2Path does not resolve: $([string]$frontMatter["l2Path"])"
        }
    }
    $checks.Add([pscustomobject]@{
        name = "Layered L2 links"
        status = if (@($issues | Where-Object { $_.check -eq "layered-l2-paths" }).Count -eq 0) { "PASS" } else { "FAIL" }
        detail = "Checked $($layeredFiles.Count) *.abstract.md/*.overview.md files for a resolvable front-matter l2Path."
    }) | Out-Null

    foreach ($routeFile in @(
        (Join-Path $kbRoot "routes/by-flow.md"),
        (Join-Path $kbRoot "routes/by-page.md")
    )) {
        foreach ($match in @(Get-MarkdownLinks -FilePath $routeFile)) {
            $target = $match.Groups[1].Value
            if ($target -match '^(https?|mailto):') { continue }
            $resolvedTarget = Resolve-MarkdownTarget -BaseFilePath $routeFile -Target $target
            if ([string]::IsNullOrWhiteSpace($resolvedTarget) -or -not (Test-Path $resolvedTarget)) {
                Add-Issue -IssueList $issues -Check "route-links" -File $routeFile -Message "Broken route link: $target"
            }
        }
    }
    $checks.Add([pscustomobject]@{
        name = "Route links"
        status = if (@($issues | Where-Object { $_.check -eq "route-links" }).Count -eq 0) { "PASS" } else { "FAIL" }
        detail = "Checked markdown links in routes/by-flow.md and routes/by-page.md."
    }) | Out-Null

    $controlCharPattern = "[\x00-\x08\x0B\x0C\x0E-\x1F\x7F]"
    foreach ($markdownFile in @(Get-ChildItem -Path $kbRoot -Recurse -Filter *.md -File)) {
        $content = Get-Content -Raw $markdownFile.FullName
        if ($content -match $controlCharPattern) {
            Add-Issue -IssueList $issues -Check "control-chars" -File $markdownFile.FullName -Message "Control characters detected in generated markdown."
        }
    }
    $checks.Add([pscustomobject]@{
        name = "Control characters"
        status = if (@($issues | Where-Object { $_.check -eq "control-chars" }).Count -eq 0) { "PASS" } else { "FAIL" }
        detail = "Scanned all generated markdown for control characters outside CR/LF/TAB."
    }) | Out-Null

    $placeholderPatterns = @(
        "product-owner intent text is not included in export",
        "No Tier 1 deep narratives documented yet",
        "No entity index documented yet",
        "No page index documented yet"
    )
    foreach ($readmeFile in @(Get-ChildItem -Path $kbRoot -Recurse -Filter README.md -File)) {
        $content = Get-Content -Raw $readmeFile.FullName
        foreach ($pattern in @($placeholderPatterns)) {
            if ($content -match [regex]::Escape($pattern)) {
                Add-Issue -IssueList $issues -Check "placeholder-phrases" -File $readmeFile.FullName -Message "Placeholder phrase still present: $pattern"
            }
        }
    }
    $checks.Add([pscustomobject]@{
        name = "README placeholders"
        status = if (@($issues | Where-Object { $_.check -eq "placeholder-phrases" }).Count -eq 0) { "PASS" } else { "FAIL" }
        detail = "Scanned generated README.md files for known placeholder phrases."
    }) | Out-Null

    $smartExpensesModuleDir = Join-Path $kbRoot "modules/SmartExpenses"
    $smartExpensesCurrentDir = Join-Path (Join-Path (Split-Path -Parent $runFolder) "current") "modules/SmartExpenses"
    $flowIndexPath = Join-Path $smartExpensesCurrentDir "flows/INDEX.json"
    $pageIndexPath = Join-Path $smartExpensesCurrentDir "pages/INDEX.json"
    $expectedFlowCount = Get-IndexItemCount -IndexPath $flowIndexPath
    $expectedPageCount = Get-IndexItemCount -IndexPath $pageIndexPath
    $actualFlowAbstractCount = Get-GeneratedObjectCount -DirectoryPath (Join-Path $smartExpensesModuleDir "flows") -Filter *.abstract.md -ExcludeNames @("INDEX.abstract.md")
    $actualFlowOverviewCount = Get-GeneratedObjectCount -DirectoryPath (Join-Path $smartExpensesModuleDir "flows") -Filter *.overview.md
    $actualPageAbstractCount = Get-GeneratedObjectCount -DirectoryPath (Join-Path $smartExpensesModuleDir "pages") -Filter *.abstract.md -ExcludeNames @("INDEX.abstract.md")
    $actualPageOverviewCount = Get-GeneratedObjectCount -DirectoryPath (Join-Path $smartExpensesModuleDir "pages") -Filter *.overview.md

    if ($expectedFlowCount -ne $actualFlowAbstractCount) {
        Add-Issue -IssueList $issues -Check "count-parity" -File (Join-Path $smartExpensesModuleDir "flows") -Message "SmartExpenses flow abstract count mismatch: expected $expectedFlowCount from INDEX.json, found $actualFlowAbstractCount."
    }
    if ($expectedFlowCount -ne $actualFlowOverviewCount) {
        Add-Issue -IssueList $issues -Check "count-parity" -File (Join-Path $smartExpensesModuleDir "flows") -Message "SmartExpenses flow overview count mismatch: expected $expectedFlowCount from INDEX.json, found $actualFlowOverviewCount."
    }
    if ($expectedPageCount -ne $actualPageAbstractCount) {
        Add-Issue -IssueList $issues -Check "count-parity" -File (Join-Path $smartExpensesModuleDir "pages") -Message "SmartExpenses page abstract count mismatch: expected $expectedPageCount from INDEX.json, found $actualPageAbstractCount."
    }
    if ($expectedPageCount -ne $actualPageOverviewCount) {
        Add-Issue -IssueList $issues -Check "count-parity" -File (Join-Path $smartExpensesModuleDir "pages") -Message "SmartExpenses page overview count mismatch: expected $expectedPageCount from INDEX.json, found $actualPageOverviewCount."
    }
    $checks.Add([pscustomobject]@{
        name = "Count parity"
        status = if (@($issues | Where-Object { $_.check -eq "count-parity" }).Count -eq 0) { "PASS" } else { "FAIL" }
        detail = "Flows: expected $expectedFlowCount, abstracts $actualFlowAbstractCount, overviews $actualFlowOverviewCount. Pages: expected $expectedPageCount, abstracts $actualPageAbstractCount, overviews $actualPageOverviewCount."
    }) | Out-Null

    $pageOverviewFiles = @(Get-ChildItem -Path (Join-Path $smartExpensesModuleDir "pages") -Filter *.overview.md -File -ErrorAction SilentlyContinue)
    foreach ($pageOverviewFile in @($pageOverviewFiles)) {
        $summaryBody = Get-MarkdownSectionBody -FilePath $pageOverviewFile.FullName -Heading "## Summary"
        if (-not (Test-UsefulSummaryText -Body $summaryBody -Keywords @("likely", "supports", "appears", "serves", "reached", "navigation", "interaction"))) {
            Add-Issue -IssueList $issues -Check "l1-usefulness" -File $pageOverviewFile.FullName -Message "Page summary is too weak to guide navigation."
        }

        foreach ($heading in @(
            "## Datasource Summary",
            "## Client Actions",
            "## Shown by Flows",
            "## Navigation/Homepage Provenance"
        )) {
            $body = Get-MarkdownSectionBody -FilePath $pageOverviewFile.FullName -Heading $heading
            if (Test-PlaceholderBody -Body $body) {
                Add-Issue -IssueList $issues -Check "l1-usefulness" -File $pageOverviewFile.FullName -Message "$heading collapses to a placeholder instead of explanatory guidance."
            }
        }
    }

    $flowOverviewFiles = @(Get-ChildItem -Path (Join-Path $smartExpensesModuleDir "flows") -Filter *.overview.md -File -ErrorAction SilentlyContinue)
    foreach ($flowOverviewFile in @($flowOverviewFiles)) {
        $summaryBody = Get-MarkdownSectionBody -FilePath $flowOverviewFile.FullName -Heading "## Summary"
        if (-not (Test-UsefulSummaryText -Body $summaryBody -Keywords @("likely", "acts", "shows", "save", "process", "background", "validation", "navigation", "handler"))) {
            Add-Issue -IssueList $issues -Check "l1-usefulness" -File $flowOverviewFile.FullName -Message "Flow summary is too weak to guide navigation."
        }

        foreach ($heading in @(
            "## Trigger/Input/Output Context",
            "## Shown Pages"
        )) {
            $body = Get-MarkdownSectionBody -FilePath $flowOverviewFile.FullName -Heading $heading
            if (Test-PlaceholderBody -Body $body) {
                Add-Issue -IssueList $issues -Check "l1-usefulness" -File $flowOverviewFile.FullName -Message "$heading collapses to a placeholder instead of explanatory guidance."
            }
        }
    }
    $checks.Add([pscustomobject]@{
        name = "L1 usefulness"
        status = if (@($issues | Where-Object { $_.check -eq "l1-usefulness" }).Count -eq 0) { "PASS" } else { "FAIL" }
        detail = "Checked SmartExpenses page and flow overview summaries plus provenance-related sections for explanatory wording."
    }) | Out-Null

    $reportDir = Join-Path $kbRoot "_reports"
    if (-not (Test-Path $reportDir -PathType Container)) {
        New-Item -Path $reportDir -ItemType Directory -Force | Out-Null
    }
    $checkArray = Convert-ToObjectArray -Value $checks
    $issueArray = Convert-ToObjectArray -Value $issues
    $reportJsonPath = Join-Path $reportDir "smartexpenses-regression-latest.json"
    $reportMarkdownPath = Join-Path $reportDir "smartexpenses-regression-latest.md"
    $overallPass = $issueArray.Count -eq 0

    $reportPayload = [ordered]@{
        appName = $AppName
        generatedAtUtc = $generatedAtUtc
        kbRoot = $kbRoot
        dataRoot = $dataRoot
        runFolder = $runFolder
        overallPass = $overallPass
        checkCount = $checkArray.Count
        checks = $checkArray
        issueCount = $issueArray.Count
        issues = $issueArray
    }
    Write-JsonUtf8NoBom -Path $reportJsonPath -Value $reportPayload

    $reportLines = New-Object System.Collections.Generic.List[string]
    $reportLines.Add("# SmartExpenses Regression Report") | Out-Null
    $reportLines.Add("") | Out-Null
    $reportLines.Add("- App: $AppName") | Out-Null
    $reportLines.Add("- Generated at (UTC): $generatedAtUtc") | Out-Null
    $reportLines.Add("- Data root: $dataRoot") | Out-Null
    $reportLines.Add("- Run folder: $runFolder") | Out-Null
    $reportLines.Add("- Final verdict: $(if ($overallPass) { 'PASS' } else { 'FAIL' })") | Out-Null
    $reportLines.Add("") | Out-Null
    $reportLines.Add("## Checks") | Out-Null
    $reportLines.Add("") | Out-Null
    $reportLines.Add("| Check | Status | Detail |") | Out-Null
    $reportLines.Add("|---|---|---|") | Out-Null
    foreach ($check in @($checkArray)) {
        $reportLines.Add("| $($check.name) | $($check.status) | $($check.detail) |") | Out-Null
    }
    $reportLines.Add("") | Out-Null
    $reportLines.Add("## Issues") | Out-Null
    $reportLines.Add("") | Out-Null
    if ($issueArray.Count -eq 0) {
        $reportLines.Add("No issues.") | Out-Null
    }
    else {
        foreach ($issue in @($issueArray)) {
            $reportLines.Add("- [$($issue.check)] $($issue.file) :: $($issue.message)") | Out-Null
        }
    }

    [System.IO.File]::WriteAllText($reportMarkdownPath, ($reportLines -join "`r`n") + "`r`n", (New-Object System.Text.UTF8Encoding($false)))
    $report = [pscustomobject]@{
        Json = $reportJsonPath
        Markdown = $reportMarkdownPath
        OverallPass = $overallPass
    }

    Write-Host ""
    Write-Host "Regression report: $($report.Markdown)"
    Write-Host "KB root:           $kbRoot"
    Write-Host "Run folder:        $runFolder"

    if (-not $report.OverallPass) {
        Write-Host ""
        Write-Host "SmartExpenses regression FAILED." -ForegroundColor Red
        foreach ($issue in @($issueArray)) {
            Write-Host " - [$($issue.check)] $($issue.file) :: $($issue.message)" -ForegroundColor Red
        }
        exit 1
    }

    Write-Host ""
    Write-Host "SmartExpenses regression passed." -ForegroundColor Green
}
catch {
    Write-Host ""
    Write-Host ("SmartExpenses regression post-check failed: " + $_.Exception.Message) -ForegroundColor Red
    if ($_.InvocationInfo -and -not [string]::IsNullOrWhiteSpace($_.InvocationInfo.PositionMessage)) {
        Write-Host $_.InvocationInfo.PositionMessage -ForegroundColor Red
    }
    if (-not [string]::IsNullOrWhiteSpace($_.ScriptStackTrace)) {
        Write-Host $_.ScriptStackTrace -ForegroundColor Red
    }
    exit 1
}
